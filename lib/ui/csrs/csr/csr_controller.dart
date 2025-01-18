import 'package:async/async.dart';
import 'package:baustaka/api/csr_api.dart';
import 'package:baustaka/model/csr.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';

class CsrController extends GetxController {
  var isFetching = false.obs;
  var isFailed = false.obs;
  var isDeleting = false.obs;

  final _csrApi = Get.put(CsrApi());

  CancelableOperation<dio.Response<BaseResponse>>? _csrRequest;

  Rx<Csr?> csr = Rx(null);

  RxMap<String, dynamic> map = RxMap({});

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  final String csrId;

  CsrController({
    required this.csrId,
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
      await _csrRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _csrRequest = CancelableOperation.fromFuture(
      _csrApi.retrieve({
        'csrId': csrId,
      }),
    );

    _csrRequest?.then(
      (value) {
        csr.value = value.data?.csr;

        isFetching.value = false;
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

  delete() async {
    try {
      await _csrRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    _csrRequest = CancelableOperation.fromFuture(
      _csrApi.remove(csrId),
    );

    _csrRequest?.then(
      (value) {
        csr.value = value.data?.csr;

        isDeleting.value = false;

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
