import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MapController extends GetxController {
  RxBool isFetching = RxBool(false);
  RxBool isShowingLoader = RxBool(false);
  Rx<User?> user = Rx(null);

  @override
  void onReady() async {
    super.onReady();

    try {
      if (Session.user == null) throw 'Please log in';
      user.value = Session.user;
    } on Exception {
      await Session.logout();
    }
  }

  fetch({bool showLoader = true}) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    isShowingLoader.value = showLoader;

    try {} catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
