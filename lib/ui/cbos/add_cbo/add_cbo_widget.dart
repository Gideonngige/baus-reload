// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/cbos/add_cbo/add_cbo_controller.dart';
import 'package:baustaka/ui/file/local_file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';

class AddCboWidget extends ResponsiveWidget<AddCboController> {
  AddCboWidget({
    super.key,
  });

  @override
  bool get shouldAdjust => true;

  @override
  String get tag => Util.tag();

  @override
  AddCboController get controller => Get.put(
        AddCboController(),
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
          title: const Text('Register a CBO'),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                'What is the name or title of the CBO?',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: TextField(
                decoration: kInputDecoration.copyWith(
                  hintText: 'CBO...',
                ),
                onChanged: (value) => controller.map['title'] = value,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                maxLength: 80,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                'Tell us more about it',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: TextField(
                decoration: kInputDecoration.copyWith(
                  hintText: 'Description...',
                ),
                onChanged: (value) => controller.map['description'] = value,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                maxLength: 280,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              title: const Text(
                'Where is the CBO located?',
              ),
              subtitle: Obx(
                () => Text(
                  controller.map['area'] ?? 'Select address',
                ),
              ),
              trailing: PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                ),
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: const Text('My current location'),
                    onTap: () async {
                      try {
                        var position = await Util.currentPosition();

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
                            var prediction = await PlacesAutocomplete.show(
                              context: screen.context,
                              apiKey: kGoogleApiKey,
                              mode: Mode.fullscreen,
                              strictbounds: false,
                              components: [],
                              types: [],
                              overlayBorderRadius:
                                  BorderRadius.circular(kDefaultRadius),
                            );

                            if (prediction != null &&
                                prediction.placeId != null) {
                              final place = await GoogleMapsPlaces(
                                apiKey: kGoogleApiKey,
                                apiHeaders:
                                    await const GoogleApiHeaders().getHeaders(),
                              ).getDetailsByPlaceId(prediction.placeId!);

                              if (!place.hasNoResults) {
                                controller.map['area'] = prediction.description;

                                controller.map.update(
                                    'lngLat',
                                    (value) => [
                                          place.result.geometry!.location.lng,
                                          place.result.geometry!.location.lat
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
                icon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: MapWidget(
                onMapCreated: (updateMap) async {
                  controller.updateMap = updateMap;

                  _goToPosition();
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              title: const Text('Add up to 5 photos'),
              subtitle: Obx(() =>
                  Text('${(controller.map['files'] as List).length} photos')),
              trailing: PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultRadius),
                ),
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
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
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

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () async => await Get.to(
                              () => LocalFilePreviewWidget(
                                file: element,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(kDefaultRadius),
                              child: Image.memory(
                                element,
                                fit: BoxFit.cover,
                                height: 120,
                                width: 120,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black45,
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () => controller.map.update(
                                'files',
                                (e) {
                                  (e as List<Uint8List>).remove(element);

                                  return e;
                                },
                              ),
                            ),
                          ),
                        ],
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ElevatedButtonWidget(
                onPressed: () async {
                  await controller.submit();
                },
                child: Obx(
                  () => controller.isSubmitting.isTrue
                      ? const ProgressWidget()
                      : const Text('Submit'),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      );
}
