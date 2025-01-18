import 'dart:async';

// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/post_api.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/socket/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool isFetching = RxBool(false);

  Rx<firebase_auth.User?> firebaseUser = Rx(null);

  final _postApi = Get.put(PostApi());

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
      // 1) Get the Firebase user directly
      final fUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (fUser == null) throw 'Please log in';

      // 2) If needed, ensure email is verified (only for email/password sign-in).
      if (!fUser.emailVerified &&
          fUser.providerData.any((p) => p.providerId == 'password')) {
        throw 'Please verify your email before proceeding.';
        // Or prompt the user to verify: await fUser.sendEmailVerification();
      }

      // 3) Construct your local "user" model from the Firebase user
      //    NOTE: This 'User' model is from your code in `import 'package:baustaka/model/user.dart';`
      //    If it has different fields, adapt as needed.
      user.value = User(
        uid: fUser.uid, // or some field your server expects
        email: fUser.email,
        displayName: fUser.displayName ?? '',
        phoneNumber: fUser.phoneNumber,
        // etc...
        // phoneNumber: fUser.phoneNumber, // if needed
        // ...
      );

      // 4) If your server STILL needs to retrieve data with userId, do so:
      //    e.g., _postApi.retrieve() might require userId from the server DB.
      //    This only works if the server knows about this user ID.
      //    If not, you may get 401 or 404 because the user doesn't exist in the server DB.

      Map<String, dynamic> query = {
        'userId': user.value!.id, // The Firebase UID or the DB user ID?
        'status': 'accepted',
      };
      // postPage.value = (await _postApi.retrieve(query)).data!.postPage;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
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
