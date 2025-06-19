// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/champs/add_champ/add_champ_controller.dart';
import 'package:baustaka/ui/file/local_file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  final PanelController _panelController = PanelController();
  final ScrollController _scrollController = ScrollController();

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
    body: Stack(
      children: [
        // Full-screen map background
        Positioned.fill(
          child: MapWidget(
            onTap: (LatLng position) {
              controller.onMapTap(position);
            },
            onMapCreated: (updateMapFn) {
              controller.updateMap = updateMapFn;
              _goToPosition();
            },
            scrollGesturesEnabled: true,
            fullscreen: true,
          ),
        ),
        
        // Top search bar with gradient background
        Builder(
          builder: (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with back button and title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Become an eco-champion',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search input with location button
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for a location...',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                              suffixIcon: Obx(() {
                                if (controller.isSearching.value) {
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    child: const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // My Location Button
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: controller.getCurrentLocation,
                          icon: Obx(() => controller.isGettingLocation.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(
                                  Icons.my_location,
                                  color: Colors.white,
                                  size: 22,
                                )),
                        ),
                      ),
                    ],
                  ),
                  
                  // Search Suggestions
                  Obx(() {
                    if (controller.searchPredictions.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        constraints: const BoxConstraints(maxHeight: 160),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: controller.searchPredictions.length > 3 
                              ? 3 
                              : controller.searchPredictions.length,
                          itemBuilder: (context, index) {
                            final prediction = controller.searchPredictions[index];
                            return ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: Icon(Icons.location_on, color: Colors.grey.shade400, size: 18),
                              title: Text(
                                prediction.description ?? '',
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                controller.selectPlace(prediction);
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ),
        
        // Floating location indicator
        Positioned(
          bottom: 200,
          left: 16,
          right: 16,
          child: Obx(() {
            if (controller.map['area'] != null) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.location_on, 
                        color: Colors.green.shade600, 
                        size: 16
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selected Location',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            controller.map['area'],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ),
        
        // Bottom panel with form content
        Builder(
          builder: (context) => SlidingUpPanel(
            controller: _panelController,
            minHeight: 140,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            panel: _buildPanelContent(),
            body: const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );

  Widget _buildPanelContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tell us why',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(10),
                  TextField(
                    onChanged: (value) => controller.map['description'] = value,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Tell us about your eco work and why you want to become a champion...',
                      hintStyle: TextStyle(color: kAppTheme.hintColor),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: kAppTheme.hintColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
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
                    'Add up to 5 photos of your eco work',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(10),
                  
                  // Photo upload button
                  PopupMenuButton(
                    itemBuilder: (context) => <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.camera_alt, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Camera'),
                          ],
                        ),
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
                                    (value).add(File(file.path));
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
                        child: const Row(
                          children: [
                            Icon(Icons.photo_library, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Gallery'),
                          ],
                        ),
                        onTap: () async {
                          try {
                            var xfiles = await ImagePicker().pickMultiImage(
                              maxWidth: 720,
                              maxHeight: 720,
                            );

                            if (xfiles.isNotEmpty) {
                              controller.map.update(
                                'files',
                                (value) {
                                  for (var xfile in xfiles) {
                                    if ((value as List).length < 5) {
                                      (value).add(File(xfile.path));
                                    } else {
                                      Util.toast('You can add up to 5 photos');
                                      break;
                                    }
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
                    ],
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 15.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: kAppTheme.hintColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey,
                          ),
                          const Gap(10),
                          Text(
                            'Add photos',
                            style: TextStyle(color: kAppTheme.hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                  
                  // Photos preview
                  Obx(() {
                    if ((controller.map['files'] as List).isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selected Photos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(
                              (controller.map['files'] as List).length,
                              (index) => GestureDetector(
                                onTap: () async => await Get.to(
                                  () => LocalFilePreviewWidget(
                                    file: (controller.map['files'] as List)[index],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        image: DecorationImage(
                                          image: MemoryImage(
                                            (controller.map['files'] as List)[index] is File
                                                ? File((controller.map['files'] as List)[index].path).readAsBytesSync()
                                                : (controller.map['files'] as List)[index] as Uint8List,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () => controller.map.update(
                                          'files',
                                          (value) {
                                            (value as List).removeAt(index);
                                            return value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Gap(20),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  
                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButtonWidget(
                        onPressed: controller.isSubmitting.isTrue 
                            ? null 
                            : () async => await controller.submit(),
                        child: controller.isSubmitting.isTrue
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text('Submit Application'),
                      ),
                    ),
                  ),
                  const Gap(40), // Extra space at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}