import 'package:async/async.dart';
import 'package:baustaka/api/champ_api.dart';
import 'package:baustaka/model/champ.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';

class ChampsController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;

  RxList<Champ> champs = RxList.empty(
    growable: true,
  );

  final _champApi = Get.put(ChampApi());

  Rx<Paged<Champ>?> currentChampPage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _champsRequest;

  Rx<String?> q = Rx(null);

  final String? owner;

  ChampsController({
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
      await _champsRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentChampPage.value?.next ?? 1,
    };

    if (q.value?.isNotEmpty == true) {
      query['q'] = q.value;
    }

    if (owner?.isNotEmpty == true) {
      query['owner'] = owner;
    }

    _champsRequest = CancelableOperation.fromFuture(
      _champApi.retrieve(query),
    );

    _champsRequest?.then(
      (value) {
        var champPage = value.data?.champPage;

        currentChampPage.value = champPage ?? currentChampPage.value;

        champs.updateAll(
          elements: currentChampPage.value?.docs,
          refresh: refresh,
          test: (champAt, champ) => champAt.id == champ.id,
          upsert: true,
        );

        champs.refresh();

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
