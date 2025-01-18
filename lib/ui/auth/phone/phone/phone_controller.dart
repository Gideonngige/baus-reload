import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';

class PhoneController extends GetxController {
  String? phoneNumber;

  signIn() async {
    try {
      if (phoneNumber == null || phoneNumber!.length < 4) {
        throw 'Check your phone number';
      }

      var result = await Get.toNamed(
          '${Routes.kVerifyPhoneNumber}${phoneNumber!.substring(1)}');

      if (result == true) Get.back(result: true);
    } catch (e) {
      Util.toast(e);
    }
  }
}
