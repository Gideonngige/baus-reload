import 'package:async/async.dart';
import 'package:baustaka/api/csr_api.dart';
import 'package:baustaka/model/csr.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';

class CsrsController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;

  RxList<Csr> csrs = RxList.empty(
    growable: true,
  );

  final _csrApi = Get.put(CsrApi());

  Rx<Paged<Csr>?> currentCsrPage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _csrsRequest;

  Rx<String?> q = Rx(null);

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
      await _csrsRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentCsrPage.value?.next ?? 1,
    };

    if (q.value?.isNotEmpty == true) {
      query['q'] = q.value;
    }

    _csrsRequest = CancelableOperation.fromFuture(
      _csrApi.retrieve(query),
    );

    _csrsRequest?.then(
      (value) {
        var csrPage = value.data?.csrPage;

        currentCsrPage.value = csrPage ?? currentCsrPage.value;

        csrs.updateAll(
          elements: currentCsrPage.value?.docs,
          refresh: refresh,
          test: (csrAt, csr) => csrAt.id == csr.id,
          upsert: true,
        );

        csrs.refresh();

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
