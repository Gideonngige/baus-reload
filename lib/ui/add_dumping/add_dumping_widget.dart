import 'dart:ui';

import 'package:baustaka/config/env.dart';
import 'package:flutter/foundation.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/dialog_widget.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart' as google_place;
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              try {
                Get.back();
              } catch (e) {
                // Handle any GetX navigation errors
                if (kDebugMode) {
                  print('Navigation error: $e');
                }
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
              MapWidget(
                key: Key('add_dumping_map'),
                fullscreen: true,
                scrollGesturesEnabled: true,
                onTap: (latLng) async {
                  // Update controller location when map is tapped
                  controller.latitude = latLng.latitude;
                  controller.longitude = latLng.longitude;
                  
                  // Update the map with new marker
                  if (controller.updateMap != null) {
                    controller.updateMap!(
                      latLng,
                      showCircles: false,
                      showMarkers: true,
                      withZoom: 15.0,
                    );
                  }
                  
                  // Reverse geocode to get address
                  try {
                    var googlePlace = google_place.GooglePlace(kGoogleApiKey);
                    var result = await googlePlace.search.getNearBySearch(
                      google_place.Location(lat: latLng.latitude, lng: latLng.longitude),
                      1000,
                    );

                    if (result != null && result.results != null && result.results!.isNotEmpty) {
                      final place = result.results!.first;
                      final address = place.name ?? place.vicinity ?? 'Selected location';
                      controller.area.value = address;
                    } else {
                      controller.area.value = 'Selected location (${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)})';
                    }
                  } catch (e) {
                    controller.area.value = 'Selected location (${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)})';
                  }
                },
                initialLatLng: const LatLng(-1.2921, 36.8219), // Nairobi default
                onMapCreated: (updateMapFunction) {
                  // Store the update function for later use
                  controller.updateMap = updateMapFunction;
                  
                  // Get current location on map creation
                  controller.updateCurrentLocation();
                },
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
                          color: Colors.black.withValues(alpha: 0.4),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    // Search Input Field
                                    TextField(
                                      controller: controller.searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search your location',
                                        prefixIcon: const Icon(Icons.search),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        controller.searchPlaces(value);
                                      },
                                    ),
                                    
                                    // Search Results Dropdown
                                    Obx(() => controller.searchResults.isNotEmpty
                                        ? Positioned(
                                            top: 50,
                                            left: 0,
                                            right: 0,
                                            child: Material(
                                              elevation: 8,
                                              borderRadius: BorderRadius.circular(8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxHeight: 200),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: controller.searchResults.length > 4 
                                                      ? 4 
                                                      : controller.searchResults.length,
                                                  itemBuilder: (context, index) {
                                                    final prediction = controller.searchResults[index];
                                                    return ListTile(
                                                      leading: const Icon(Icons.location_on, size: 20),
                                                      title: Text(
                                                        prediction.description ?? '',
                                                        style: const TextStyle(fontSize: 14),
                                                      ),
                                                      onTap: () async {
                                                        await controller.selectPlace(prediction);
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink()),
                                  ],
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
                  color: Colors.grey.withValues(alpha: 0.6),
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