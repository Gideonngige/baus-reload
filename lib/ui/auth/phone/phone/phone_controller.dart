import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PhoneController extends GetxController {
  String? phoneNumber;

  signIn() async {
    try {
      if (phoneNumber == null || phoneNumber!.length < 4) {
        throw 'Check your phone number';
      }

      // 1) Format phone
      String formattedPhone = _formatPhone(phoneNumber!);

      // 2) Check if any user doc has this phoneNumber
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: formattedPhone)
          .limit(1)
          .get();

      if (snap.docs.isNotEmpty) {
        // That means some existing user doc is using phoneNumber
        throw 'Phone number already in use. Please sign in with email or Google/Apple.';
      }

      // 3) If not found, proceed to verification flow
      // For example:
      final result = await Get.toNamed(
        '${Routes.kVerifyPhoneNumber}$formattedPhone',
      );

      if (result == true) Get.back(result: true);

    } catch (e) {
      Util.toast(e.toString());
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