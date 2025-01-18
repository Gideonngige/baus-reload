import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
// import 'package:baustaka/api/auth_api.dart';
import 'package:baustaka/api/user_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/ui/state/state_controller.dart';

class SettingsController extends GetxController {
  RxBool isFetching = RxBool(false);
  RxBool isDeleting = RxBool(false);
  RxBool isFailed = RxBool(false);
  RxBool isUpdating = RxBool(false);

  Rx<User?> user = Rx(null);

  // final _authApi = Get.put(AuthApi());

  final _userApi = Get.put(UserApi());

  CancelableOperation<dio.Response<BaseResponse>>? _userRequest;

  String? failedText;

  final stateController = Get.put(
    StateController(),
    permanent: true,
    tag: Util.tag(),
  );

  @override
  void onInit() {
    stateController.addUserListener((newUser) {
      user.value = newUser;

      if (user.value != null) isFailed.value = false;
    });

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
        user.value = value.data?.user;

        isFetching.value = false;

        stateController.user = user.value;
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
  }

  remove() async {
    if (isDeleting.isTrue) return;

    isDeleting.value = true;

    try {
      user.value = (await _userApi.remove(user.value!.id!)).data!.user;
    } catch (e) {
      Util.toast(e);
    }

    isDeleting.value = false;
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
