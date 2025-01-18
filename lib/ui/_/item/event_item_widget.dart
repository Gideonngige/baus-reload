import 'dart:ui';

import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventItemWidget extends StatelessWidget {
  final Event event;

  const EventItemWidget({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await Get.toNamed('${Routes.kEvent}${event.id}'),
      child: Container(
        height: 320,
        margin: const EdgeInsets.only(bottom: 30.0, left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: FileWidget(
                files: event.files,
              ),
            ),
            if (event.files![0].type == 'video')
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.diversity_1_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            event.rsvpd!
                                ? (event.rsvps! + (event.rsvpd == true ? 0 : 1))
                                    .toString()
                                : event.rsvps.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      color: Colors.black.withOpacity(.3),
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
                            event.title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 14),
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
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      event.area!,
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      Util.formatDate(event.date,
                                          withTime: true),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                      border: Border(
                        bottom:
                            BorderSide(color: kAppTheme.primaryColor, width: 2),
                        left:
                            BorderSide(color: kAppTheme.primaryColor, width: 2),
                        right:
                            BorderSide(color: kAppTheme.primaryColor, width: 2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: kAppTheme.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'Join Event',
                          style: TextStyle(
                            color: kAppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
    //   onTap: () async => await Get.toNamed('${Routes.kEvent}${event.id}'),
    //   child: Container(
    //     margin: const EdgeInsets.symmetric(
    //       vertical: 8,
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: [
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
    //               if (event.files != null && event.files!.isNotEmpty)
    //                 Stack(
    //                   children: [
    //                     ClipRRect(
    //                       borderRadius: const BorderRadius.vertical(
    //                         top: Radius.circular(8),
    //                       ),
    //                       child: FileWidget(
    //                         files: event.files,
    //                       ),
    //                     ),
    //                     if (event.files![0].type == 'video')
    //                       Positioned(
    //                         bottom: 0,
    //                         top: 0,
    //                         left: 0,
    //                         right: 0,
    //                         child: Icon(
    //                           Icons.play_circle_outline,
    //                           color: Colors.white.withOpacity(0.8),
    //                           size: 48,
    //                         ),
    //                       )
    //                   ],
    //                 ),
    //               Container(
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.shade50,
    //                 ),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     TextButton.icon(
    //                       onPressed: () {},
    //                       icon: event.rsvpd!
    //                           ? const Icon(
    //                               Icons.group_outlined,
    //                               color: Palette.primary,
    //                               size: 18,
    //                             )
    //                           : Icon(
    //                               Icons.group_outlined,
    //                               size: 18,
    //                               color: Theme.of(context)
    //                                   .textTheme
    //                                   .bodySmall
    //                                   ?.color,
    //                             ),
    //                       label: Text(
    //                         '${event.rsvpd! ? (event.rsvps! + (event.rsvpd == true ? 0 : 1)).toString() : event.rsvps.toString()} attendees',
    //                         style:
    //                             Theme.of(context).textTheme.bodySmall?.copyWith(
    //                                   color: Colors.black87,
    //                                 ),
    //                       ),
    //                     ),
    //                     TextButton.icon(
    //                       onPressed: () async {
    //                         try {
    //                           await Share.share(
    //                               'https://baustaka.co.ke/event?eventId=${event.id}');
    //                         } catch (e) {
    //                           Util.toast(e);
    //                         }
    //                       },
    //                       icon: Icon(
    //                         Icons.share,
    //                         size: 18,
    //                         color: Theme.of(context).textTheme.bodySmall?.color,
    //                       ),
    //                       label: Text(
    //                         'Share',
    //                         style:
    //                             Theme.of(context).textTheme.bodySmall?.copyWith(
    //                                   color: Colors.black87,
    //                                 ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
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
    //             event.title!,
    //             style: const TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.symmetric(
    //             horizontal: 16,
    //             vertical: 16,
    //           ),
    //           child: Text(
    //             'Venue & time',
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
    //             color: Colors.grey.shade200,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   '${event.area}',
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
    //             color: Colors.grey.shade200,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Text(
    //                   Util.formatDate(event.date, withTime: true),
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () async {},
    //                 icon: const Icon(Icons.schedule),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Container(
    //           margin: const EdgeInsets.only(
    //             bottom: 16,
    //             top: 8,
    //             left: 16,
    //             right: 16,
    //           ),
    //           child: event.rsvpd!
    //               ? OutlinedButton.icon(
    //                   onPressed: () async =>
    //                       await Get.toNamed('${Routes.kEvent}${event.id}'),
    //                   icon: const Icon(
    //                     Icons.remove_circle_outline,
    //                     size: 18,
    //                   ),
    //                   label: const Text(
    //                     'Remove event',
    //                   ),
    //                 )
    //               : ElevatedButton.icon(
    //                   onPressed: () async =>
    //                       await Get.toNamed('${Routes.kEvent}${event.id}'),
    //                   icon: const Icon(
    //                     Icons.add_circle_outline,
    //                     size: 18,
    //                   ),
    //                   label: const Text(
    //                     'Join event',
    //                   ),
    //                 ),
    //         ),
    //         const Divider(),
    //       ],
    //     ),
    //   ),
    // );
  }
}
