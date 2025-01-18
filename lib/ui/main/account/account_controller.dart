import 'package:async/async.dart';
// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/state/state_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isFetching = false.obs;
  var isFailed = false.obs;
  var isUpdating = false.obs;

  // final _authApi = Get.put(AuthApi());

  final _userApi = Get.put(UserApi());

  final List<String> tags = [];

  CancelableOperation<dio.Response<BaseResponse>>? _userRequest;

  Rx<User?> user = Rx(null);

  RxMap<String, dynamic> map = RxMap({});

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  late TabController tabController;

  final scrollController = ScrollController();

  String? failedText;

  @override
  void onInit() {
    stateController.addUserListener((newUser) {
      user.value = newUser;

      if (user.value != null) isFailed.value = false;
    });

    tabController = TabController(
      length: tags.length,
      vsync: this,
    );

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    await fetch();
  }

  Future<void> fetch({
    bool refresh = false,
  }) async {
    if (isFetching.isTrue && !refresh) return;

    if (refresh && scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    }

    try {
      await _userRequest?.cancel();
    } catch (e) {
      Util.toast(e);
    }

    // _userRequest = CancelableOperation.fromFuture(
    //   _authApi.auth(),
    // );

    _userRequest?.then(
      (value) {
        var shouldUpdateTabs = user.value == null;

        user.value = value.data?.user;

        isFetching.value = false;

        stateController.user = user.value;

        if (shouldUpdateTabs) {
          _updateTabs(
            refresh: refresh,
          );
        }
      },
      onError: (error, stackTrace) {
        failedText = Util.toast(error);

        isFetching.value = false;

        isFailed.value = true;
      },
    );

    failedText = null;

    isFetching.value = true;

    isFailed.value = false;

    if (user.value != null) {
      _updateTabs(
        refresh: refresh,
      );
    }
  }

  _updateTabs({
    refresh = false,
  }) {
    if (user.value == null) return;

    try {} catch (e) {
      Util.toast(
        e,
        show: false,
      );
    }
  }

  Future<void> updateUser({
    required Map<String, dynamic> data,
  }) async {
    var userId = user.value?.id;

    if (userId == null || isUpdating.isTrue) return;

    _userApi.update(userId, data).then(
      (value) {
        user.value = value.data?.user;

        isUpdating.value = false;
      },
      onError: (error, stackTrace) {
        Util.toast(error);

        isUpdating.value = false;
      },
    );

    isUpdating.value = true;
  }
}
