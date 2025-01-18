import 'package:baustaka/api/station_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/station_page.dart';
import 'package:get/get.dart';

class StationsController extends GetxController {
  var isFetching = false.obs;
  var showSearch = false.obs;

  StationApi stationApi = Get.put(StationApi());

  RxList<Station> stations = RxList.empty();

  StationPage? _stationPage;

  String? q;

  @override
  void onInit() async {
    super.onInit();

    await fetch(true);
  }

  fetch(bool refresh) async {
    if (isFetching.isTrue) return;

    isFetching.value = true;

    if (refresh) {
      stations.clear();

      _stationPage = null;
    } else if (_stationPage != null &&
        (_stationPage!.page! >= _stationPage!.pages! ||
            _stationPage!.docs!.isEmpty)) {
      isFetching.value = false;
      return;
    }

    try {
      int page = _stationPage == null ? 1 : _stationPage!.page! + 1;

      Map<String, dynamic> query = {
        'page': page.toString(),
      };

      if (q != null && q!.trim().isNotEmpty) query.addAll({'q': q!.trim()});

      _stationPage = (await stationApi.retrieve(query)).data?.stationPage;

      stations.addAll(_stationPage!.docs!);
    } catch (e) {
      Util.toast(e);
    }
    isFetching.value = false;
  }
}
