import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class LinkEmailController extends GetxController {
  var isLinking = false.obs;
  var obscureText = true.obs;

  String? email;
  String? password;
  String? confirmPassword;

  linkEmail() async {
    if (isLinking.isTrue) return;
    isLinking.value = true;

    try {
      if (email == null || email!.trim().isEmpty) {
        throw 'Please enter an email address';
      }
      
      if (password == null || password!.trim().isEmpty || password!.length < 6) {
        throw 'Password must be at least 6 characters';
      }
      
      if (password != confirmPassword) {
        throw 'Passwords do not match';
      }
      
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not signed in';
      
      // Create email credential
      final credential = EmailAuthProvider.credential(
        email: email!.trim(),
        password: password!.trim(),
      );
      
      // Link with credential
      try {
        await user.linkWithCredential(credential);
      } catch (e) {
        // If the email is already in use, show a clear error
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          throw 'This email is already in use by another account. Please use a different email.';
        }
        rethrow;
      }
      
      // Update the email in our backend
      await Dio().post(
        '${kBaseApiUrl}v1/auth/link-email',
        data: {
          'uid': user.uid,
          'email': email!.trim(),
          'password': password!.trim(),
        },
      );
      
      // Show success message
      Util.toast('Email linked successfully! You can now sign in with email and password.');
      
      // Go back to previous screen
      Get.back();
      
    } catch (e) {
      Util.toast(e.toString());
    } finally {
      isLinking.value = false;
    }
  }
} 