import 'dart:ui';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/map/map_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'add_dumping_controller.dart';

class AddDumpingWidget extends ResponsiveWidget<AddDumpingController> {
  AddDumpingWidget({super.key});

  @override
  String get tag => 'add_dumping';

  @override
  bool get shouldAdjust => true;

  @override
  AddDumpingController get controller =>
      Get.put(AddDumpingController(), tag: tag);

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
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
          title: TitleText(
            text: 'Illegal Dumping',
            color: kAppTheme.primaryColor,
            fontSize: 22,
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: const Text('Camera'),
                  onTap: () async {
                    try {
                      await controller.pickFile(ImageSource.camera);
                    } catch (e) {
                      Util.toast(e);
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Text('Gallery'),
                  onTap: () async {
                    try {
                      await controller.pickFile(ImageSource.gallery);
                    } catch (e) {
                      Util.toast(e);
                    }
                  },
                ),
              ],
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                ),
              ),
            ),
          ],
        ),
        body: SlidingUpPanel(
          color: Colors.transparent,
          maxHeight: MediaQuery.of(screen.context).size.height * .7,
          minHeight: MediaQuery.of(screen.context).size.height * .3,
          body: Stack(
            children: [
              Obx(
                () => MapWidget(
                  markers: controller.pickers
                      .map(
                        (e) => Marker(
                          markerId: MarkerId(e.id!),
                          position: LatLng(
                            e.point!.coordinates![1],
                            e.point!.coordinates![0],
                          ),
                          infoWindow: InfoWindow(
                            title: e.user?.displayName,
                            snippet: '${e.mode?.capitalize} ${e.plate}',
                            onTap: () async =>
                                await Get.toNamed('${Routes.kPost}${e.id}'),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Column(
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                      child: Container(
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    var prediction =
                                        await PlacesAutocomplete.show(
                                      context: screen.context,
                                      apiKey: kGoogleApiKey,
                                      mode: Mode.overlay,
                                      overlayBorderRadius:
                                          BorderRadius.circular(8),
                                      components: [
                                        Component(Component.country, 'ke')
                                      ],
                                      strictbounds: false,
                                      types: [],
                                      proxyBaseUrl:
                                          kIsWeb ? kProxyBaseUrl : null,
                                    );

                                    if (prediction != null &&
                                        prediction.placeId != null) {
                                      final place = await GoogleMapsPlaces(
                                        apiKey: kGoogleApiKey,
                                        apiHeaders:
                                            await const GoogleApiHeaders()
                                                .getHeaders(),
                                        baseUrl: kIsWeb ? kProxyBaseUrl : null,
                                      ).getDetailsByPlaceId(
                                          prediction.placeId!);

                                      if (place.hasNoResults) {
                                        throw 'Something went wrong. Try again';
                                      }

                                      controller.area.value =
                                          prediction.description;
                                      controller.latitude =
                                          place.result.geometry!.location.lat;
                                      controller.longitude =
                                          place.result.geometry!.location.lng;
                                    }
                                  } catch (e) {
                                    Util.toast(e);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.search),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Obx(() => Text(
                                            controller.area.value ??
                                                'Search your location')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            IconButton(
                              onPressed: () async =>
                                  await controller.updateCurrentLocation(),
                              icon: Obx(
                                () => controller.isRequestingMyLocation.isTrue
                                    ? const CircularProgressIndicator()
                                    : const Icon(
                                        Icons.my_location_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          panelBuilder: (sController) => PanelWidget(
            scrollController: sController,
            controller: controller,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
      );
}

class PanelWidget extends StatelessWidget {
  final AddDumpingController controller;
  final ScrollController scrollController;

  const PanelWidget({
    super.key,
    required this.scrollController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          controller: scrollController,
          children: [
            const Gap(10),
            // drag handle bar
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * .3,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.6),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Gap(30),
            Obx(
              () => controller.bytes.value != null
                  ? Image.memory(
                      controller.bytes.value!,
                      fit: BoxFit.cover,
                      height: 250,
                    )
                  : PopupMenuButton(
                      itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: const Text('Camera'),
                          onTap: () async {
                            try {
                              await controller.pickFile(ImageSource.camera);
                            } catch (e) {
                              Util.toast(e);
                            }
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('Gallery'),
                          onTap: () async {
                            try {
                              await controller.pickFile(ImageSource.gallery);
                            } catch (e) {
                              Util.toast(e);
                            }
                          },
                        ),
                      ],
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10.0),
                          border:
                              Border.all(color: kAppTheme.hintColor, width: .5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60,
                              color: kAppTheme.hintColor,
                            ),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: kAppTheme.hintColor,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
            const Gap(30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10.0),
                border: Border.all(color: kAppTheme.primaryColor, width: .5),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  minLines: 4,
                  maxLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) => controller.message.value = value,
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const Gap(30),
            ElevatedButtonWidget(
              onPressed: () async {
                if (controller.check()) {
                  await Get.dialog(
                    DialogWidget(
                      title: 'Report Illegal Dumping?',
                      content:
                          'You are about to report illegal dumping. Please confirm.',
                      onConfirm: () async {
                        await controller.add();
                      },
                    ),
                  );
                }
              },
              child: Obx(
                () => controller.isAdding.isTrue
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text('Report'),
              ),
            ),
            const Gap(30),
            SizedBox(
              height: 150,
              child: Image.asset(
                'assets/images/report_large.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


   // ListView(
        //   children: [
        //     Container(
        //       margin: const EdgeInsets.all(16),
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(8),
        //         child: Obx(
        //           () => controller.bytes.value != null
        //               ? Image.memory(
        //                   controller.bytes.value!,
        //                   fit: BoxFit.cover,
        //                 )
        //               : Container(),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 16,
        //     ),
        //     Container(
        //       margin: const EdgeInsets.symmetric(
        //         horizontal: 16,
        //       ),
        //       child: Text(
        //         'Location',
        //         style: Theme.of(screen.context).textTheme.bodySmall,
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 16,
        //     ),
        //     Row(
        //       children: [
        //         const SizedBox(
        //           width: 16,
        //         ),
        //         Expanded(
        //           child: GestureDetector(
        //             onTap: () async {
        //               try {
        //                 var prediction = await PlacesAutocomplete.show(
        //                   context: screen.context,
        //                   apiKey: kGoogleApiKey,
        //                   mode: Mode.overlay,
        //                   overlayBorderRadius: BorderRadius.circular(8),
        //                   components: [Component(Component.country, 'ke')],
        //                   strictbounds: false,
        //                   types: [],
        //                   proxyBaseUrl: kIsWeb ? kProxyBaseUrl : null,
        //                 );

        //                 if (prediction != null && prediction.placeId != null) {
        //                   final place = await GoogleMapsPlaces(
        //                     apiKey: kGoogleApiKey,
        //                     apiHeaders:
        //                         await const GoogleApiHeaders().getHeaders(),
        //                     baseUrl: kIsWeb ? kProxyBaseUrl : null,
        //                   ).getDetailsByPlaceId(prediction.placeId!);

        //                   if (place.hasNoResults) {
        //                     throw 'Something went wrong. Try again';
        //                   }

        //                   controller.area.value = prediction.description;
        //                   controller.latitude =
        //                       place.result.geometry!.location.lat;
        //                   controller.longitude =
        //                       place.result.geometry!.location.lng;
        //                 }
        //               } catch (e) {
        //                 Util.toast(e);
        //               }
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 color: Colors.grey.shade200,
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 16,
        //                 vertical: 12,
        //               ),
        //               child: Row(
        //                 children: [
        //                   const Icon(Icons.search),
        //                   const SizedBox(
        //                     width: 8,
        //                   ),
        //                   Expanded(
        //                     child: Obx(() =>
        //                         Text(controller.area.value ?? 'Search place')),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         IconButton(
        //           onPressed: () async =>
        //               await controller.updateCurrentLocation(),
        //           icon: Obx(
        //             () => controller.isRequestingMyLocation.isTrue
        //                 ? const CircularProgressIndicator()
        //                 : const Icon(
        //                     Icons.my_location_outlined,
        //                   ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Container(
        //       padding: const EdgeInsets.symmetric(
        //         horizontal: 16,
        //       ),
        //       margin: const EdgeInsets.only(
        //         right: 16,
        //         left: 16,
        //         top: 16,
        //         bottom: 16,
        //       ),
        //       decoration: BoxDecoration(
        //         color: Colors.grey.shade100,
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       child: Row(
        //         children: [
        //           Expanded(
        //             child: TextField(
        //               decoration: const InputDecoration(
        //                 labelText: 'Message',
        //                 border: InputBorder.none,
        //               ),
        //               textCapitalization: TextCapitalization.sentences,
        //               minLines: 4,
        //               maxLines: 8,
        //               onChanged: (value) => controller.message.value = value,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       margin: const EdgeInsets.only(
        //           right: 16, left: 16, top: 16, bottom: 24),
        //       child: ElevatedButton(
        //         onPressed: () async {
        //           if (controller.check()) {
        //             await Get.dialog(
        //               DialogWidget(
        //                 title: 'Report Illegal Dumping?',
        //                 content:
        //                     'You are about to report illegal dumping. Please confirm.',
        //                 onConfirm: () async {
        //                   await controller.add();
        //                 },
        //               ),
        //             );
        //           }
        //         },
        //         child: Obx(() => controller.isAdding.isTrue
        //             ? const CircularProgressIndicator(
        //                 backgroundColor: Colors.white,
        //                 strokeWidth: 2,
        //               )
        //             : const Text('Report')),
        //       ),
        //     ),
        //   ],
        // ),
    