import 'package:baustaka/config/routes.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/_/place_type_widget.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingSelectPlaceTypeWidget
    extends ResponsiveWidget<HomeWasteManagerController> {
  BookingSelectPlaceTypeWidget({super.key});

  @override
  String get tag => 'home';

  @override
  HomeWasteManagerController get controller => Get.put(
        HomeWasteManagerController(),
        tag: tag,
        permanent: true,
      );

  @override
  Widget? desktop() => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const SizedBox(
                width: 96,
                height: 8,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => controller.firebaseUser.value == null
                  ? const Text('')
                  : Text(
                      'Hey, ${controller.firebaseUser.value?.displayName}',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: controller.userSocket.isConnected.isTrue
                                ? Theme.of(screen.context).primaryColor
                                : Colors.black,
                          ),
                    ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => Column(
                children: [
                  if (controller.picker.value != null) ...[
                    GestureDetector(
                      onTap: () async => await Get.toNamed(
                          '${Routes.kPicker}${controller.picker.value?.id}'),
                      child: Text(
                        '${controller.picker.value?.mode?.capitalize} · ${controller.picker.value?.plate}',
                      ),
                    ),
                    Text('${controller.picker.value?.station?.title}'),
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
                      Row(
                        children: [
                          Expanded(
                            child: PlaceTypeWidget(
                                title: 'Work',
                                subtitle: 'Pick up waste\nnearby',
                                iconData: Icons.work_outline,
                                onTap: () {
                                  controller.bookingState.value =
                                      BookingState.kDetails;
                                }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Divider(),
                      Obx(
                        () => ListTile(
                          onTap: () async => await Get.toNamed(Routes.kPosts),
                          title: Text(
                            'Upcoming pick ups',
                            style: Theme.of(screen.context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                              'You have ${controller.postPage.value != null ? controller.postPage.value?.total.toString() : 0} upcoming pick ups'),
                          trailing: controller.isFetching.isTrue
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () async => controller.fetch(),
                                ),
                        ),
                      ),
                    ],
                  ],
                  if (controller.isRegistered.isFalse) ...[
                    Text(
                      'You have not completed registration',
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
                          await Get.toNamed(Routes.kAddPicker),
                      child: const Text('Complete Registration'),
                    ),
                  ],
                  if (controller.isFetching.isTrue &&
                      controller.picker.value == null) ...[
                    Text(
                      'Please wait...',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const CircularProgressIndicator(),
                  ],
                  if (controller.isFetching.isFalse &&
                      controller.isRegistered.isTrue &&
                      controller.picker.value == null) ...[
                    Text(
                      'Something went wrong. Try again',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async => await controller.fetch(),
                      child: const Text('Try again'),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      );
}
