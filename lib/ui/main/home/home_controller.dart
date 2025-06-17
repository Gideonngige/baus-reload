import 'dart:async';

// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/user_db.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/socket/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isFetching = RxBool(false);

  Rx<firebase_auth.User?> firebaseUser = Rx(null);

  // final _postApi = Get.put(PostApi());

  Rx<User?> user = Rx(null);

  Rx<PostPage?> postPage = Rx(null);

  // final _authApi = Get.put(AuthApi());

  final userSocket = Get.put(
    UserSocket(),
    permanent: true,
  );

  RxList<Picker> pickers = RxList.empty(
    growable: true,
  );

  // fetch() async {
  //   if (isFetching.isTrue) return;

  //   isFetching.value = true;

  //   try {
  //     if (Session.user == null) throw 'Please log in';
  //     firebaseUser.value = Session.user;

  //     user.value = (await _authApi.auth()).data!.user;

  //     Map<String, dynamic> query = {
  //       'userId': user.value!.id,
  //       'status': 'accepted',
  //     };

  //     postPage.value = (await _postApi.retrieve(query)).data!.postPage;
  //   } catch (e) {
  //     Util.toast(e);
  //   }

  //   isFetching.value = false;
  // }

  fetch() async {
    if (isFetching.isTrue) return;
    isFetching.value = true;

    try {
      // 1) First try to load cached user data
      final cachedUser = await UserDb.getCachedUser();
      if (cachedUser != null) {
        user.value = cachedUser;
        print('Using cached user data for immediate display');
      }

      // 2) Get the Firebase user directly from Auth
      final fUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (fUser == null) throw 'Please log in';

      // Check if this user needs to add an email
      checkIfNeedsEmailLinking(fUser);

      // If they're using email/password, check if verified
      final isEmailPasswordUser =
          fUser.providerData.any((p) => p.providerId == 'password');
      if (isEmailPasswordUser && !fUser.emailVerified) {
        // Re-send the verification link (optional, depends on how often you want to re-send)
        await fUser.sendEmailVerification();

        // Show a toast
        Util.toast(
            'Your email is not verified. We have re-sent a verification link to ${fUser.email}. Please verify.');

        // Option A: Log them out so they must sign in again once verified
        await firebase_auth.FirebaseAuth.instance.signOut();
        await Session.logout();
        // Clear cached user data on logout
        await UserDb.clearUser();
        // Then navigate to login screen
        Get.offAllNamed(Routes.kLoginWithEmail);

        // Or Option B: Keep them logged in, but show a "please verify" screen
        // Get.offAllNamed(Routes.kVerifyEmail); // Some custom route

        return; // Stop further logic
      }

      // 3) Load user doc from Firestore (this will update cached data)
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(fUser.uid)
          .get();

      // 4) Merge Firestore data with fallback to the FirebaseAuth user object
      String? displayName;
      String? phoneNumber;
      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        displayName = fUser.displayName ?? data?['displayName'] as String?;
        phoneNumber = fUser.phoneNumber ?? data?['phoneNumber'] as String?;
      } else {
        // If no doc, fallback to the Firebase user fields
        displayName = fUser.displayName ?? '';
        phoneNumber = fUser.phoneNumber ?? '';
      }

      // 5) Construct your local "User" model
      final freshUser = User(
        uid: fUser.uid,
        email: fUser.email,
        displayName: displayName ?? '',
        phoneNumber: phoneNumber ?? '',
        // ... any other fields if needed
      );

      // 6) Update the observable and cache the fresh data
      user.value = freshUser;
      await UserDb.saveUser(freshUser);

      print('User data fetched and cached: ${freshUser.displayName}');

      // (Optional) If you still want to fetch "postPage" from the server, do so here:
      // final query = {
      //   'userId': user.value!.id,
      //   'status': 'accepted',
      // };
      // postPage.value = (await _postApi.retrieve(query)).data!.postPage;
    } catch (e) {
      print('Error fetching user data: $e');
      // If we have cached data and there's a network error, use cached data
      final cachedUser = await UserDb.getCachedUser();
      if (cachedUser != null && user.value == null) {
        user.value = cachedUser;
        print('Using cached user data due to fetch error');
      } else {
        Util.toast(e);
      }
    }

    isFetching.value = false;
  }

  void checkIfNeedsEmailLinking(firebase_auth.User user) {
    // Check if the user is phone-only (has phoneNumber provider but no password provider)
    final hasPhoneProvider = user.providerData.any((p) => p.providerId == 'phone');
    final hasEmailProvider = user.providerData.any((p) => p.providerId == 'password');
    
    if (hasPhoneProvider && !hasEmailProvider && user.email == null) {
      // This user only has phone auth, show prompt to add email
      Get.dialog(
        AlertDialog(
          title: const Text('Add Email to Your Account'),
          content: const Text(
            'For improved security and easier sign-in, we recommend adding an email to your account. Would you like to do that now?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Not Now'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed(Routes.kLinkEmail);
              },
              child: const Text('Add Email'),
            ),
          ],
        ),
        barrierDismissible: true,
      );
    }
  }

  @override
  void onInit() async {
    ever(userSocket.picker, (value) {
      var picker = userSocket.picker.value;

      if (picker != null) {
        pickers.removeWhere((element) => element.id == picker.id);

        pickers.insert(0, picker);

        if (kDebugMode) {
          print('Picker ${pickers.length}');
        }
      }
    });

    Timer.periodic(
      const Duration(
        seconds: 15,
      ),
      (_) => updatePickers(),
    );

    await fetch();

    super.onInit();
  }

  updatePickers() async {
    pickers.removeWhere(
      (element) =>
          element.updatedAt?.isBefore(
            DateTime.now().subtract(
              const Duration(
                seconds: 10,
              ),
            ),
          ) ==
          true,
    );

    if (kDebugMode) {
      print('Pickers ${pickers.length}');
    }
  }
}
