// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  bool get isPhoneUser {
    final fUser = FirebaseAuth.instance.currentUser;
    // or do the provider check
    if (fUser?.phoneNumber != null) return true;
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
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

      // 2) Upsert Firestore doc
      await FirebaseFirestore.instance.collection('users').doc(fUser.uid).set({
        'displayName': displayName,
        'username': username,
        'description': description,
        // If user is phone-based, don't override phoneNumber from Firebase:
        if (!isPhoneUser) 'phoneNumber': phoneNumber ?? '',
      }, SetOptions(merge: true));

      // If your app also updates `FirebaseAuth.instance.currentUser` display name:
      if (fUser.displayName != displayName) {
        await fUser.updateDisplayName(displayName);
      }

      Get.back(result: true);
      Util.toast('Account updated');
    } catch (e) {
      Util.toast(e.toString());
    }

    isAdding.value = false;
  }
}
