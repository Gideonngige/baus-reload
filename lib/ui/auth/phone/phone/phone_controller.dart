import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:baustaka/config/env.dart';

class PhoneController extends GetxController {
  String? phoneNumber;
  var isChecking = false.obs;

  signIn() async {
    if (isChecking.isTrue) return;
    isChecking.value = true;

    try {
      if (phoneNumber == null || phoneNumber!.length < 4) {
        throw 'Check your phone number';
      }

      // 1) Format phone
      String formattedPhone = _formatPhone(phoneNumber!);

      // 2) Check with our backend if this phone exists in Firebase Auth
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/phone-check',
        data: {'phoneNumber': formattedPhone},
      );

      final data = response.data;
      
      if (data['exists'] == true) {
        // Phone exists in Firebase Auth, proceed to OTP verification
        final token = data['token'];
        final hasEmail = data['hasEmail'] ?? false;
        
        // Navigate to OTP verification
        final result = await Get.toNamed(
          '${Routes.kVerifyPhoneNumber}$formattedPhone',
          arguments: {
            'token': token,
            'hasEmail': hasEmail,
          },
        );

        if (result == true) Get.back(result: true);
      } else {
        // Phone not found in Firebase Auth
        throw data['message'] ?? 'This phone number is not registered. Please use Google, Apple, or Email login.';
      }

    } catch (e) {
      Util.toast(e.toString());
    } finally {
      isChecking.value = false;
    }
  }

  String _formatPhone(String rawPhone) {
    if (rawPhone.startsWith('0')) {
      return '+254${rawPhone.substring(1)}';
    } else if (rawPhone.startsWith('254')) {
      return '+$rawPhone';
    } else {
      return rawPhone;
    }
  }
}