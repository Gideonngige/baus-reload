import 'package:baustaka/config/client.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/_/title_text.dart';
import 'package:baustaka/ui/booking/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookingDetailsWidget extends ResponsiveWidget {
  final String withProduct;
  final String type;
  final BookingController controller;
  final PanelController _panelController = PanelController();
  final ScrollController _scrollController = ScrollController();

  BookingDetailsWidget({
    super.key,
    required this.withProduct,
    required this.type,
    required this.controller,
  });

  @override
  String get tag => 'booking $type $withProduct';

  @override
  Widget? desktop() => Scaffold(
    body: Stack(
      children: [
        // Full-screen map background
        Positioned.fill(
          child: MapWidget(
            onTap: (LatLng position) {
              controller.updateLocationFromMap(position);
            },
            onMapCreated: (updateMapFn) {
              controller.updateMap = updateMapFn;
              controller.updateLocation();
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
                      Expanded(
                        child: Text(
                          'Dispose waste',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
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
                            onChanged: (value) {
                              controller.searchPlaces(value);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // My Location Button
                      Container(
                        decoration: BoxDecoration(
                          color: controller.color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: controller.color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () async {
                            await controller.updateCurrentLocation();
                            controller.updateLocation();
                          },
                          icon: Obx(
                            () => controller.isRequestingMyLocation.isTrue
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
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Search Suggestions
                  Obx(() {
                    if (controller.searchSuggestions.isNotEmpty) {
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
        ),
        
        // Floating location indicator
        Positioned(
          bottom: 200,
          left: 16,
          right: 16,
          child: Obx(() {
            if (controller.data.value['area'] != null) {
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
                            controller.data.value['area'],
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
        
        // Compact bottom panel
        Builder(
          builder: (context) => SlidingUpPanel(
            controller: _panelController,
            minHeight: 140,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            panel: PanelWidget(
              scrollController: _scrollController,
              controller: controller,
              withProduct: withProduct,
              type: type,
            ),
            body: const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );
}

// ignore: must_be_immutable
class PanelWidget extends StatelessWidget {
  final String withProduct;
  final String type;
  final BookingController controller;
  final ScrollController scrollController;

  PanelWidget({
    super.key,
    required this.scrollController,
    required this.controller,
    required this.withProduct,
    required this.type,
  });

  RxString selectedRadioTile = 'residential'.obs;

  setSelectedRadioTile(val) {
    selectedRadioTile.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Compact header with drag handle
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
                  // Property type selection header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.home_outlined, 
                             color: Colors.grey.shade600, 
                             size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Property Type',
                          style: TextStyle(
                            fontSize: 16,
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
            
            // Property type selection
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // Property types
                  Obx(() => Column(
                    children: kClients.map((clientType) {
                      final isSelected = selectedRadioTile.value == clientType;
                      
                      // Create client data based on type
                      IconData getIcon(String type) {
                        switch (type) {
                          case 'residential':
                            return Icons.home;
                          case 'commercial':
                            return Icons.business;
                          case 'corporate':
                            return Icons.domain;
                          default:
                            return Icons.home_outlined;
                        }
                      }
                      
                      String getTitle(String type) {
                        switch (type) {
                          case 'residential':
                            return 'Residential';
                          case 'commercial':
                            return 'Commercial';
                          case 'corporate':
                            return 'Corporate';
                          default:
                            return type.toString().split(' ').map((word) => 
                              '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
                        }
                      }
                      
                      String? getSubtitle(String type) {
                        switch (type) {
                          case 'residential':
                            return 'Homes and apartments';
                          case 'commercial':
                            return 'Offices and retail spaces';
                          case 'corporate':
                            return 'Large organizations';
                          default:
                            return null;
                        }
                      }
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? controller.color.withValues(alpha: 0.08) 
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? controller.color.withValues(alpha: 0.3)
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? controller.color.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              getIcon(clientType),
                              color: isSelected 
                                  ? controller.color 
                                  : Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            getTitle(clientType),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: isSelected 
                                  ? controller.color 
                                  : Colors.grey.shade800,
                            ),
                          ),
                          subtitle: getSubtitle(clientType) != null
                              ? Text(
                                  getSubtitle(clientType)!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              : null,
                          trailing: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                    ? controller.color 
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              color: isSelected 
                                  ? controller.color 
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          onTap: () {
                            setSelectedRadioTile(clientType);
                            controller.data.update((val) {
                              val!['client'] = clientType;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  )),
                  
                  const SizedBox(height: 20),
                  
                  // Next button
                  Container(
                    width: double.infinity,
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (selectedRadioTile.value.isNotEmpty) {
                          controller.data.update((val) {
                            val!['client'] = selectedRadioTile.value;
                          });
                          // Navigate to next step or perform action
                          controller.price();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Obx(() => controller.isPricing.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Next step',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}