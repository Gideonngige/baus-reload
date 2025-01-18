import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/csrs/csr_widget.dart';
import 'package:baustaka/ui/csrs/csrs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CsrsWidget extends ResponsiveWidget<CsrsController> {
  CsrsWidget({
    super.key,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag();

  @override
  CsrsController get controller => Get.put(
        CsrsController(),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.fetch(
              refresh: true,
            );
          },
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search CSRs...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => controller.q.value = value,
                ),
              ),
              Obx(
                () => EmptyWidget(
                  isEmpty:
                      controller.csrs.isEmpty || controller.isRefreshing.isTrue,
                  isProgressing: controller.isFetching.isTrue,
                  isFailed: controller.isFailed.isTrue,
                  onPressed: () => controller.fetch(
                    refresh: true,
                  ),
                  onEmpty: () => controller.fetch(
                    refresh: true,
                  ),
                  emptyText: 'Nothing found. Tap to refresh',
                ),
              ),
              Expanded(
                child: Obx(
                  () => NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent + 80) {
                        controller.fetch();
                      }
                      return false;
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: 48,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          CsrWidget(
                            csr: controller.csrs[index],
                            onUpdate: () async {
                              await controller.fetch(
                                refresh: true,
                              );
                            },
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.isFetching.isTrue &&
                                  controller.csrs.isNotEmpty &&
                                  index == controller.csrs.length - 1 &&
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
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 16,
                      ),
                      itemCount: controller.csrs.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
