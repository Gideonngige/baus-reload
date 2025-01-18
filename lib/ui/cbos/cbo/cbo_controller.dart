import 'package:async/async.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/api/cbo_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/cbo.dart';

class CboController extends GetxController {
  var isFetching = false.obs;
  var isFailed = false.obs;
  var isDeleting = false.obs;

  final _cboApi = Get.put(CboApi());

  CancelableOperation<dio.Response<BaseResponse>>? _cboRequest;

  Rx<Cbo?> cbo = Rx(null);

  RxMap<String, dynamic> map = RxMap({});

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  final String cboId;

  CboController({
    required this.cboId,
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
      await _cboRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _cboRequest = CancelableOperation.fromFuture(
      _cboApi.retrieve({
        'cboId': cboId,
      }),
    );

    _cboRequest?.then(
      (value) {
        cbo.value = value.data?.cbo;

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
      cbo.value?.lngLat?[1] ?? kInitialLatLng.latitude,
      cbo.value?.lngLat?[0] ?? kInitialLatLng.longitude,
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
      await _cboRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _cboRequest = CancelableOperation.fromFuture(
      _cboApi.remove(cboId),
    );

    _cboRequest?.then(
      (value) {
        cbo.value = value.data?.cbo;

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
