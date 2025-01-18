// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  var isAdding = false.obs;

  RxMap<String, dynamic> map = RxMap({
    'file': null,
  });

  // final _authApi = Get.put(AuthApi());

  final _userApi = Get.put(UserApi());

  final String? action;

  final imagePicker = ImagePicker();

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  ProfileController({
    required this.action,
  });

  @override
  void onInit() {
    map['displayName'] =
        stateController.user?.displayName ?? Session.user?.displayName;
    map['username'] = stateController.user?.username ??
        Session.user?.email?.substring(0, Session.user?.email?.indexOf('@'));
    map['description'] = stateController.user?.description ?? '';

    map.refresh();

    super.onInit();
  }

  add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    try {
      var username = (map['username'] as String?)?.trim();

      var displayName = (map['displayName'] as String?)?.trim();

      var description = (map['description'] as String?)?.trim();

      if (username?.isNotEmpty != true) throw 'Enter your username';

      if (displayName?.isNotEmpty != true) throw 'Enter your name';

      Map<String, dynamic> data = {
        'username': username,
        'displayName': displayName,
        'description': description,
      };

      if (map['file'] != null) data['file'] = map['file'];

      // if (action == 'register') {
      //   stateController.user = (await _authApi.register(data)).data!.user!;
      // } else {
      //   stateController.user =
      //       (await _userApi.update(stateController.user!.id!, data))
      //           .data!
      //           .user!;
      // }

      Get.back(
        result: true,
      );

      Util.toast('Account updated');
    } catch (e) {
      Util.toast(e);
    }

    isAdding.value = false;
  }
}
