import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui_picker/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingPaymentWidget
    extends ResponsiveWidget<HomeWasteManagerController> {
  BookingPaymentWidget({super.key});

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
        color: Theme.of(screen.context).primaryColor,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SingleChildScrollView(
              key: const Key('booking_payment'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Pick up details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: Text(
                      'Pick up address',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      controller.post.value?.area ?? 'Area',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      'Pick up date and time',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      Util.formatDate(
                        controller.post.value?.date,
                        withTime: true,
                      ),
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      'Drop off (transfer station)',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      Util.formatDate(
                        controller.post.value?.date,
                        withTime: true,
                      ),
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      'Type of waste',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      controller.post.value?.categories
                              ?.map(
                                (e) => e.capitalize,
                              )
                              .join(', ') ??
                          'Unknown',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      'How the waste is sorted',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      controller.post.value?.groups
                              ?.map(
                                (e) => e.capitalize,
                              )
                              .join(', ') ??
                          'Unknown',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      'No. of waste bags',
                      style: Theme.of(screen.context).textTheme.bodySmall,
                    ),
                    subtitle: Text(
                      controller.post.value?.total == -1
                          ? '3+'
                          : controller.post.value?.total
                                  .toString()
                                  .capitalize ??
                              'Unknown',
                      style: Theme.of(screen.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        if (controller.post.value == null ||
                            (controller.post.value?.status != 'started' &&
                                controller.post.value?.status !=
                                    'collected')) ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_back),
                            label: const Text(''),
                            onPressed: () => controller.bookingState.value =
                                BookingState.kDetails,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                        Expanded(
                          child: ElevatedButton(
                            child: controller.isRequesting.isTrue
                                ? const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(controller.post.value?.status ==
                                        'accepted'
                                    ? 'Start'
                                    : controller.post.value?.status == 'started'
                                        ? 'Pick up'
                                        : 'Drop off'),
                            onPressed: () async => await Get.dialog(
                              DialogWidget(
                                title:
                                    'Mark as ${controller.post.value?.status == 'accepted' ? 'Started' : controller.post.value?.status == 'started' ? 'Collected' : 'Completed'}',
                                content:
                                    'You are about to mark this request as ${controller.post.value?.status == 'accepted' ? 'started' : controller.post.value?.status == 'started' ? 'collected' : 'completed'}',
                                onConfirm: () async => await controller.request(
                                    controller.post.value?.status == 'accepted'
                                        ? 'started'
                                        : controller.post.value?.status ==
                                                'started'
                                            ? 'collected'
                                            : 'completed'),
                                confirmText: controller.post.value?.status ==
                                        'accepted'
                                    ? 'Start'
                                    : controller.post.value?.status == 'started'
                                        ? 'Pick up'
                                        : 'Drop off',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
