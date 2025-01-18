import 'package:async/async.dart';
import 'package:baustaka/api/champ_api.dart';
import 'package:baustaka/model/champ.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';

class ChampController extends GetxController {
  var isFetching = false.obs;
  var isFailed = false.obs;
  var isDeleting = false.obs;

  final _champApi = Get.put(ChampApi());

  CancelableOperation<dio.Response<BaseResponse>>? _champRequest;

  Rx<Champ?> champ = Rx(null);

  RxMap<String, dynamic> map = RxMap({});

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  final String champId;

  ChampController({
    required this.champId,
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
      await _champRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _champRequest = CancelableOperation.fromFuture(
      _champApi.retrieve({
        'champId': champId,
      }),
    );

    _champRequest?.then(
      (value) {
        champ.value = value.data?.champ;

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
      champ.value?.lngLat?[1] ?? kInitialLatLng.latitude,
      champ.value?.lngLat?[0] ?? kInitialLatLng.longitude,
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
      await _champRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _champRequest = CancelableOperation.fromFuture(
      _champApi.remove(champId),
    );

    _champRequest?.then(
      (value) {
        champ.value = value.data?.champ;

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
