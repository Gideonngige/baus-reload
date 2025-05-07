import 'dart:async';

import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:baustaka/config/env.dart';
import 'package:dio/dio.dart';

class VerifyPhoneController extends GetxController {
  var isVerifying = false.obs;
  var isSigningIn = false.obs;
  var showEmailLinkForm = false.obs;
  var emailLinkingInProgress = false.obs;

  String smsCode = '';
  String? email;
  String? password;

  final String phoneNumber;
  String token;
  final bool hasEmail;

  RxInt seconds = RxInt(0);
  Timer? timer;
  final _waitPeriod = 60;

  VerifyPhoneController({
    required this.phoneNumber,
    required this.token,
    this.hasEmail = false,
  });

  @override
  void onReady() async {
    super.onReady();
    startTimer();
  }

  void startTimer() {
    seconds.value = _waitPeriod;
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => seconds.value = seconds.value < 1 ? 0 : seconds.value - 1,
    );
  }

  Future<void> resendOtp() async {
    if (seconds.value > 0) return;
    
    try {
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/phone-check',
        data: {'phoneNumber': phoneNumber},
      );
      
      final data = response.data;
      if (data['exists'] == true) {
        // Got a new token
        token = data['token'];
        startTimer();
        Util.toast('New verification code sent!');
      }
    } catch (e) {
      Util.toast('Failed to resend code: ${e.toString()}');
    }
  }

  signIn() async {
    if (isSigningIn.isTrue) return;
    isSigningIn.value = true;

    try {
      if (smsCode.trim().isEmpty) throw 'Enter verification code';

      // Verify OTP with our backend
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/phone-verify',
        data: {
          'token': token,
          'code': smsCode.trim(),
        },
      );

      final data = response.data;
      
      // Sign in with the custom token
      await FirebaseAuth.instance.signInWithCustomToken(data['token']);
      
      // Sync with server
      await syncWithServer();
      
      // If user doesn't have an email linked, show the form to add email
      if (!hasEmail) {
        showEmailLinkForm.value = true;
        isSigningIn.value = false;
        return;
      }
      
      // Otherwise, proceed to login
      Get.back(result: true);
      Session.login(splash: true);
      
    } catch (e) {
      Util.toast(e.toString());
      isSigningIn.value = false;
    }
  }

  linkEmail() async {
    if (emailLinkingInProgress.isTrue) return;
    emailLinkingInProgress.value = true;
    
    try {
      if (email == null || email!.trim().isEmpty) {
        throw 'Please enter an email address';
      }
      
      if (password == null || password!.trim().isEmpty || password!.length < 6) {
        throw 'Password must be at least 6 characters';
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
      
      // Save email temporarily to show in message
      final linkedEmail = email!.trim();
      
      // Log out the user
      await FirebaseAuth.instance.signOut();
      
      // Show success message
      Util.toast('Email linked successfully! Please sign in with your email and password.');
      
      // Navigate to email login page
      Get.offAllNamed(Routes.kLoginWithEmail, arguments: {'email': linkedEmail});
      
    } catch (e) {
      Util.toast(e.toString());
    } finally {
      emailLinkingInProgress.value = false;
    }
  }

  skipEmailLinking() {
    // Just continue without linking email
    Get.back(result: true);
    Session.login(splash: true);
  }

  Future<void> syncWithServer() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final token = await currentUser.getIdToken();
      
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/firebase',
        data: {
          'idToken': token,
          'phoneNumber': phoneNumber,
        },
      );
      
      final data = response.data;
      print('Phone auth server user: ${data['user']}');
    } catch (e) {
      print('Error syncing with server: $e');
    }
  }
}