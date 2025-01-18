import 'package:baustaka/config/routes.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/picker/picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickerWidget extends ResponsiveWidget<PickerController> {
  final String pickerId;

  PickerWidget({
    super.key,
    required this.pickerId,
  });

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'picker $pickerId';

  @override
  PickerController get controller =>
      Get.put(PickerController(pickerId: pickerId), tag: tag);

  @override
  Widget? desktop() => Scaffold(
        appBar: AppBar(
          title: const Text('Your vehicle'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var picker = controller.picker.value;

              if (picker == null) {
                return ListView();
              } else {
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 32,
                          ),
                          GestureDetector(
                            onTap: () async => await Get.toNamed(
                                '${Routes.kPicker}${controller.picker.value?.id}'),
                            child: Text(
                              '${controller.picker.value?.mode?.capitalize} · ${controller.picker.value?.plate}',
                            ),
                          ),
                          Text('${controller.picker.value?.station?.title}'),
                          TextButton(
                            onPressed: () async => await Get.toNamed(
                                '${Routes.kStation}${controller.picker.value?.station?.id}'),
                            child: const Text('View transfer station'),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (controller.picker.value?.status == 'pending') ...[
                            Text(
                              'Your registration is awaiting approval',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async =>
                                  await Get.toNamed(Routes.kIssues),
                              child: const Text('Get support'),
                            ),
                          ],
                          if (controller.picker.value?.status == 'blocked') ...[
                            Text(
                              'You have been blocked from accessing this service',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              onPressed: () async =>
                                  await Get.toNamed(Routes.kIssues),
                              child: const Text('Ask why'),
                            ),
                          ],
                          if (controller.picker.value?.status == 'active') ...[
                            Text(
                              'You are active on this platform',
                              style: Theme.of(screen.context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(),
                            ),
                          ],
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
}
