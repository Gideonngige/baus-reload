import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';

class CompleteOrderScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const CompleteOrderScreen({super.key, required this.order});

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  final TextEditingController tokenController = TextEditingController();

  bool isLoading = false;

  Future<void> verifyDelivery() async {
    final token = tokenController.text.trim();

    if (token.isEmpty) {
      Util.toast("enter_verification_code".tr);
      return;
    }

    setState(() => isLoading = true);

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final idToken = await firebaseUser!.getIdToken(true);

      final prefs = await SharedPreferences.getInstance();
      final storedUser = prefs.getString('user');

      if (storedUser == null) {
        Util.toast("User not found");
        return;
      }

      final user = jsonDecode(storedUser);

      final url = Uri.parse("${kBaseApiUrl}v1/orders/verify-delivery-buyer/");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "orderId": widget.order['_id'],
          "buyerId": user['_id'],
          "verificationToken": token,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Util.toast(data['message'] ?? "order_completed".tr);

        Navigator.pop(context, true); // go back
      } else {
        Util.toast(data['message'] ?? "verification_failed".tr);
      }
    } catch (e) {
      Util.toast("something_went_wrong".tr);
      print(e);
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget orderCard() {
    final listing = widget.order['listing'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              '$kBaseImageUrl${listing['image']}',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing['title'] ?? "Item",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                Text(
                  "Ksh ${widget.order['totalPrice']}",
                  style: const TextStyle(
                      color: Palette.primary,
                      fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 6),

                Text(
                  "Qty: ${widget.order['quantity'] ?? 1}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("complete_order".tr,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), ),
        backgroundColor: Palette.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          orderCard(),

          const SizedBox(height: 10),

          /// Verification Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: tokenController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "enter_verification_code".tr,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          const Spacer(),

          /// Complete Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: isLoading ? null : verifyDelivery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "mark_as_complete".tr,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
