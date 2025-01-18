import 'dart:async';

import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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

      Get.back(
        result: true,
      );
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      Util.toast(e);
    }

    isSigningIn.value = false;
  }
}
