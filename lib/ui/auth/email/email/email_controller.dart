import 'dart:convert';
import 'dart:math';

// import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:dio/dio.dart';

class EmailController extends GetxController {
  var isSigningIn = false.obs;
  var obscureText = true.obs;

  String? email;
  String? password;

  // final _userApi = Get.put(UserApi());

  var isSigningInWithGoogle = false.obs;
  var isSigningInWithApple = false.obs;

  Future<void> syncWithServer() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // not signed in at all

    final token = await currentUser.getIdToken(); // get the Firebase ID token

    try {
      // Replace kBaseApiUrl with your actual server domain, e.g. https://api.yourdomain.com
      final response = await Dio().post(
        '${kBaseApiUrl}v1/auth/firebase',
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

  signInWithGoogle() async {
    if (isSigningInWithGoogle.isTrue || isSigningInWithApple.isTrue) return;

    isSigningInWithGoogle.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        await syncWithServer();

        Session.login(splash: true);
      }
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      // Util.toast(e);
    }

    isSigningInWithGoogle.value = false;
  }

  signInWithApple() async {
    if (isSigningInWithApple.isTrue || isSigningInWithGoogle.isTrue) return;

    isSigningInWithApple.value = true;

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: kFirebaseSignInWithAppleClientId,
          redirectUri: Uri.parse(
            kFirebaseSignInWithAppleCallbackUrl,
          ),
        ),
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final displayName = [
        appleCredential.givenName ?? '',
        appleCredential.familyName ?? '',
      ].join(' ').trim();

      await Session.user?.updateDisplayName(displayName);

      await syncWithServer();

      Session.login(splash: true);
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      // Util.toast(e);
    }

    isSigningInWithApple.value = false;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signIn() async {
    if (isSigningIn.isTrue) return;

    isSigningIn.value = true;

    try {
      var userId = email?.trim();
      var userPassword = password?.trim();

      if (userId?.isNotEmpty != true) throw 'Enter your email';
      if (userPassword?.isNotEmpty != true) throw 'Enter your password';

      if (userId == null) throw 'Enter your email';

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userId, password: userPassword!);

      final user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        throw 'Email not verified. Verification link sent to your email.';
      }

      await syncWithServer();
      Session.login(splash: true);
    } on FirebaseAuthException catch (e) {
      Util.toast(e.message);
    } catch (e) {
      Util.toast(e);
    }

    isSigningIn.value = false;
  }
}
