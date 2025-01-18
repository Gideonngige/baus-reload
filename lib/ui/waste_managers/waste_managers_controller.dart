import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:baustaka/api/waste_manager_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/waste_manager.dart';

class WasteManagersController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;

  RxList<WasteManager> wasteManagers = RxList.empty(
    growable: true,
  );

  final _wasteManagerApi = Get.put(WasteManagerApi());

  Rx<Paged<WasteManager>?> currentWasteManagerPage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _wasteManagerRequest;

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
      await _wasteManagerRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentWasteManagerPage.value?.next ?? 1,
    };

    if (q.value?.isNotEmpty == true) {
      query['q'] = q.value;
    }

    _wasteManagerRequest = CancelableOperation.fromFuture(
      _wasteManagerApi.retrieve(query),
    );

    _wasteManagerRequest?.then(
      (value) {
        var wasteManagerPage = value.data?.wasteManagerPage;

        currentWasteManagerPage.value =
            wasteManagerPage ?? currentWasteManagerPage.value;

        wasteManagers.updateAll(
          elements: currentWasteManagerPage.value?.docs,
          refresh: refresh,
          test: (wasteManagerAt, wasteManager) =>
              wasteManagerAt.id == wasteManager.id,
          upsert: true,
        );

        wasteManagers.refresh();

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
