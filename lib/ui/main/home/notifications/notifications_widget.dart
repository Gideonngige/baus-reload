import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/main/home/notifications/notification_widget.dart';
import 'package:baustaka/ui/main/home/notifications/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsWidget extends GetResponsiveView<NotificationsController> {
  NotificationsWidget({super.key});

  @override
  String get tag => Util.tag();

  @override
  NotificationsController get controller => Get.put(
        NotificationsController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: Obx(
            () => controller.isSearching.isFalse
                ? const Text('Notifications')
                : TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search notifications...',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => controller.q.value = '',
                  ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                controller.isSearching.toggle();

                controller.q.value = null;
              },
              icon: Obx(
                () => Icon(
                  controller.isSearching.isFalse ? Icons.search : Icons.close,
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async => await controller.fetch(
            refresh: true,
          ),
          child: Column(
            children: [
              Obx(
                () => EmptyWidget(
                  isEmpty: controller.notifications.isEmpty ||
                      controller.isRefreshing.isTrue,
                  isProgressing: controller.isFetching.isTrue,
                  isFailed: controller.isFailed.isTrue,
                  onPressed: () => controller.fetch(refresh: true),
                  onEmpty: () => controller.fetch(refresh: true),
                  emptyText: 'No notifications',
                  failedText: controller.failedText,
                ),
              ),
              Expanded(
                child: Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent) {
                        controller.fetch();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        bottom: 48,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          NotificationWidget(
                            notification: controller.notifications[index],
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.isFetching.isTrue &&
                                  controller.notifications.isNotEmpty &&
                                  index ==
                                      controller.notifications.length - 1 &&
                                  controller.isRefreshing.isFalse,
                              child: Container(
                                margin: const EdgeInsets.all(32),
                                child: const ProgressWidget(
                                  color: Palette.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemCount: controller.notifications.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
