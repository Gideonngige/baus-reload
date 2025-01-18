// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/champs/add_champ/add_champ_controller.dart';
import 'package:baustaka/ui/file/local_file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';

class AddChampWidget extends ResponsiveWidget<AddChampController> {
  AddChampWidget({
    super.key,
  });

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => Util.tag();

  @override
  AddChampController get controller => Get.put(
        AddChampController(),
        tag: tag,
      );

  _goToPosition() async {
    var newPosition = LatLng(
      (controller.map['lngLat'] as List<double>?)?[1] ??
          kInitialLatLng.latitude,
      (controller.map['lngLat'] as List<double>?)?[0] ??
          kInitialLatLng.longitude,
    );

    if (controller.updateMap != null) {
      controller.updateMap!(
        newPosition,
        showCircles: false,
        withZoom: kZoomForMarker,
      );
    }
  }

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Become an eco-champion'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const Text(
                'Tell us why',
              ),
              const Gap(10),
              TextField(
                onChanged: (value) => controller.map['description'] = value,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Details',
                  hintStyle: TextStyle(color: kAppTheme.hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kAppTheme.hintColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kAppTheme.hintColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kAppTheme.hintColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const Gap(20),
              const Text(
                'Where are you located',
                style: TextStyle(fontSize: 18),
              ),
              const Gap(10),
              Container(
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 210,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14.0),
                        child: MapWidget(
                          onMapCreated: (updateMap) async {
                            controller.updateMap = updateMap;

                            _goToPosition();
                          },
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14.0)),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 280,
                                    child: Obx(
                                      () => Text(
                                        controller.map['area'] ??
                                            'Select address',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton(
                                    itemBuilder: (context) => <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child:
                                            const Text('My current location'),
                                        onTap: () async {
                                          try {
                                            var position =
                                                await Util.currentPosition();

                                            controller.map['area'] = 'Area';

                                            controller.map.update(
                                                'lngLat',
                                                (value) => [
                                                      position.longitude,
                                                      position.latitude,
                                                    ]);

                                            _goToPosition();
                                          } catch (e) {
                                            Util.toast(e);
                                          }
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: const Text('Another location'),
                                        onTap: () async {
                                          try {
                                            Future.delayed(
                                              const Duration(
                                                milliseconds: 100,
                                              ),
                                              () async {
                                                var prediction =
                                                    await PlacesAutocomplete
                                                        .show(
                                                  context: screen.context,
                                                  apiKey: kGoogleApiKey,
                                                  mode: Mode.fullscreen,
                                                  strictbounds: false,
                                                  components: [],
                                                  types: [],
                                                  overlayBorderRadius:
                                                      BorderRadius.circular(
                                                          kDefaultRadius),
                                                );

                                                if (prediction != null &&
                                                    prediction.placeId !=
                                                        null) {
                                                  final place =
                                                      await GoogleMapsPlaces(
                                                    apiKey: kGoogleApiKey,
                                                    apiHeaders:
                                                        await const GoogleApiHeaders()
                                                            .getHeaders(),
                                                  ).getDetailsByPlaceId(
                                                          prediction.placeId!);

                                                  if (!place.hasNoResults) {
                                                    controller.map['area'] =
                                                        prediction.description;

                                                    controller.map.update(
                                                        'lngLat',
                                                        (value) => [
                                                              place
                                                                  .result
                                                                  .geometry!
                                                                  .location
                                                                  .lng,
                                                              place
                                                                  .result
                                                                  .geometry!
                                                                  .location
                                                                  .lat
                                                            ]);

                                                    _goToPosition();
                                                  }
                                                }
                                              },
                                            );
                                          } catch (e) {
                                            Util.toast(e);
                                          }
                                        },
                                      ),
                                    ],
                                    child: const Row(
                                      children: [
                                        Text(
                                          'Change',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
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
              const Gap(20),
              const Text(
                'Add upto 5 photos of your eco work',
                style: TextStyle(fontSize: 18),
              ),
              const Gap(10),
              PopupMenuButton(
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: const Text('Camera'),
                    onTap: () async {
                      try {
                        var file = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          maxWidth: 720,
                          maxHeight: 720,
                        );

                        if (file != null) {
                          controller.map.update(
                            'files',
                            (value) {
                              if ((value as List).length < 5) {
                                (value).add(
                                  File(file.path),
                                );
                              } else {
                                Util.toast('You can add up to 5 photos');
                              }

                              return value;
                            },
                          );
                        }
                      } catch (e) {
                        Util.toast(e);
                      }
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Gallery'),
                    onTap: () async {
                      try {
                        var xfiles = await ImagePicker().pickMultiImage(
                          maxWidth: 720,
                          maxHeight: 720,
                        );

                        List<Uint8List> bytesFiles = List.empty(
                          growable: true,
                        );

                        for (var element in xfiles) {
                          Uint8List bytes = await element.readAsBytes();

                          bytesFiles.add(bytes);
                        }

                        controller.map.update(
                          'files',
                          (value) {
                            var files = value as List<Uint8List>;

                            for (var element in bytesFiles) {
                              if (value.length < 5) {
                                (value).add(
                                  element,
                                );
                              } else {
                                Util.toast('You can add up to 5 photos');

                                break;
                              }
                            }

                            return files;
                          },
                        );
                      } catch (e) {
                        Util.toast(e);
                      }
                    },
                  ),
                ],
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10.0),
                    border: Border.all(color: kAppTheme.hintColor, width: .5),
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
              const Gap(10),
              Obx(
                () => Visibility(
                  visible:
                      (controller.map['files'] as List<Uint8List>).isNotEmpty,
                  child: SizedBox(
                    height: 120,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      itemCount: (controller.map['files'] as List).length,
                      itemBuilder: (context, index) {
                        var element =
                            (controller.map['files'] as List<Uint8List>)[index];
                        return GestureDetector(
                          onTap: () async => await Get.to(
                            () => LocalFilePreviewWidget(
                              file: element,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.memory(
                                      element,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: 120,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => controller.map.update(
                                      'files',
                                      (e) {
                                        (e as List<Uint8List>).remove(element);

                                        return e;
                                      },
                                    ),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 58, 148, 61),
                                            Color.fromARGB(255, 70, 197, 75),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        color: kAppTheme.primaryColor,
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 8,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible:
                      (controller.map['files'] as List<Uint8List>).isNotEmpty,
                  child: const SizedBox(
                    height: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButtonWidget(
                onPressed: () async {
                  await controller.submit();
                },
                child: Obx(
                  () => controller.isSubmitting.isTrue
                      ? const ProgressWidget()
                      : const Text('Apply'),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      );
}


   // const SizedBox(
              //   height: 8,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 16,
              //   ),
              //   child: MapWidget(
              //     onMapCreated: (updateMap) async {
              //       controller.updateMap = updateMap;

              //       _goToPosition();
              //     },
              //   ),
              // ),
              // ListTile(
              //   title: const Text(
              //       'Add up to 5 photos of your eco work (Optional)'),
              //   subtitle: Obx(() =>
              //       Text('${(controller.map['files'] as List).length} photos')),
              //   trailing: PopupMenuButton(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(kDefaultRadius),
              //     ),
              //     itemBuilder: (context) => <PopupMenuEntry>[
              //       PopupMenuItem(
              //         child: const Text('Camera'),
              //         onTap: () async {
              //           try {
              //             var file = await ImagePicker().pickImage(
              //               source: ImageSource.camera,
              //               maxWidth: 720,
              //               maxHeight: 720,
              //             );

              //             if (file != null) {
              //               controller.map.update(
              //                 'files',
              //                 (value) {
              //                   if ((value as List).length < 5) {
              //                     (value).add(
              //                       File(file.path),
              //                     );
              //                   } else {
              //                     Util.toast('You can add up to 5 photos');
              //                   }

              //                   return value;
              //                 },
              //               );
              //             }
              //           } catch (e) {
              //             Util.toast(e);
              //           }
              //         },
              //       ),
              //       PopupMenuItem(
              //         child: const Text('Gallery'),
              //         onTap: () async {
              //           try {
              //             var xfiles = await ImagePicker().pickMultiImage(
              //               maxWidth: 720,
              //               maxHeight: 720,
              //             );

              //             List<Uint8List> bytesFiles = List.empty(
              //               growable: true,
              //             );

              //             for (var element in xfiles) {
              //               Uint8List bytes = await element.readAsBytes();

              //               bytesFiles.add(bytes);
              //             }

              //             controller.map.update(
              //               'files',
              //               (value) {
              //                 var files = value as List<Uint8List>;

              //                 for (var element in bytesFiles) {
              //                   if (value.length < 5) {
              //                     (value).add(
              //                       element,
              //                     );
              //                   } else {
              //                     Util.toast('You can add up to 5 photos');

              //                     break;
              //                   }
              //                 }

              //                 return files;
              //               },
              //             );
              //           } catch (e) {
              //             Util.toast(e);
              //           }
              //         },
              //       ),
              //     ],
              //     icon: const Icon(
              //       Icons.add,
              //     ),
              //   ),
              // ),

// return Stack(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () async => await Get.to(
                        //         () => LocalFilePreviewWidget(
                        //           file: element,
                        //         ),
                        //       ),
                        //       child: ClipRRect(
                        //         borderRadius:
                        //             BorderRadius.circular(kDefaultRadius),
                        //         child: Image.memory(
                        //           element,
                        //           fit: BoxFit.cover,
                        //           height: 120,
                        //           width: 120,
                        //         ),
                        //       ),
                        //     ),
                        //     Positioned(
                        //       top: 8,
                        //       right: 8,
                        //       child: GestureDetector(
                        //         child: const CircleAvatar(
                        //           radius: 16,
                        //           backgroundColor: Colors.black45,
                        //           child: Icon(
                        //             Icons.clear,
                        //             size: 18,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //         onTap: () => controller.map.update(
                        //           'files',
                        //           (_) {
                        //             (_ as List<Uint8List>).remove(element);

                        //             return _;
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // );