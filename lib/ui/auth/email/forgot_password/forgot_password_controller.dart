import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  var isResettingPassword = false.obs;

  String? email;

  reset() async {
    if (isResettingPassword.isTrue) return;

    isResettingPassword.value = true;

    try {
      if (email?.trim().isNotEmpty != true) throw 'Check your email';

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());

      Get.back(
        result: true,
      );

      Util.toast('Link sent. Check your email inbox');
    } catch (e) {
      Util.toast(e);
    }

    isResettingPassword.value = false;
  }
}
