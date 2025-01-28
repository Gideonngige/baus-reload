import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  var isRegistering = false.obs;
  var isAgreed = false.obs;
  var obscureText = true.obs;
  var confirmObscureText = true.obs;

  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  Future<void> _savePhoneInFirestore(String uid) async {
    // If phoneNumber is not null, store it
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      // Format if needed...
      String formattedPhone = _formatPhone(phoneNumber!);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'phoneNumber': formattedPhone,
      }, SetOptions(merge: true));
    }
  }

  String _formatPhone(String rawPhone) {
    if (rawPhone.startsWith('0')) {
      return '+254${rawPhone.substring(1)}';
    } else if (rawPhone.startsWith('254')) {
      return '+$rawPhone';
    } else {
      return rawPhone; // or handle differently
    }
  }

  Future<void> checkPhoneInServer(String phone) async {
    try {
      // GET /v1/user?phoneNumber=<phone>
      final response = await Dio().get(
        '${kBaseApiUrl}v1/user',
        queryParameters: {'phoneNumber': phone},
      );
      // If successful => user found => throw 'Phone number is already registered'
      throw 'Phone number already exists, kindly use phone sign in method';
    } on DioException catch (e) {
      // If server responds 404 => phone not in use => proceed
      if (e.response?.statusCode == 404) {
        // "User not found" => means phone not in use => good
        return;
      }
      // If some other code => rethrow or show error
      rethrow;
    }
  }

  Future<void> syncWithServer() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // not signed in at all

    final token = await currentUser.getIdToken(); // get the Firebase ID token

    String? modifiedPhoneNumber = phoneNumber;
    if (phoneNumber != null) {
      if (phoneNumber!.startsWith('0')) {
        modifiedPhoneNumber = '+254${phoneNumber!.substring(1)}';
      } else if (phoneNumber!.startsWith('254')) {
        modifiedPhoneNumber = '+$phoneNumber';
      }
    }

    try {
      // Replace kBaseApiUrl with your actual server domain, e.g. https://api.yourdomain.com
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/firebase',
        data: {
          'idToken': token,
          'phoneNumber': modifiedPhoneNumber,
        },
      );

      // This returns { "user": {...} }
      final data = response.data;
      // You could store it in Session if you want:
      // Session.serverUser = data['user'];
    } on DioException catch (e) {
      // You could still let them continue, or show a toast:
      Util.toast(e.response?.data?['error'] ?? e.message);
    }
  }

  register() async {
    if (isRegistering.isTrue) return;

    isRegistering.value = true;

    try {
      if (email == null || email!.isEmpty) throw 'Enter your email';

      if (phoneNumber == null || phoneNumber!.isEmpty)
        throw 'Enter your phone number';

      if (password == null || password!.isEmpty) throw 'Enter your password';

      if (password != confirmPassword) throw 'Passwords do not match';

      if (isAgreed.isFalse) throw 'Please accept the terms of service';

      String? modifiedPhoneNumber = phoneNumber;
      if (phoneNumber != null) {
        if (phoneNumber!.startsWith('0')) {
          modifiedPhoneNumber = '+254${phoneNumber!.substring(1)}';
        } else if (phoneNumber!.startsWith('254')) {
          modifiedPhoneNumber = '+$phoneNumber';
        }
      }

      await checkPhoneInServer(modifiedPhoneNumber!);

      await FirebaseAuth.instance.signOut();

      if (FirebaseAuth.instance.currentUser == null) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!.trim(),
          password: password!,
        );
        await userCredential.user?.sendEmailVerification();
        Util.toast(
            'A verification link has been sent to your email. Please verify before proceeding.');

        await _savePhoneInFirestore(userCredential.user!.uid);

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
