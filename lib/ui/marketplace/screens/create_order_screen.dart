import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase_summary_screen.dart';
import '../widgets/message_pop.dart';

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item; // item details (from listing)
  const CreateOrderScreen({super.key, required this.item});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _quantityController = TextEditingController();
  bool isLoading = false;
  String baseUrl = 'http://192.168.100.5:5363';

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleBuyNow() async {
  final qtyText = _quantityController.text.trim();

  if (qtyText.isEmpty || double.tryParse(qtyText) == null) {
    showBaustakaMessage(context, 'Please enter a valid quantity.');
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
      showBaustakaMessage(context, 'Please sign in again.');
      return;
    }

    final user = jsonDecode(storedUser);
    var phone = user['phoneNumber'];
    if (phone.startsWith('+')) phone = phone.substring(1);

    final buyer = user['_id'];
    final listing = item['_id'];
    final price = double.tryParse(item['price'].toString()) ?? 0;
    final totalPrice = price * quantity;

    // 🔹 STEP 1: Initiate STK PUSH
    final url = Uri.parse('$baseUrl/v1/mpesa/stkpush/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'quantity': quantity,
        'totalPrice': totalPrice,
        'paymentMethod': 'M-Pesa',
        'latitude': -1.2921,
        'longitude': 36.8219,
        'locationName': 'Nairobi, Kenya',
        'buyer': buyer,
        'listing': listing,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode != 200) {
      showBaustakaMessage(context, 'Failed to initiate payment.');
      return;
    }

    final data = jsonDecode(response.body);
    print(data);

    // 🔹 This must come from backend
    final checkoutRequestID = data['CheckoutRequestID'];
    if (checkoutRequestID == null) {
      showBaustakaMessage(context, 'Missing checkoutRequestID from server.');
      return;
    }

    showBaustakaMessage(context, "Enter your M-Pesa PIN...");

    // 🔹 STEP 2: Start Polling Payment Status
    _pollPaymentStatus(checkoutRequestID, quantity, item);

  } catch (e) {
    setState(() => isLoading = false);
    showBaustakaMessage(context, 'Error placing order: $e');
  }
}

// function to poll
void _pollPaymentStatus(
    String checkoutRequestID, double quantity, Map<String, dynamic> item) {
  const pollInterval = Duration(seconds: 3);

  Timer.periodic(pollInterval, (timer) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('$baseUrl/v1/mpesa/stkpush/status');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "CheckoutRequestID": checkoutRequestID,
      }),
    );

    if (response.statusCode != 200) return;

    final data = jsonDecode(response.body);

    final status = data['status'];

    if (status == "pending") return; // keep polling

    // stop polling
    timer.cancel();

    if (status == "successful") {
      showBaustakaMessage(context, "Payment Successful!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PurchaseSummaryScreen(
            itemName: item['title'],
            price: double.tryParse(item['price'].toString()) ?? 0,
            quantity: quantity.toInt(),
            paymentMethod: 'M-Pesa',
          ),
        ),
      );
    } else {
      showBaustakaMessage(context, "Payment Failed. Try again.");
    }
  });
}


  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Order',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Center(
              child: Image.network(
                '$baseUrl${item['image']}' ?? 'https://via.placeholder.com/150',
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            //  Item Name
            Text(
              item['title'] ?? 'Item name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            //  Price
            Text(
              "Price: Ksh. ${item['price']}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),

            const SizedBox(height: 25),

            //  Quantity Field
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                label: Text(
                  'Enter Quantity',
                  style: TextStyle(color: Colors.green[800]),
                ),
                hintText: 'e.g. 5',
                prefixIcon: Icon(Icons.scale, color: Colors.green[800]),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Colors.green, width: 1.8),
                ),
              ),
            ),

            const SizedBox(height: 30),

            //  Buy Now Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _handleBuyNow,
                icon: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.shopping_cart_checkout_rounded,
                        color: Colors.white),
                label: Text(
                  isLoading ? "Processing..." : 'Buy Now',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info
            const Text(
              "Once you click Buy Now, you'll be redirected to complete payment via M-Pesa.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}