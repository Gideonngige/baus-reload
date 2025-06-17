import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/user_db.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Session {
  static Map<String, String>? cachedHeaders() => Get.put(
        StateController(),
        permanent: true,
        tag: Util.tag(),
      ).headers;

  static Future<Map<String, String>> headers() async {
    Map<String, String> headers = {};

    try {
      String? token = await FirebaseAuth.instance.currentUser!.getIdToken();

      headers['authorization'] = 'Bearer $token';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        headers['app-token'] = token;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    try {
      var packageInfo = await PackageInfo.fromPlatform();

      headers['app-id'] = kAppId;
      headers['app-name'] = packageInfo.appName;
      headers['app-package-name'] = packageInfo.packageName;
      headers['app-version'] = packageInfo.version;
      headers['app-build-number'] = packageInfo.buildNumber;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return headers;
  }

  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Clear cached user data
      await UserDb.clearUser();

      await Get.deleteAll(force: true);

      await Get.offAllNamed(Routes.kSplash);

      if (kDebugMode) {
        print('Logged out and cleared cached user data');
      }
    } on Exception {
      Util.toast('Oops! Retry');
    }
  }

  static Future<void> verify() async {
    try {
      // await Get.toNamed(Routes.kVerifyEmail);

      if (kDebugMode) {
        print('Email verification');
      }
    } on Exception {
      Util.toast('Oops! Retry');
    }
  }

  static Future<void> register() async {
    try {
      await Get.toNamed('${Routes.kProfile}?action=register');

      if (kDebugMode) {
        print('Complete registration');
      }
    } on Exception {
      Util.toast('Oops! Retry');
    }
  }

  static Future<void> login({bool splash = true}) async {
    if (splash) {
      await Get.deleteAll(force: true);

      await Get.offAllNamed(Routes.kSplash);
    }

    if (kDebugMode) {
      print('Logged in');
    }
  }

  static User? get user => FirebaseAuth.instance.currentUser;
}
