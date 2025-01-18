import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:baustaka/api/cbo_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/cbo.dart';

class CbosController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;

  RxList<Cbo> cbos = RxList.empty(
    growable: true,
  );

  final _cboApi = Get.put(CboApi());

  Rx<Paged<Cbo>?> currentCboPage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _cbosRequest;

  Rx<String?> q = Rx(null);

  final String? owner;

  CbosController({
    this.owner,
  });

  @override
  void onReady() async {
    super.onReady();

    await fetch(
      refresh: true,
    );

    debounce(
      q,
      (_) async {
        await fetch(
          refresh: true,
        );
      },
      time: const Duration(
        milliseconds: 1000,
      ),
    );
  }

  Future<void> fetch({
    bool refresh = false,
  }) async {
    if (isFetching.isTrue && !refresh) return;

    try {
      await _cbosRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentCboPage.value?.next ?? 1,
    };

    if (q.value?.isNotEmpty == true) {
      query['q'] = q.value;
    }

    if (owner?.isNotEmpty == true) {
      query['owner'] = owner;
    }

    _cbosRequest = CancelableOperation.fromFuture(
      _cboApi.retrieve(query),
    );

    _cbosRequest?.then(
      (value) {
        var cboPage = value.data?.cboPage;

        currentCboPage.value = cboPage ?? currentCboPage.value;

        cbos.updateAll(
          elements: currentCboPage.value?.docs,
          refresh: refresh,
          test: (cboAt, cbo) => cboAt.id == cbo.id,
          upsert: true,
        );

        cbos.refresh();

        isFetching.value = false;

        isRefreshing.value = false;
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        isFetching.value = false;

        isRefreshing.value = false;

        isFailed.value = true;
      },
    );

    isFetching.value = true;

    isRefreshing.value = refresh;

    isFailed.value = false;
  }
}
