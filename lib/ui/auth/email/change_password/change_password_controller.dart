import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var isResettingPassword = false.obs;
  var obscureText = true.obs;
  var confirmObscureText = true.obs;

  String? password;
  String? confirmPassword;

  reset() async {
    if (isResettingPassword.isTrue) return;

    isResettingPassword.value = true;

    try {
      if (password == null || password!.isEmpty) throw 'Enter your password';

      if (password != confirmPassword) throw 'Passwords do not match';

      await FirebaseAuth.instance.currentUser?.updatePassword(password!);

      Get.back(result: true);

      Util.toast('Password updated');
    } catch (e) {
      Util.toast(e);
    }

    isResettingPassword.value = false;
  }
}
