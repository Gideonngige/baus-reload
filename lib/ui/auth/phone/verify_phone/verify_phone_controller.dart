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

  String smsCode = '';

  final String phoneNumber;
  final String? action;

  String? _verificationId;

  ConfirmationResult? _confirmationResult;

  PhoneAuthCredential? _phoneAuthCredential;

  RxInt seconds = RxInt(0);

  Timer? timer;

  final _waitPeriod = 60;

  Future<void> checkPhoneInServer(String phone) async {
    try {
      // GET /v1/user?phoneNumber=<phone>
      final response = await Dio().get(
        '${kBaseApiUrl}v1/user',
        queryParameters: {'phoneNumber': phone},
      );
      // If successful => user found => throw 'Phone number is already registered'
      // throw 'Phone number already exists, kindly use email sign in method';
    } on DioException catch (e) {
      // If server responds 404 => phone not in use => proceed
      if (e.response?.statusCode == 404) {
        // "User not found" => means phone not in use => good
        await _syncPhoneWithServer(phone);
        return;
      }
      // If some other code => rethrow or show error
      rethrow;
    }
  }

  Future<void> _syncPhoneWithServer(String phone) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // not signed in

    try {
      // 1) Get ID token
      final token = await currentUser.getIdToken();

      // 2) POST to /v1/auth/firebase with `idToken` + `phoneNumber`
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/firebase', // or ensure a '/' if needed
        data: {
          'idToken': token,
          'phoneNumber': phone, // pass the verified phone
        },
      );

      final data = response.data;
      print('Phone updated server user: ${data['user']}');
    } on DioException catch (e) {
      Util.toast(e.response?.data?['error'] ?? e.message);
    } catch (e) {
      print('syncPhoneWithServer error: $e');
      Util.toast(e.toString());
    }
  }

  VerifyPhoneController({
    required this.phoneNumber,
    this.action,
  });

  @override
  void onReady() async {
    super.onReady();

    await verify();
  }

  verify() async {
    if (isVerifying.isTrue || seconds.value > 0) return;

    if (Session.user != null && action != 'update') {
      if (Get.currentRoute.contains(Routes.kVerifyPhoneNumber)) {
        Get.back(
          result: true,
        );
      }

      return;
    }

    isVerifying.value = true;

    try {
      if (GetPlatform.isWeb) {
        _confirmationResult =
            await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);

        isVerifying.value = false;
      } else {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            isVerifying.value = false;

            _phoneAuthCredential = phoneAuthCredential;

            await _signIn();

            seconds.value = _waitPeriod;
          },
          verificationFailed: (FirebaseAuthException e) {
            isVerifying.value = false;

            seconds.value = 0;

            Util.toast(e.message);
          },
          codeSent: (String verificationId, int? token) {
            if (kDebugMode) {
              print('codeSent $token $verificationId');
            }

            isVerifying.value = false;

            _verificationId = verificationId;

            seconds.value = _waitPeriod;

            timer?.cancel();

            timer = Timer.periodic(
              const Duration(
                seconds: 1,
              ),
              (timer) =>
                  seconds.value = seconds.value < 1 ? 0 : seconds.value - 1,
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            if (kDebugMode) {
              print('codeAutoRetrievalTimeout $verificationId');
            }

            isVerifying.value = false;

            _verificationId = verificationId;

            seconds.value = _waitPeriod;
          },
          timeout: const Duration(seconds: 90),
        );
      }
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);

      isVerifying.value = false;

      seconds.value = 0;
    } catch (e) {
      Util.toast(e);

      isVerifying.value = false;

      seconds.value = 0;
    }
  }

  signIn() async {
    try {
      if (GetPlatform.isWeb) {
        if (_confirmationResult == null) {
          await verify();

          throw 'Sending...';
        }
      } else if (_verificationId == null) {
        await verify();

        throw 'Sending...';
      }

      if (smsCode.trim().isEmpty) throw 'Enter code';

      if (!GetPlatform.isWeb) {
        _phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: smsCode.trim(),
        );
      }

      _signIn();
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      Util.toast(e);
    }
  }

  _signIn() async {
    if (isSigningIn.isTrue) return;

    isSigningIn.value = true;

    try {
      if (GetPlatform.isWeb) {
        await _confirmationResult!.confirm(smsCode.trim());
      } else {
        if (action == 'update') {
          await FirebaseAuth.instance.currentUser
              ?.updatePhoneNumber(_phoneAuthCredential!);
        } else {
          await FirebaseAuth.instance
              .signInWithCredential(_phoneAuthCredential!);
        }
      }

      await checkPhoneInServer(phoneNumber);

      Get.back(
        result: true,
      );
      Session.login(splash: true);
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      Util.toast(e);
    }

    isSigningIn.value = false;
  }
}
