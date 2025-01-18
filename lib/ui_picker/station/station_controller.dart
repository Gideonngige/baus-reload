import 'package:baustaka/api/station_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/station.dart';
import 'package:get/get.dart';

class StationController extends GetxController {
  var isFetching = false.obs;
  var isUpdating = false.obs;

  Rx<Station?> station = Rx(null);

  final _stationApi = Get.put(StationApi());

  final String stationId;

  StationController({required this.stationId});

  @override
  void onInit() async {
    super.onInit();

    await fetch();
  }

  fetch() async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    try {
      station.value =
          (await _stationApi.retrieve({'stationId': stationId})).data?.station;
    } catch (e) {
      Util.toast(e);
    }

    isFetching.value = false;
  }
}
