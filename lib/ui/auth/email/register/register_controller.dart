import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class RegisterController extends GetxController {
  var isRegistering = false.obs;
  var isAgreed = false.obs;
  var obscureText = true.obs;
  var confirmObscureText = true.obs;

  String? email;
  String? password;
  String? confirmPassword;

  Future<void> syncWithServer() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // not signed in at all

    final token = await currentUser.getIdToken(); // get the Firebase ID token

    try {
      // Replace kBaseApiUrl with your actual server domain, e.g. https://api.yourdomain.com
      final response = await Dio().post(
        '$kBaseApiUrl/v1/auth/firebase',
        data: {'idToken': token},
      );

      // This returns { "user": {...} }
      final data = response.data;
      // You could store it in Session if you want:
      // Session.serverUser = data['user'];

      // Or just log it:
      print('Server user: ${data['user']}');
    } on DioException catch (e) {
      // Handle server error
      print('Sync with server failed: ${e.response?.data ?? e.message}');
      // You could still let them continue, or show a toast:
      Util.toast(e.response?.data?['error'] ?? e.message);
    }
  }

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
            'A verification link has been sent to your email. Please verify before proceeding.');

        await syncWithServer();

        Session.login(splash: true);
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
