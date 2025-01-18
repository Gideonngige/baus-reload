import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/api/waste_manager_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/waste_manager.dart';
import 'package:baustaka/ui/_/map_widget.dart';

class WasteManagerController extends GetxController {
  var isFetching = false.obs;
  var isFailed = false.obs;
  var isDeleting = false.obs;

  final _wasteManagerApi = Get.put(WasteManagerApi());

  CancelableOperation<dio.Response<BaseResponse>>? _wasteManagerRequest;

  Rx<WasteManager?> wasteManager = Rx(null);

  RxMap<String, dynamic> map = RxMap({});

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  final String wasteManagerId;

  WasteManagerController({
    required this.wasteManagerId,
  });

  @override
  void onReady() async {
    super.onReady();

    await fetch();
  }

  Future<void> fetch({
    bool refresh = false,
  }) async {
    if (isFetching.isTrue && !refresh) return;

    try {
      await _wasteManagerRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _wasteManagerRequest = CancelableOperation.fromFuture(
      _wasteManagerApi.retrieve({
        'waste_managerId': wasteManagerId,
      }),
    );

    _wasteManagerRequest?.then(
      (value) {
        wasteManager.value = value.data?.wasteManager;

        isFetching.value = false;

        updateLocation();
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        isFetching.value = false;

        isFailed.value = true;
      },
    );

    isFetching.value = true;

    isFailed.value = false;
  }

  void updateLocation() {
    var newPosition = LatLng(
      wasteManager.value?.lngLat?[1] ?? kInitialLatLng.latitude,
      wasteManager.value?.lngLat?[0] ?? kInitialLatLng.longitude,
    );

    if (updateMap != null) {
      updateMap!(
        newPosition,
        showCircles: false,
        withZoom: kZoomForMarker,
      );
    }
  }

  delete() async {
    try {
      await _wasteManagerRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _wasteManagerRequest = CancelableOperation.fromFuture(
      _wasteManagerApi.remove(wasteManagerId),
    );

    _wasteManagerRequest?.then(
      (value) {
        wasteManager.value = value.data?.wasteManager;

        isDeleting.value = false;

        updateLocation();

        Get.back(result: true);

        Util.toast('Deleted');
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        isDeleting.value = false;

        isFailed.value = true;
      },
    );

    isDeleting.value = true;

    isFailed.value = false;
  }
}
