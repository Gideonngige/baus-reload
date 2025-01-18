import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:baustaka/ui/_/item/picker_item_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/post/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostWidget extends ResponsiveWidget<PostController> {
  final String postId;

  PostWidget({super.key, required this.postId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'post $postId';

  @override
  PostController get controller =>
      Get.put(PostController(postId: postId), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Pickup'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var post = controller.post.value;

              if (post == null) {
                return ListView();
              } else {
                return ListView(
                  children: [
                    if (post.files != null && post.files!.isNotEmpty)
                      Stack(
                        children: [
                          FileWidget(
                            files: post.files,
                          ),
                          if (post.files![0].type == 'video')
                            Positioned(
                              bottom: 0,
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white.withOpacity(0.8),
                                size: 48,
                              ),
                            )
                        ],
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          '${post.type!.capitalize} · ${post.status!.capitalize!}',
                          style: const TextStyle(
                            color: Palette.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (post.picker != null) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      PickerItemWidget(
                        picker: post.picker!,
                      ),
                    ],
                    if (post.product != null) ...[
                      ListTile(
                        title: Text(
                          'Subscription plan',
                          style: Theme.of(screen.context).textTheme.bodySmall,
                        ),
                        subtitle: Text(
                          '${post.product!.name} · ${post.product!.weeklyPickups}x weekly (${post.product!.weeklyPickups! * 4}x monthly)',
                          style: Theme.of(screen.context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const Divider(),
                    ],
                    ListTile(
                      title: Text(
                        'Booking for',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.client!.capitalize!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Pick up using',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.mode!.capitalize!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      trailing: post.client == 'residential'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(screen.context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Ksh ${post.price}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                    ),
                    ListTile(
                      title: Text(
                        'Pick up address',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.area!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onTap: () async =>
                          Util.directions(post.point!.coordinates!),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MapWidget(
                      onMapCreated: (updateMap) {
                        controller.updateMap = updateMap;

                        controller.updateLocation();
                      },
                      radius: 0,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListTile(
                      title: Text(
                        'Pick up date and time',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        'We will reach out to you to confirm date and time of collection',
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (post.product == null)
                      ListTile(
                        title: Text(
                          'How often',
                          style: Theme.of(screen.context).textTheme.bodySmall,
                        ),
                        subtitle: Text(
                          post.frequency!.capitalize!,
                          style: Theme.of(screen.context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        'Drop off (transfer station)',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.station!.title!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      onTap: () =>
                          Util.directions(post.station!.point!.coordinates!),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        'Type of waste',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.categories!
                            .map(
                              (e) => e.capitalize!,
                            )
                            .join(', '),
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'How the waste is sorted',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.groups!
                            .map(
                              (e) => e.capitalize!,
                            )
                            .join(', '),
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'No. of ${post.type == 'sale' ? 'kilos' : 'waste bags'}',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.total == -1
                            ? '3+'
                            : post.total.toString().capitalize!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                        '${post.type == 'sale' ? 'Paid' : 'Billed'} ${post.frequency} to  M-PESA phone number (${post.payment})',
                        style: Theme.of(screen.context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        post.phoneNumber!,
                        style: Theme.of(screen.context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (post.client != 'residential')
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListTile(
                          title: Text(
                            'Please note!',
                            style: Theme.of(screen.context).textTheme.bodySmall,
                          ),
                          subtitle: Text(
                            'We will reach out to you with a ${post.client} quotation',
                            style: Theme.of(screen.context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          contentPadding: const EdgeInsets.all(0),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                      ),
                      child: ListTile(
                        title: Text(
                          'Booked on',
                          style: Theme.of(screen.context).textTheme.bodySmall,
                        ),
                        subtitle: Text(
                          Util.formatDate(
                            post.createdAt,
                            withTime: true,
                          ),
                          style: Theme.of(screen.context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    if (post.payment == 'pending' &&
                        post.type == 'disposal' &&
                        post.client == 'residential')
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          child: controller.isUpdating.isTrue
                              ? const CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : const Text('Make payment'),
                          onPressed: () async => await Get.dialog(
                            DialogWidget(
                              title: 'M-Pesa Phone number',
                              content:
                                  'Enter your M-Pesa phone number to use to make payment',
                              onConfirm: () async => controller.pay(),
                              hintText: '0700123456',
                              inputController: controller.phoneNumber,
                              confirmText: 'Pay',
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      );
}
