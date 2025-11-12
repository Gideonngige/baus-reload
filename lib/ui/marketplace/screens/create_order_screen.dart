import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'purchase_summary_screen.dart';

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic> item; // item details (from listing)
  const CreateOrderScreen({super.key, required this.item});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final TextEditingController _quantityController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _handleBuyNow() async {
    final qtyText = _quantityController.text.trim();

    if (qtyText.isEmpty || double.tryParse(qtyText) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid quantity."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final quantity = double.parse(qtyText);
    final item = widget.item;

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
    //   final token = prefs.getString('token');
    //   final storedUser = prefs.getString('user');

      final token = 'dummy_token_12345';
final storedUser = '{"id": 1, "name": "Test Seller", "email": "seller@test.com"}';

      if (token == null || storedUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please sign in again.")),
        );
        return;
      }

      final user = jsonDecode(storedUser);
      final buyerId = user['id'];
      final listingId = item['id'];
      final price = double.tryParse(item['price'].toString()) ?? 0;
      final totalPrice = price * quantity;

      // Make API request
      final url = Uri.parse('https://baustaka-backend.onrender.com/api/orders/create');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'quantity': quantity,
          'totalPrice': totalPrice,
          'paymentMethod': 'M-Pesa',
          'latitude': -1.2921,
          'longitude': 36.8219,
          'locationName': 'Nairobi, Kenya',
          'buyerId': buyerId,
          'listingId': listingId,
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order placed successfully!"),
            backgroundColor: Colors.green[800],
          ),
        );

        // Navigate to purchase summary screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PurchaseSummaryScreen(
              itemName: item['title'] ?? 'Item name',
              price: double.tryParse(item['price'].toString()) ?? 0,
              quantity: quantity.toInt(),
              paymentMethod: 'M-Pesa',
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${error['message'] ?? 'Error'}")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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
                item['image'] ?? 'https://via.placeholder.com/150',
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