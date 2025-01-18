import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionController extends GetxController {
  Rx<PackageInfo?> packageInfo = Rx(null);

  @override
  void onInit() async {
    super.onInit();

    packageInfo.value = await PackageInfo.fromPlatform();
  }
}
