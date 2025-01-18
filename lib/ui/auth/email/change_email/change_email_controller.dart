import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeEmailController extends GetxController {
  var isAdding = false.obs;

  RxMap<String, dynamic> map = RxMap({});

  final _userApi = Get.put(UserApi());

  final imagePicker = ImagePicker();

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  @override
  void onInit() {
    map['email'] = stateController.user?.email;

    super.onInit();
  }

  add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    if (check()) {
      try {
        if (map['email'] != null &&
            (map['email'] as String).trim().toLowerCase() !=
                Session.user?.email) {
          await firebase_auth.FirebaseAuth.instance.currentUser
              ?.verifyBeforeUpdateEmail(
                  (map['email'] as String).trim().toLowerCase());

          Util.toast('Check your email');
        }

        stateController.user =
            (await _userApi.update(stateController.user!.id!, {})).data!.user!;

        Get.back();

        Util.toast('Email updated');
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  bool check() {
    try {
      var email = map['email'];

      if (email == null || !email.toString().trim().isEmail) {
        throw 'Check your email';
      }

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
