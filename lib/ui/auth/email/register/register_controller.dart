import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isRegistering = false.obs;
  var isAgreed = false.obs;
  var obscureText = true.obs;
  var confirmObscureText = true.obs;

  String? email;
  String? password;
  String? confirmPassword;

  register() async {
    if (isRegistering.isTrue) return;

    isRegistering.value = true;

    try {
      if (email == null || email!.isEmpty) throw 'Enter your email';

      if (password == null || password!.isEmpty) throw 'Enter your password';

      if (password != confirmPassword) throw 'Passwords do not match';

      if (isAgreed.isFalse) throw 'Please accept the terms of service';

      if (FirebaseAuth.instance.currentUser == null) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!.trim(),
          password: password!,
        );
        await userCredential.user?.sendEmailVerification();
        Util.toast(
            "A verification link has been sent to your email. Please verify before proceeding.");
      }

      Get.back(
        result: true,
      );
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      Util.toast(e);
    }

    isRegistering.value = false;
  }
}
