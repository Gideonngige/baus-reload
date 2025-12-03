import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase_summary_screen.dart';
import '../widgets/message_pop.dart';
import 'package:baustaka/config/palette.dart';

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const CreateOrderScreen({super.key, required this.item});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _quantityController = TextEditingController();

  bool isLoading = false;
  bool loadingShipment = false;

  double shipmentCost = 0;
  double itemTotal = 0;
  double finalTotal = 0;

  double? userLat;
  double? userLng;
  String? locationName;

  String baseUrl = "http://192.168.100.5:5363";

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }


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
    setState(() => loadingShipment = true);

    final item = widget.item;

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUser = prefs.getString("user");

      if (storedUser == null) {
        showBaustakaMessage(context, "Login required");
        return;
      }

      final user = jsonDecode(storedUser);

      final response = await http.post(
        Uri.parse("$baseUrl/v1/shipment/calculate/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "buyer_lat": userLat,
          "buyer_lng": userLng,
          "seller_lat": item["latitude"],
          "seller_lng": item["longitude"],
          "weight": quantity,
          "vehicleType": "truck"
        }),
      );

      final data = jsonDecode(response.body);

      shipmentCost = data["data"]["cost"].toDouble();
      itemTotal = (double.parse(item["price"].toString()) * quantity);
      finalTotal = itemTotal + shipmentCost;

    } catch (e) {
      showBaustakaMessage(context, "Failed to calculate shipment");
    }

    setState(() => loadingShipment = false);
  }

  // ============================
  // PLACE ORDER
  // ============================

  Future<void> _handleBuyNow() async {
    final qtyText = _quantityController.text.trim();

    if (qtyText.isEmpty || double.tryParse(qtyText) == null) {
      showBaustakaMessage(context, "Enter valid quantity");
      return;
    }

    if (shipmentCost <= 0) {
      showBaustakaMessage(context, "Calculating shipping, please wait...");
      return;
    }

    final quantity = double.parse(qtyText);
    final item = widget.item;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final storedUser = prefs.getString('user');

      if (token == null || storedUser == null) {
        showBaustakaMessage(context, 'Please sign in again');
        return;
      }

      final user = jsonDecode(storedUser);
      var phone = user['phoneNumber'];
      if (phone.startsWith('+')) phone = phone.substring(1);
      if (phone.startsWith('0')) {
        phone = '254' + phone.substring(1);
      }

      final buyer = user['_id'];
      final listing = item['_id'];

      final url = Uri.parse("$baseUrl/v1/mpesa/stkpush/");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phone,
          'quantity': quantity,
          'totalPrice': finalTotal,
          'shipmentCost': shipmentCost,
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
        showBaustakaMessage(context, 'Payment initiation failed.');
        return;
      }

      final data = jsonDecode(response.body);
      final checkoutRequestID = data['CheckoutRequestID'];

      if (checkoutRequestID == null) {
        showBaustakaMessage(context, 'Invalid payment response');
        return;
      }

      showBaustakaMessage(context, "Enter M-Pesa PIN");

      _pollPaymentStatus(checkoutRequestID, quantity, item);

    } catch (e) {
      setState(() => isLoading = false);
      showBaustakaMessage(context, "Order Failed");
    }
  }

  // ============================
  // MPESA STATUS POLL
  // ============================

  void _pollPaymentStatus(String checkoutRequestID, double quantity, Map<String, dynamic> item) {
    const pollInterval = Duration(seconds: 3);

    Timer.periodic(pollInterval, (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = Uri.parse("$baseUrl/v1/mpesa/stkpush/status");

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
        showBaustakaMessage(context, "Payment Successful");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PurchaseSummaryScreen(
              itemName: item['title'],
              price: finalTotal,
              quantity: quantity.toInt(),
              paymentMethod: 'M-Pesa',
            ),
          ),
        );

      } else {
        showBaustakaMessage(context, "Payment Failed");
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
        title: const Text("Create Order", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Image.network("$baseUrl${item['image']}", height: 120),

            const SizedBox(height: 15),

            Text(
              item["title"],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text("Location: ${item['locationName']}",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16)),

            const SizedBox(height: 6),
            Text("Price: Ksh ${item['price']}/kg",
                style: TextStyle(color: Palette.primary, fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            Text("Available: Kg ${item['weight']}",
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
      showBaustakaMessage(context, "Only $availableQty units available");
      _quantityController.text = availableQty.toInt().toString();
      return;
    }

    calculateShipment(q);
  },
  decoration: const InputDecoration(
    labelText: "Quantity",
    filled: true,
    border: OutlineInputBorder(),
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

                    _priceRow("Item Total", "Ksh ${itemTotal.toStringAsFixed(0)}"),

                    _priceRow("Shipment",
                        loadingShipment ? "Calculating..." : "Ksh ${shipmentCost.toStringAsFixed(0)}"),

                    const Divider(),

                    _priceRow("Total Payable",
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
                  isLoading ? "Processing..." : "Pay Now",
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
