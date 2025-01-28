// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class ProfileController extends GetxController {
//   var isAdding = false.obs;

//   RxMap<String, dynamic> map = RxMap({
//     'file': null,
//   });

//   // final _authApi = Get.put(AuthApi());

//   final _userApi = Get.put(UserApi());

//   final String? action;

//   final imagePicker = ImagePicker();

//   final stateController = Get.put(
//     StateController(),
//     permanent: true,
//     tag: Util.tag(),
//   );

//   ProfileController({
//     required this.action,
//   });

//   @override
//   void onInit() {
//     map['displayName'] =
//         stateController.user?.displayName ?? Session.user?.displayName;
//     map['username'] = stateController.user?.username ??
//         Session.user?.email?.substring(0, Session.user?.email?.indexOf('@'));
//     map['description'] = stateController.user?.description ?? '';

//     map.refresh();

//     super.onInit();
//   }

//   add() async {
//     if (isAdding.isTrue) return;

//     isAdding.value = true;

//     try {
//       var username = (map['username'] as String?)?.trim();

//       var displayName = (map['displayName'] as String?)?.trim();

//       var description = (map['description'] as String?)?.trim();

//       if (username?.isNotEmpty != true) throw 'Enter your username';

//       if (displayName?.isNotEmpty != true) throw 'Enter your name';

//       Map<String, dynamic> data = {
//         'username': username,
//         'displayName': displayName,
//         'description': description,
//       };

//       if (map['file'] != null) data['file'] = map['file'];

//       // if (action == 'register') {
//       //   stateController.user = (await _authApi.register(data)).data!.user!;
//       // } else {
//       //   stateController.user =
//       //       (await _userApi.update(stateController.user!.id!, data))
//       //           .data!
//       //           .user!;
//       // }

//       Get.back(
//         result: true,
//       );

//       Util.toast('Account updated');
//     } catch (e) {
//       Util.toast(e);
//     }

//     isAdding.value = false;
//   }
// }

class ProfileController extends GetxController {
  RxBool isAdding = false.obs;
  RxMap<String, dynamic> map = RxMap({
    'file': null,
  });

  final String? action;
  ProfileController({required this.action});

  late TextEditingController phoneController;

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
    _loadUserData();
  }

  @override
  void onClose() {
    // Dispose the phoneController when the controller is closed
    phoneController.dispose();
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

  void _loadUserData() async {
    // 1) Try to load from Firestore
    final fUser = FirebaseAuth.instance.currentUser;
    if (fUser == null) return;

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(fUser.uid)
        .get();

    // 2) If doc exists, populate map:
    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      map['displayName'] = fUser.displayName ?? data?['displayName'] ?? '';

      map['username'] =
          data?['username'] ?? (fUser.email?.split('@').first) ?? '';

      map['phoneNumber'] = data?['phoneNumber'] ?? fUser.phoneNumber;

      map['description'] = data?['description'] ?? '';
    } else {
      map['displayName'] = fUser.displayName ?? '';
      map['phoneNumber'] = fUser.phoneNumber;
      map['username'] = fUser.email?.split('@').first ?? '';
      map['description'] = '';
    }

    phoneController.text = map['phoneNumber'] ?? '';
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

      Get.back(result: true);
      Util.toast('Account updated');
    } catch (e) {
      Util.toast(e.toString());
    }

    isAdding.value = false;
  }
}
