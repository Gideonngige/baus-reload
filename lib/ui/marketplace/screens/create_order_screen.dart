import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase_summary_screen.dart';
import '../widgets/message_pop.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/env.dart';
import '../helper/location_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum DeliveryMethod {
  baustaka,
  selfArrangement,
  pickup,
}

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const CreateOrderScreen({super.key, required this.item});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _quantityController = TextEditingController();

DeliveryMethod _deliveryMethod = DeliveryMethod.baustaka;


  bool isLoading = false;
  bool loadingShipment = false;

  double shipmentCost = 0;
  double itemTotal = 0;
  double finalTotal = 0;

  double? userLat;
  double? userLng;
  String? locationName;

  void _recalculateOrder() {
  final q = double.tryParse(_quantityController.text);
  if (q == null || q <= 0) return;

  calculateShipment(q);
}


  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

bool isBulky = false;
bool requiresQuote = false;
String? deliveryNote;


@override
void initState() {
  super.initState();
  loadLocation();
}

Future<void> loadLocation() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    userLat = prefs.getDouble("latitude");
    userLng = prefs.getDouble("longitude");
    locationName = prefs.getString("locationName");
  });
}

  // ============================
  // SHIPMENT COST API CALL
  // ============================

  Future<void> calculateShipment(double quantity) async {
  final price = double.parse(widget.item["price"].toString());
  itemTotal = price * quantity;

  final bool bulky = widget.item["isBulky"] == true || quantity > 30;

  // 1️⃣ NOT Baustaka → free delivery
  if (_deliveryMethod != DeliveryMethod.baustaka) {
    setState(() {
      shipmentCost = 0;
      finalTotal = itemTotal;
      requiresQuote = false;
      deliveryNote = _deliveryMethod == DeliveryMethod.pickup
          ? "delivery_pick_alert".tr
          : "delivery_self_alert".tr;
    });
    return;
  }

  // 2️⃣ Baustaka + bulky → quote on request
  if (bulky) {
    setState(() {
      shipmentCost = 0;
      finalTotal = itemTotal;
      requiresQuote = true;
      deliveryNote = "Delivery: Quote on request";
    });
    return;
  }

  // 3️⃣ Baustaka + NOT bulky → auto pricing
  if (userLat == null || userLng == null) {
    Util.toast("User location not available");
    return;
  }

  setState(() {
    loadingShipment = true;
    requiresQuote = false;
    deliveryNote = null;
  });

  final sellerLat = widget.item["latitude"];
  final sellerLng = widget.item["longitude"];
  final distanceKm = calculateDistanceKm(userLat!, userLng!, sellerLat, sellerLng);
  final zone = getDeliveryZone(distanceKm);

  // Update delivery note with zone
  setState(() => deliveryNote = "delivery_note".tr + ' $zone');

  try {
    final response = await http.post(
      Uri.parse("${kBaseApiUrl}v1/shipment/calculate/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "buyer_lat": userLat,
        "buyer_lng": userLng,
        "seller_lat": sellerLat,
        "seller_lng": sellerLng,
        "weight": quantity,
        "zone": zone, // send zone to backend
      }),
    );

    if (response.statusCode != 200) throw "Shipment API failed";

    final data = jsonDecode(response.body);
    shipmentCost = data["data"]["cost"].toDouble();
    finalTotal = itemTotal + shipmentCost;
  } catch (e) {
    Util.toast("Failed to calculate shipment");
    shipmentCost = 0;
    finalTotal = itemTotal;
  } finally {
    setState(() => loadingShipment = false);
  }
}





  // ============================
  // PLACE ORDER
  // ============================

  Future<void> _handleBuyNow() async {
  final qtyText = _quantityController.text.trim();

  if (qtyText.isEmpty || double.tryParse(qtyText) == null) {
    Util.toast("Enter valid quantity");
    return;
  }

  final quantity = double.parse(qtyText);
  final item = widget.item;

  // Determine the shipment cost for payment
  final double shipmentToPay = requiresQuote ? 0 : shipmentCost;
  final double totalToPay = itemTotal + shipmentToPay;

  setState(() => isLoading = true);

  try {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final token = await firebaseUser!.getIdToken(true);
    final storedUser = prefs.getString('user');

    if (token == null || storedUser == null) {
      Util.toast("Please sign in again");
      setState(() => isLoading = false);
      return;
    }

    final user = jsonDecode(storedUser);
    var phone = user['phoneNumber'].toString().trim();

    if (phone.startsWith('+')) phone = phone.substring(1);
    if (phone.startsWith('0')) phone = '254' + phone.substring(1);

    final buyer = user['_id'];
    final listing = item['_id'];

    final url = Uri.parse("${kBaseApiUrl}v1/mpesa/stkpush/");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'quantity': quantity,
        'totalPrice': totalToPay,
        'shipmentCost': shipmentToPay,
        'deliveryMethod': _deliveryMethod.name,
        'paymentMethod': 'mpesa',
        'buyer': buyer,
        'listing': listing,
        'latitude': userLat,
        'longitude': userLng,
        'locationName': locationName,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode != 200) {
      Util.toast("Payment initiation failed.");
      return;
    }

    final data = jsonDecode(response.body);
    final checkoutRequestID = data['CheckoutRequestID'];

    if (checkoutRequestID == null) {
      Util.toast("Invalid payment response.");
      return;
    }

    Util.toast("Enter M-Pesa PIN");

    _pollPaymentStatus(checkoutRequestID, quantity, item);
  } catch (e) {
    setState(() => isLoading = false);
    Util.toast("Order Failed");
  }
}


  // ============================
  // MPESA STATUS POLL
  // ============================

  void _pollPaymentStatus(String checkoutRequestID, double quantity, Map<String, dynamic> item) {
    const pollInterval = Duration(seconds: 3);

    Timer.periodic(pollInterval, (timer) async {
      final prefs = await SharedPreferences.getInstance();
      // final token = prefs.getString('token');
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final token = await firebaseUser!.getIdToken(true);

      final url = Uri.parse("${kBaseApiUrl}v1/mpesa/stkpush/status");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({ "CheckoutRequestID": checkoutRequestID }),
      );

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body);
      final status = data['status'];

      if (status == "pending") return;

      timer.cancel();

      if (status == "paid") {
        Util.toast("Payment Successful");

        // Seller info from the item
      final sellerInfo = {
        "name": item['seller']?['displayName'] ?? "N/A",
        "phone": item['seller']?['phoneNumber'] ?? "N/A",
        "location": item['locationName'] ?? "N/A",
      };

      // Note if shipment was quote-on-request
      final shipmentNote = requiresQuote ? "Delivery cost will be confirmed before dispatch." : null;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PurchaseSummaryScreen(
              itemName: item['title'],
              price: finalTotal,
              quantity: quantity.toInt(),
              paymentMethod: 'M-Pesa',
              sellerInfo: sellerInfo,      // passing seller info
              shipmentNote: shipmentNote, 
            ),
          ),
        );

      } else {
        Util.toast("Payment Failed");
      }
    });
  }

  // ============================
  // UI
  // ============================

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final availableQty = double.tryParse(item["weight"].toString()) ?? 0;


    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Palette.primary,
        leading: BackButton(color: Colors.white),
        title: Text("create_order".tr, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Image.network("$kBaseImageUrl${item['image']}", height: 120),

            const SizedBox(height: 15),

            Text(
              item["title"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text("location".tr + ": ${item['locationName']}",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),

            const SizedBox(height: 6),
            Text("price".tr + ": Ksh ${item['price']}/kg",
                style: TextStyle(color: Palette.primary, fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            Text("available".tr + ": ${item['weight']} Kg",
                style: TextStyle(color: Palette.primary, fontWeight: FontWeight.w600)),

            const SizedBox(height: 20),

            // QUANTITY
            TextField(
  controller: _quantityController,
  keyboardType: TextInputType.number,
  onChanged: (v) {
    final q = double.tryParse(v);
    if (q == null || q <= 0) return;

    if (q > availableQty) {
      Util.toast("Only $availableQty units available");
      _quantityController.text = availableQty.toInt().toString();
      return;
    }

    _recalculateOrder();
  },
  decoration: InputDecoration(
    labelText: "quantity".tr,
    filled: true,
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 20),

Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "delivery_method".tr,
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
  ),
),

const SizedBox(height: 10),

Card(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Column(
    children: [

      RadioListTile<DeliveryMethod>(
        value: DeliveryMethod.baustaka,
        groupValue: _deliveryMethod,
        title: Text("delivery_by_baustaka".tr),
        subtitle: Text("delivery_sub_tittle_baustaka".tr),
        onChanged: (value) {
          setState(() {
            _deliveryMethod = value!;
            shipmentCost = 0;
            finalTotal = 0;
          });

          // Recalculate shipment if quantity exists
          final q = double.tryParse(_quantityController.text);
          if (q != null && q > 0) {
            _recalculateOrder();
          }
        },
      ),

      RadioListTile<DeliveryMethod>(
        value: DeliveryMethod.selfArrangement,
        groupValue: _deliveryMethod,
        title: Text("delivery_by_self_arragement_with_seller".tr),
        subtitle: Text("delivery_sub_tittle_self_arragement_with_seller".tr),
        onChanged: (value) {
          setState(() {
            _deliveryMethod = value!;
            shipmentCost = 0;
            finalTotal = itemTotal;
          });
          _recalculateOrder();
        },
      ),

      RadioListTile<DeliveryMethod>(
        value: DeliveryMethod.pickup,
        groupValue: _deliveryMethod,
        title: Text("delivery_pick_from_seller".tr),
        subtitle: Text("delivery_sub_tittle_pick_from_seller".tr),
        onChanged: (value) {
          setState(() {
            _deliveryMethod = value!;
            shipmentCost = 0;
            finalTotal = itemTotal;
          });
          _recalculateOrder();
        },
      ),

    ],
  ),
),


if (deliveryNote != null)
  Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.orange),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            deliveryNote!,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  ),




            const SizedBox(height: 20),

            // PRICE CARD
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    _priceRow("item_total".tr, "Ksh ${itemTotal.toStringAsFixed(0)}"),

                    _priceRow("shipment_cost".tr,requiresQuote ? "Quote on request" :
                        loadingShipment ? "Calculating..." : "Ksh ${shipmentCost.toStringAsFixed(0)}"),

                    const Divider(),

                    _priceRow("total_payable".tr,
                        "Ksh ${finalTotal.toStringAsFixed(0)}", isBold: true),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BUY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _handleBuyNow,
                icon: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                label: Text(
                  isLoading ? "Processing..." : "pay".tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500)),
          Text(value,
              style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}
