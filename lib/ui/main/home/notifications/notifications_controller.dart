import 'package:async/async.dart';
import 'package:baustaka/api/app_notification_api.dart';
import 'package:baustaka/helper/base_response.dart';
import 'package:baustaka/helper/extension.dart';
import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/app_notification.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var isFetching = false.obs;
  var isRefreshing = false.obs;
  var isFailed = false.obs;
  var isSearching = false.obs;
  Rx<String?> q = Rx(null);

  RxList<AppNotification> notifications = RxList.empty(
    growable: true,
  );

  final _notificationApi = Get.put(AppNotificationApi());

  Rx<Paged<AppNotification>?> currentAppNotificationPage = Rx(null);

  CancelableOperation<dio.Response<BaseResponse>>? _notificationsRequest;

  String? failedText;

  @override
  void onReady() async {
    super.onReady();

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

    await fetch(
      refresh: true,
    );
  }


  Future<void> fetch({bool refresh = false}) async {
    if (isFetching.isTrue && !refresh) return;

    try {
      await _notificationsRequest?.cancel();
    } catch (e) {
      Util.toast(e.toString());
    }

    Map<String, dynamic> query = {
      'page': refresh ? 1 : currentAppNotificationPage.value?.next ?? 1,
    };

    // if (q.value?.isNotEmpty == true) query['q'] = q.value;

    try {
      _notificationsRequest = CancelableOperation.fromFuture(
        _notificationApi.retrieve(query),
      );

      _notificationsRequest?.then(
        (value) {
          var notificationPage = value.data?.notificationPage;
          currentAppNotificationPage.value = notificationPage;

          if (refresh) {
            notifications.clear();
          }
          notifications.addAll(currentAppNotificationPage.value?.docs ?? []);

          print(
              'Fetched notifications: ${currentAppNotificationPage.value?.docs}');
          print('Notifications list: ${notifications.length}');

          isFetching.value = false;
          isRefreshing.value = false;
        },
        onError: (error, stackTrace) {
          failedText = error.toString();
          isFetching.value = false;
          isRefreshing.value = false;
          isFailed.value = true;
        },
      );

      failedText = null;
      isFetching.value = true;
      isRefreshing.value = refresh;
      isFailed.value = false;
    } catch (e) {
      failedText = e.toString();
      isFetching.value = false;
      isRefreshing.value = false;
      isFailed.value = true;
    }
  }

  insert(AppNotification? notification) {
    if (notification != null) {
      notifications.updateAll(
        elements: [notification],
        refresh: false,
        test: (notificationAt, notification) =>
            notificationAt.id == notification.id,
        upsert: true,
        fromStart: true,
      );

      notifications.refresh();
    }
  }
}
