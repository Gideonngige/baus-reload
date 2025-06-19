import 'dart:ui';

import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/dumping.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DumpingItemWidget extends StatelessWidget {
  final Dumping dumping;

  const DumpingItemWidget({
    super.key,
    required this.dumping,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Get.toNamed('${Routes.kDumping}${dumping.id}'),
      child: Container(
        height: 320,
        margin: const EdgeInsets.only(bottom: 30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: FileWidget(
                files: dumping.file != null ? [dumping.file!] : [],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.campaign,
                            color: Colors.white,
                          ),
                          const Gap(4),
                          Text(
                            '${dumping.status}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (dumping.file != null && dumping.file!.type == 'video')
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
                  ),
                Expanded(
                  child: Container(),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(.4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dumping.message != null && dumping.message!.length > 100
                                ? '${dumping.message!.substring(0, 100)}...'
                                : dumping.message ?? 'No message',
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const Gap(10),
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
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      dumping.area ?? 'Unknown location',
                                      softWrap: true,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
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
                                  FittedBox(
                                    child: Text(
                                      Util.formatDate(
                                        dumping.createdAt,
                                        withTime: true,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
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
    //   onTap: () async => await Get.toNamed('${Routes.kDumping}${dumping.id}'),
    //   child: Container(
    //     margin: const EdgeInsets.symmetric(
    //       vertical: 8,
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
    //         Container(
    //           color: Colors.grey.shade100,
    //           child: Padding(
    //             padding: const EdgeInsets.all(16),
    //             child: Text(
    //               '${dumping.status!.capitalize}',
    //               style: const TextStyle(
    //                 fontWeight: FontWeight.bold,
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(
    //             horizontal: 8,
    //             vertical: 8,
    //           ),
    //           decoration: BoxDecoration(
    //             borderRadius: const BorderRadius.all(Radius.circular(8)),
    //             border: Border.all(
    //               color: Colors.grey.shade200,
    //             ),
    //           ),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [
    //               Stack(
    //                 children: [
    //                   ClipRRect(
    //                     borderRadius: const BorderRadius.vertical(
    //                       top: Radius.circular(8),
    //                     ),
    //                     child: FileWidget(
    //                       files: dumping.file != null ? [dumping.file!] : [],
    //                     ),
    //                   ),
    //                   if (dumping.file!.type == 'video')
    //                     Positioned(
    //                       bottom: 0,
    //                       top: 0,
    //                       left: 0,
    //                       right: 0,
    //                       child: Icon(
    //                         Icons.play_circle_outline,
    //                         color: Colors.white.withOpacity(0.8),
    //                         size: 48,
    //                       ),
    //                     )
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.only(
    //             top: 16,
    //             right: 16,
    //             left: 16,
    //           ),
    //           child: Text(
    //             dumping.message!,
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(
    //             horizontal: 16,
    //             vertical: 16,
    //           ),
    //           child: Text(
    //             'Location & date reported',
    //             style: Theme.of(context).textTheme.bodySmall,
    //           ),
    //         ),
    //         Container(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 16,
    //           ),
    //           margin: const EdgeInsets.only(
    //             left: 16,
    //             right: 16,
    //             bottom: 16,
    //           ),
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade100,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   '${dumping.area}',
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () async {},
    //                 icon: const Icon(Icons.directions),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           padding: const EdgeInsets.symmetric(
    //             horizontal: 16,
    //           ),
    //           margin: const EdgeInsets.only(
    //             left: 16,
    //             right: 16,
    //             bottom: 16,
    //           ),
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade100,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   Util.formatDate(dumping.createdAt, withTime: true),
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () async {},
    //                 icon: const Icon(Icons.schedule),
    //               ),
    //             ],
    //           ),
    //         ),
    //         const Divider(),
    //       ],
    //     ),
    //   ),
    // );
  }
}
