// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/db/user_db.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/main/main_controller.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  RxBool isAdding = false.obs;
  RxMap<String, dynamic> map = RxMap({
    'file': null,
  });

  final String? action;
  ProfileController({required this.action});

  late TextEditingController phoneController;
  late TextEditingController displayNameController;
  late TextEditingController usernameController;
  late TextEditingController descriptionController;

  bool get isPhoneUser {
    final fUser = FirebaseAuth.instance.currentUser;
    // or do the provider check
    if (fUser?.phoneNumber != null) return true;
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    displayNameController = TextEditingController();
    usernameController = TextEditingController();
    descriptionController = TextEditingController();
    _loadUserData();
  }

  @override
  void onClose() {
    // Dispose all controllers when the controller is closed
    phoneController.dispose();
    displayNameController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> _syncProfileWithServer({
    required String displayName,
    required String username,
    String? phoneNumber,
    // String? description,
  }) async {
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser == null) return; // not logged in

    // 1) Get the Firebase ID token for auth
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);

    try {
      // 2) Make a PUT request to your server (e.g. `/v1/user`)
      final response = await Dio().put(
        '${kBaseApiUrl}v1/user',
        options: Options(
          headers: {
            // Your server probably reads the token from 'Authorization: Bearer ...'
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          // the fields you want to update
          'displayName': displayName,
          'username': username,
          // 'description': description,
          // if your user is phone-based, you skip phoneNumber, so phoneNumber can remain
          'phoneNumber': phoneNumber,
        },
      );

      print('Server user updated: ${response.data}');
      // Possibly parse `response.data['user']` if it returns it
    } on DioException catch (e) {
      // If the server fails or you get a validation error, show it
      Util.toast(e.response?.data?['error'] ?? e.message);
    } catch (e) {
      print('syncProfileWithServer error: $e');
      Util.toast(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser == null) return; // not logged in

    // 1) Get the Firebase ID token for auth
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
  try {
    // Optionally show a loading indicator here
    final response = await Dio().delete(
      '${kBaseApiUrl}v1/user/me', // new endpoint
      options: Options(
        headers: {
          // Include any required auth headers, for example:
          'Authorization': 'Bearer $token',
        },
      ),
    );
    // After successful deletion, log the user out
    await Session.logout();
    Util.toast('Account deleted successfully');
    // Optionally, navigate to the login screen or exit the app
  } catch (e) {
    Util.toast('Failed to delete account: ${e.toString()}');
  }
}


  void _loadUserData() async {
    try {
      // 1) First try to load from local cache for immediate display
      final cachedUser = await UserDb.getCachedUser();
      if (cachedUser != null) {
        _populateFields(
          displayName: cachedUser.displayName ?? '',
          username: cachedUser.username ?? '',
          phoneNumber: cachedUser.phoneNumber ?? '',
          description: cachedUser.description ?? '',
        );
        print('Profile fields populated from cached data');
      }

      // 2) Get current Firebase user
      final fUser = FirebaseAuth.instance.currentUser;
      if (fUser == null) return;

      // 3) Try to load from Firestore for latest data
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(fUser.uid)
          .get();

      String displayName = '';
      String username = '';
      String phoneNumber = '';
      String description = '';

      // 4) Build comprehensive data from all sources
      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        displayName = fUser.displayName ?? data?['displayName'] ?? '';
        username = data?['username'] ?? (fUser.email?.split('@').first) ?? '';
        phoneNumber = data?['phoneNumber'] ?? fUser.phoneNumber ?? '';
        description = data?['description'] ?? '';
      } else {
        displayName = fUser.displayName ?? '';
        phoneNumber = fUser.phoneNumber ?? '';
        username = fUser.email?.split('@').first ?? '';
        description = '';
      }

      // 5) Populate all fields with the comprehensive data
      _populateFields(
        displayName: displayName,
        username: username,
        phoneNumber: phoneNumber,
        description: description,
      );

      print('Profile fields populated from Firebase/Firestore data');
    } catch (e) {
      print('Error loading user data: $e');
      // If there's an error, try to use whatever cached data we have
      final cachedUser = await UserDb.getCachedUser();
      if (cachedUser != null) {
        _populateFields(
          displayName: cachedUser.displayName ?? '',
          username: cachedUser.username ?? '',
          phoneNumber: cachedUser.phoneNumber ?? '',
          description: cachedUser.description ?? '',
        );
      }
    }
  }

  void _populateFields({
    required String displayName,
    required String username,
    required String phoneNumber,
    required String description,
  }) {
    // Update the reactive map
    map['displayName'] = displayName;
    map['username'] = username;
    map['phoneNumber'] = phoneNumber;
    map['description'] = description;

    // Update all text controllers
    displayNameController.text = displayName;
    usernameController.text = username;
    phoneController.text = phoneNumber;
    descriptionController.text = description;

    // Refresh the UI
    map.refresh();
  }



  Future<void> add() async {
    if (isAdding.isTrue) return;
    isAdding.value = true;

    try {
      final fUser = FirebaseAuth.instance.currentUser;
      if (fUser == null) throw 'Please log in first.';

      final username = (map['username'] as String?)?.trim();
      final displayName = (map['displayName'] as String?)?.trim();
      final phoneNumber = (map['phoneNumber'] as String?)?.trim();
      final description = (map['description'] as String?)?.trim();

      if (username == null || username.isEmpty) throw 'Enter your username';
      if (displayName == null || displayName.isEmpty) throw 'Enter your name';

      // If user is NOT phone-based, let them edit phone.
      // We must ensure phoneNumber is unique if it's not null or empty:
      if (!isPhoneUser && phoneNumber?.isNotEmpty == true) {
        // 1) Check if phoneNumber is taken:
        final querySnap = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

        // If there's a doc that belongs to a different UID, fail:
        final anyOther = querySnap.docs.any((doc) => doc.id != fUser.uid);
        if (anyOther) {
          throw 'Phone number is already used by another account';
        }
      }

      String? modifiedPhoneNumber = phoneNumber;
      if (phoneNumber != null) {
        if (phoneNumber.startsWith('0')) {
          modifiedPhoneNumber = '+254${phoneNumber.substring(1)}';
        } else if (phoneNumber.startsWith('254')) {
          if (!phoneNumber.startsWith('+254') && !phoneNumber.startsWith('0')) {
            modifiedPhoneNumber = '+254$phoneNumber';
          }
          modifiedPhoneNumber = '+$phoneNumber';
        } else if (phoneNumber.startsWith('+254')) {
          modifiedPhoneNumber = phoneNumber;
        } else {
          throw 'Invalid phone number format';
        }
      }

      // 2) Upsert Firestore doc
      await FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
        'displayName': displayName,
        'username': username,
        'description': description,
        // If user is phone-based, don't override phoneNumber from Firebase:
        if (!isPhoneUser) 'phoneNumber': modifiedPhoneNumber ?? '',
      }, SetOptions(merge: true));

      // If your app also updates `FirebaseAuth.instance.currentUser` display name:
      if (fUser.displayName != displayName) {
        await fUser.updateDisplayName(displayName);
      }

      await _syncProfileWithServer(
        displayName: displayName,
        username: username,
        phoneNumber: modifiedPhoneNumber,
        // description: description ?? 'Update from user',
      );

      // Check if we're in the bottom navigation context
      if (action == 'bottom_nav') {
        // Navigate to home tab in the nested navigator
        Navigator.pushNamedAndRemoveUntil(
          Get.nestedKey(1)!.currentContext!,
          '/home',
          (route) => false,
        );
        
        // Update the main controller's currentPage to reflect home state (value 2)
        try {
          final mainController = Get.find<MainController>();
          mainController.currentPage.value = 2;
        } catch (e) {
          print('Could not find MainController: $e');
        }
      } else {
        // Regular navigation (sidebar case)
        Get.back(result: true);
      }
      
      Util.toast('Account updated');
    } catch (e) {
      Util.toast(e.toString());
    }

    isAdding.value = false;
  }
}
