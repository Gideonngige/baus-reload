import 'package:baustaka/api/dumping_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/dumping.dart';
import 'package:get/get.dart';

class DumpingController extends GetxController {
  var isFetching = false.obs;
  var isDeleting = false.obs;

  Rx<Dumping?> dumping = Rx(null);

  final _dumpingApi = Get.put(DumpingApi());

  final String dumpingId;

  DumpingController({required this.dumpingId});

  @override
  void onInit() async {
    super.onInit();

    fetch();
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      dumping.value =
          (await _dumpingApi.retrieve({'dumpingId': dumpingId})).data!.dumping;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }

  

  delete() async {
    if (isDeleting.isTrue) return;

    isDeleting.value = true;

    try {
      dumping.value = (await _dumpingApi.remove(dumpingId)).data!.dumping;

      Get.back();
    } catch (e) {
      Util.toast(e);
    }

    isDeleting.value = false;
  }
}
