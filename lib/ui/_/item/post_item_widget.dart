import 'dart:ui';

import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/post.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class PostItemWidget extends StatelessWidget {
  final Post post;

  const PostItemWidget({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Get.toNamed('${Routes.kPost}${post.id}'),
      child: Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(14.0), child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14.0)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        border: const Border(
                          bottom: BorderSide(
                            width: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${post.type!.capitalize} · ${post.status!.capitalize}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(14.0),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      // height: 90,
                      color: Colors.black.withOpacity(.4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _rowContainer('Placed'),
                              _rowContainer('Confirmed'),
                              _rowContainer('Picked Up'),
                            ],
                          ),
                          const Gap(15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white,
                                  ),
                                  const Gap(4),
                                  Text(
                                    post.area!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.event,
                                    color: Colors.white,
                                  ),
                                  const Gap(4),
                                  Text(
                                    Util.formatDate(
                                      post.createdAt,
                                      withTime: true,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // GestureDetector(
    //   // onTap: () async => await Get.toNamed('${Routes.kPost}${post.id}'),
    //   child: Container(
    //     margin: const EdgeInsets.symmetric(
    //       vertical: 8,
    //       horizontal: 16,
    //     ),
    //     decoration: BoxDecoration(
    //       border: Border.all(
    //         color: Colors.grey.shade200,
    //       ),
    //       borderRadius: const BorderRadius.all(
    //         Radius.circular(8),
    //       ),
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         // if (post.files != null && post.files!.isNotEmpty)
    //         // Stack(
    //         //   children: [
    //         //     FileWidget(
    //         //       files: post.files,
    //         //     ),
    //         //     if (post.files![0].type == 'video')
    //         //       Positioned(
    //         //         bottom: 0,
    //         //         top: 0,
    //         //         left: 0,
    //         //         right: 0,
    //         //         child: Icon(
    //         //           Icons.play_circle_outline,
    //         //           color: Colors.white.withOpacity(0.8),
    //         //           size: 48,
    //         //         ),
    //         //       )
    //         //   ],
    //         // ),
    //         Container(
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade200,
    //           ),
    //           padding: const EdgeInsets.all(16),
    //           child: Center(
    //             child: Text(
    //               'post type - post.status',
    //               // '${post.type!.capitalize} · ${post.status!.capitalize}',
    //               style: const TextStyle(
    //                 color: Palette.primary,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //         ),
    //         // if (post.product != null) ...[
    //         ListTile(
    //           title: Text(
    //             'Subscription plan',
    //             style: Theme.of(context).textTheme.bodySmall,
    //           ),
    //           subtitle: Text(
    //             'prod name . pickup frequency . monthly',
    //             // '${post.product!.name} · ${post.product!.weeklyPickups}x weekly (${post.product!.weeklyPickups! * 4}x monthly)',
    //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //           ),
    //         ),
    //         const Divider(),
    //       // ]
    //         ListTile(
    //           title: Text(
    //             'Pick up address',
    //             style: Theme.of(context).textTheme.bodySmall,
    //           ),
    //           subtitle: Text(
    //             'area',
    //             // 'post.area!,'
    //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //           ),
    //           trailing: const IconWidget(Icons.directions),
    //           // onTap: () async => Util.directions(post.point!.coordinates!),
    //         ),
    //         ListTile(
    //           title: Text(
    //             'Pick up date and time',
    //             style: Theme.of(context).textTheme.bodySmall,
    //           ),
    //           subtitle: Text(
    //             'We will reach out to you to confirm date and time of collection',
    //             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Container(
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade200,
    //           ),
    //           child: ListTile(
    //             title: Text(
    //               'Booked on',
    //               style: Theme.of(context).textTheme.bodySmall,
    //             ),
    //             subtitle: Text(
    //               'created date',
    //               // Util.formatDate(
    //               //   post.createdAt,
    //               //   withTime: true,
    //               // ),
    //               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //             ),
    //             trailing: ElevatedButton(
    //               onPressed: () {},
    //               // onPressed: () async =>
    //               //     await Get.toNamed('${Routes.kPost}${post.id}'),
    //               child: const Text('View'),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _rowContainer(String label) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const Gap(8),
        Container(
          width: 120,
          height: 6,
          decoration: BoxDecoration(
            color: kAppTheme.primaryColor,
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
