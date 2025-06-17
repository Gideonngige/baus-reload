// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/elevated_button_widget.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/cbos/add_cbo/add_cbo_controller.dart';
import 'package:baustaka/ui/file/local_file_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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

  final PanelController _panelController = PanelController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget? tablet() => Scaffold(
        appBar: AppBar(
          title: const Text('Register a CBO'),
          backgroundColor: kAppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Builder(
          builder: (context) => Stack(
          children: [
              // Full-screen map background
              Positioned.fill(
                child: SizedBox.expand(
                  child: MapWidget(
                    fullscreen: true,
                    scrollGesturesEnabled: true,
                    initialLatLng: const LatLng(-1.2921, 36.8219), // Nairobi default
                    onMapCreated: (updateMap) async {
                      controller.updateMap = updateMap;
                      controller.goToPosition();
                    },
                    onTap: (LatLng position) {
                      controller.updateLocationFromMap(position);
                    },
                  ),
                ),
              ),
            
            // Floating search bar
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.95),
                      Colors.white.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              decoration: InputDecoration(
                                hintText: 'Search CBO location...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                              ),
                              onChanged: (value) {
                                controller.searchPlaces(value);
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.updateCurrentLocation(),
                            icon: Obx(
                              () => controller.isRequestingMyLocation.isTrue
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: kAppTheme.primaryColor,
                                      ),
                                    )
                                  : Icon(
                                      Icons.my_location_outlined,
                                      color: kAppTheme.primaryColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Search suggestions
                    Obx(() {
                      if (controller.searchSuggestions.isNotEmpty) {
                        return Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: controller.searchSuggestions.length > 3 
                                ? 3 
                                : controller.searchSuggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = controller.searchSuggestions[index];
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                leading: Icon(Icons.location_on, color: Colors.grey.shade400, size: 18),
                                title: Text(
                                  suggestion.description ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  controller.selectPlace(suggestion);
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
            
            // Floating location indicator
            Positioned(
              bottom: 300,
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
                                'CBO Location',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                controller.map['area'] ?? 'Select location',
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
            
              // Sliding up panel for CBO details
              SlidingUpPanel(
                controller: _panelController,
                minHeight: MediaQuery.of(context).size.height * 0.35,
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                parallaxEnabled: true,
                parallaxOffset: 0.5,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                panel: _buildCboDetailsPanel(),
                body: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );

  @override
  Widget? phone() => tablet(); // Use same layout for phone

  Widget _buildCboDetailsPanel() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Panel header with drag handle
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.business_outlined, 
                             color: kAppTheme.primaryColor, 
                             size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'CBO Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Main title section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register Your CBO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kAppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Help us learn more about your Community Based Organization',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // CBO Name
                  const Text(
                    'What is the name or title of the CBO?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: 'CBO name...',
                    ),
                    onChanged: (value) => controller.map['title'] = value,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    maxLength: 80,
                  ),
                  const SizedBox(height: 16),
                  
                  // CBO Description
                  const Text(
                    'Tell us more about it',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: kInputDecoration.copyWith(
                      hintText: 'Description...',
                    ),
                    onChanged: (value) => controller.map['description'] = value,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    maxLength: 280,
                  ),
                  const SizedBox(height: 16),
                  
                  // Photo section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add up to 5 photos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(() => Text(
                            '${(controller.map['files'] as List).length} photos added',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          )),
                        ],
                      ),
                      PopupMenuButton(
                shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.camera_alt, size: 20),
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
                            child: Row(
                              children: [
                                Icon(Icons.photo_library, size: 20),
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
                                        (value).add(element);
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: kAppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_photo_alternate, 
                                   color: kAppTheme.primaryColor, 
                                   size: 20),
                              const SizedBox(width: 4),
                              Text(
                                'Add Photos',
                                style: TextStyle(
                                  color: kAppTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                ),
              ),
            ),
                    ],
            ),
                  const SizedBox(height: 12),
                  
                  // Photo preview
            Obx(
              () => Visibility(
                      visible: (controller.map['files'] as List<Uint8List>).isNotEmpty,
                child: SizedBox(
                        height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (controller.map['files'] as List).length,
                    itemBuilder: (context, index) {
                            var element = (controller.map['files'] as List<Uint8List>)[index];
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () async => await Get.to(
                                    () => LocalFilePreviewWidget(file: element),
                            ),
                            child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                element,
                                fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                              ),
                            ),
                          ),
                          Positioned(
                                  top: 4,
                                  right: 4,
                            child: GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
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
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                    ),
                  ),
                ),
              ),
                  const SizedBox(height: 24),
                  
                  // Submit button
                  ElevatedButtonWidget(
                onPressed: () async {
                  await controller.submit();
                },
                child: Obx(
                  () => controller.isSubmitting.isTrue
                      ? const ProgressWidget()
                          : const Text('Register CBO'),
                    ),
                ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
        ),
      );
  }
}