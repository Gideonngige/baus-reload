import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/file_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/dumping/dumping_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class DumpingWidget extends ResponsiveWidget<DumpingController> {
  final String dumpingId;

  DumpingWidget({super.key, required this.dumpingId});

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => 'dumping $dumpingId';

  @override
  DumpingController get controller =>
      Get.put(DumpingController(dumpingId: dumpingId), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              try {
                Get.back();
              } catch (e) {
                // Fallback navigation
                Get.offAllNamed('/home');
              }
            },
            icon: const Icon(
              Icons.chevron_left,
              size: 30,
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            ),
            color: Colors.black,
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.campaign,
                      color: Colors.white,
                    ),
                    Gap(4),
                    Text(
                      'Reported',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: screen.context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: Image.asset(
                          'assets/images/delete_large.png',
                          width: 60,
                        ),
                        content: const Text(
                          'Delete this report?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: kAppTheme.primaryColor, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: kAppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 58, 148, 61),
                                  Color.fromARGB(255, 70, 197, 75),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: kAppTheme.primaryColor,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pop();
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => StartedWasteJobPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const Gap(10),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.fetch();
          },
          child: Obx(
            () {
              var dumping = controller.dumping.value;

              if (dumping == null) {
                return ListView();
              } else {
                return SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(screen.context).size.height * .5,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(25),
                          ),
                          child: FileWidget(
                            files: dumping.file != null ? [dumping.file!] : [],
                          ),
                        ),
                      ),
                      const Gap(30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width:
                                  MediaQuery.of(screen.context).size.width * .7,
                              child: Text(
                                dumping.area!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async => await Util.directions(
                                    dumping.point!.coordinates!),
                                icon: const Icon(
                                  Icons.directions_outlined,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      const Gap(30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(
                              text: Util.formatDate(
                                dumping.createdAt,
                                withTime: true,
                              ),
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            IconButton(
                                onPressed: () async {},
                                icon: const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        height: 2,
                        color: kAppTheme.hintColor.withOpacity(.1),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10),
                      ),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          dumping.message!,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
}


// ListView(
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.symmetric(
                //         vertical: 8,
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.stretch,
                //         children: [
                //           Container(
                //             margin: const EdgeInsets.symmetric(
                //               horizontal: 8,
                //               vertical: 8,
                //             ),
                //             decoration: BoxDecoration(
                //               borderRadius:
                //                   const BorderRadius.all(Radius.circular(8)),
                //               border: Border.all(
                //                 color: Colors.grey.shade200,
                //               ),
                //             ),
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.stretch,
                //               children: [
                //                 Stack(
                //                   children: [
                //                     ClipRRect(
                //                       borderRadius: const BorderRadius.vertical(
                //                         top: Radius.circular(8),
                //                       ),
                //                       child: FileWidget(
                //                         files: dumping.file != null
                //                             ? [dumping.file!]
                //                             : [],
                //                       ),
                //                     ),
                //                     if (dumping.file!.type == 'video')
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
                //               ],
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.only(
                //               top: 16,
                //               right: 16,
                //               left: 16,
                //             ),
                //             child: Text(
                //               dumping.message!,
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.symmetric(
                //               horizontal: 16,
                //               vertical: 16,
                //             ),
                //             child: Text(
                //               'Location & date reported',
                //               style:
                //                   Theme.of(screen.context).textTheme.bodySmall,
                //             ),
                //           ),
                //           Container(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 16,
                //             ),
                //             margin: const EdgeInsets.only(
                //               left: 16,
                //               right: 16,
                //               bottom: 16,
                //             ),
                //             decoration: BoxDecoration(
                //               color: Colors.grey.shade100,
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Row(
                //               children: [
                //                 Expanded(
                //                   child: Text(
                //                     '${dumping.area}',
                //                   ),
                //                 ),
                //                 IconButton(
                //                   onPressed: () async => await Util.directions(
                //                       dumping.point!.coordinates!),
                //                   icon: const Icon(Icons.directions),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Container(
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 16,
                //             ),
                //             margin: const EdgeInsets.only(
                //               left: 16,
                //               right: 16,
                //               bottom: 16,
                //             ),
                //             decoration: BoxDecoration(
                //               color: Colors.grey.shade100,
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Row(
                //               children: [
                //                 Expanded(
                //                   child: Text(
                //                     Util.formatDate(dumping.createdAt,
                //                         withTime: true),
                //                   ),
                //                 ),
                //                 IconButton(
                //                   onPressed: () async {},
                //                   icon: const Icon(Icons.schedule),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // );

                

        // AppBar(
        //   title: Obx(
        //     () => Text(
        //         'Illegal dumping${controller.dumping.value != null ? ' (${controller.dumping.value!.status})' : ''}'),
        //   ),
        //   actions: [
        //     Obx(
        //       () => controller.dumping.value == null
        //           ? Container()
        //           : IconButton(
        //               onPressed: () async {
        //                 await Get.dialog(
        //                   DialogWidget(
        //                     title: 'Delete?',
        //                     content: 'Delete this dumping',
        //                     onConfirm: () async => await controller.delete(),
        //                     confirmText: 'Delete',
        //                   ),
        //                 );
        //               },
        //               icon: controller.isDeleting.isTrue
        //                   ? const SizedBox(
        //                       height: 24,
        //                       width: 24,
        //                       child: CircularProgressIndicator(
        //                         backgroundColor: Colors.white,
        //                       ),
        //                     )
        //                   : const Icon(Icons.delete),
        //             ),
        //     ),
        //   ],
        // ),