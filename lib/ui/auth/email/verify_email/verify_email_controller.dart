import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  var isVerifying = false.obs;

  verify() async {
    if (isVerifying.isTrue) return;

    isVerifying.value = true;

    try {
      try {
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();

        Util.toast('Link sent. Check your email inbox');
      } catch (e) {
        Util.toast(e);
      }
    } catch (e) {
      Util.toast(e);
    }

    isVerifying.value = false;
  }
}
