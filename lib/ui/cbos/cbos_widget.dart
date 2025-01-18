import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/empty_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/cbos/cbo_widget.dart';
import 'package:baustaka/ui/cbos/cbos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CbosWidget extends ResponsiveWidget<CbosController> {
  final bool withAppbar;

  final String? owner;

  CbosWidget({
    super.key,
    this.withAppbar = false,
    this.owner,
  });

  @override
  bool get shouldAdjust => false;

  @override
  String get tag => Util.tag(
        owner: owner,
      );

  @override
  CbosController get controller => Get.put(
        CbosController(
          owner: owner,
        ),
        tag: tag,
      );

  @override
  Widget? tablet() => Scaffold(
        appBar: withAppbar
            ? AppBar(
                title: const Text('My CBOs'),
                actions: [
                  TextButton(
                    onPressed: () async => await Get.toNamed(Routes.kAddCbo),
                    child: const Text('Register'),
                  ),
                ],
              )
            : null,
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
                    hintText: 'Search CBOs...',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => controller.q.value = value,
                ),
              ),
              Obx(
                () => EmptyWidget(
                  isEmpty:
                      controller.cbos.isEmpty || controller.isRefreshing.isTrue,
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
                          CboWidget(
                            cbo: controller.cbos[index],
                            onUpdate: () async {
                              await controller.fetch(
                                refresh: true,
                              );
                            },
                          ),
                          Obx(
                            () => Visibility(
                              visible: controller.isFetching.isTrue &&
                                  controller.cbos.isNotEmpty &&
                                  index == controller.cbos.length - 1 &&
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
                      itemCount: controller.cbos.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
