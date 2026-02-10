import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WithdrawOtpScreen extends StatefulWidget {

  final String sellerId;
  final double amount;
  final String otpToken;
  final String phoneNumber;
  final String token;

  const WithdrawOtpScreen({
    super.key,
    required this.sellerId,
    required this.amount,
    required this.otpToken,
    required this.phoneNumber,
    required this.token,
  });

  @override
  State<WithdrawOtpScreen> createState() => _WithdrawOtpScreenState();
}

class _WithdrawOtpScreenState extends State<WithdrawOtpScreen> {

  final otpController = TextEditingController();
  bool isLoading = false;
  

  Future<void> _performWithdrawal(String uid) async {
    
  final url = Uri.parse("${kBaseApiUrl}v1/withdraw/");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userId": widget.sellerId,
        "amount": (widget.amount).toStringAsFixed(2),
        "phoneNumber": widget.phoneNumber,
      }),
    );

    if (response.statusCode != 200) {
      Util.toast("withdraw_failed".tr);
    }
  } catch (e) {
    Util.toast("withdraw_error".tr);
  }
}


  Future<void> verifyOtp() async {
  final otpCode = otpController.text.trim();
  if (otpCode.isEmpty) {
    Util.toast("please_enter_otp".tr);
    return;
  }

  setState(() => isLoading = true);

  final url = Uri.parse("${kBaseApiUrl}v1/auth/phone-verify");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": widget.otpToken, // send the OTP token
        "code": otpCode,          // send the OTP entered by user
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Util.toast("withdraw_successful".tr);

      // Call your withdrawal API now that OTP is verified
      await _performWithdrawal(data["uid"]);
      
      Navigator.pop(context); // back to dashboard
    } else {
      Util.toast("verification_failed".tr);
    }
  } catch (e) {
    setState(() => isLoading = false);
    Util.toast("verification_failed".tr);
  }
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("verify".tr)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "verification_code".tr,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : verifyOtp,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text("confirm".tr),
            )
          ],
        ),
      ),
    );
  }
}
