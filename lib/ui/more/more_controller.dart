// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/user.dart';
import 'package:get/get.dart';

class MoreController extends GetxController {
  RxBool isIndicating = RxBool(false);
  RxBool isFetching = RxBool(false);

  Rx<User?> user = Rx(null);

  // final _authApi = Get.put(AuthApi());

  @override
  void onReady() async {
    super.onReady();

    await fetch();
  }

  fetch({indicator = false}) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    isIndicating.value = indicator;

    // try {
    //   user.value = (await _authApi.auth()).data!.user;
    // } catch (e) {
    //   Util.toast(e);
    // }

    isFetching.value = false;

    isIndicating.value = false;
  }
}
