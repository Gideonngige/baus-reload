import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:get/get.dart';

class ChangePhoneController extends GetxController {
  var isAdding = false.obs;

  RxMap<String, dynamic> map = RxMap({});

  final _userApi = Get.put(UserApi());

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  @override
  void onInit() {
    map['phoneNumber'] = stateController.user?.phoneNumber;

    super.onInit();
  }

  add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    if (check()) {
      try {
        if (map['phoneNumber'] != null &&
            (map['phoneNumber'] as String).trim().toLowerCase() !=
                Session.user?.phoneNumber) {
          var updated = await Get.toNamed(
              '${Routes.kVerifyPhoneNumber}${(map['phoneNumber'] as String).substring(1)}?action=update');

          if (updated != true) throw 'Unable to update phone number';
        }

        stateController.user =
            (await _userApi.update(stateController.user!.id!, {})).data!.user!;

        Get.back();

        Util.toast('Phone number updated');
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  bool check() {
    try {
      var phoneNumber = map['phoneNumber'];

      if (phoneNumber == null || phoneNumber!.length < 4) {
        throw 'Check your phone number';
      }

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }
}
