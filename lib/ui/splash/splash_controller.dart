import 'package:baustaka/config/routes.dart';
import 'package:baustaka/db/settings.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final isFetching = false.obs;

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    // if (Session.user != null) await Session.logout();

    try {
      await Future.delayed(const Duration(
        seconds: 1,
      ));
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;

    if (Session.user != null) {
      // Instead of always going to kMain, read the "initialRoute" from SettingsDb:
      final route = await SettingsDb.getInitialRoute(); // e.g. '/home_picker'
      // If for some reason route is null or empty, fallback
      if (route == null || route.isEmpty) {
        await Get.offAndToNamed(Routes.kMain);
      } else {
        await Get.offAndToNamed(route);
      }
    } else {
      await Get.offAndToNamed(Routes.kOnboarding);
    }
  }

  @override
  void onReady() async {
    super.onReady();

    await fetch();
  }
}
