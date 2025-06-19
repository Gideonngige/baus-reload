import 'dart:typed_data';

import 'package:baustaka/api/champ_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/ui/_/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/helper/util.dart';

class AddChampController extends GetxController {
  var isSubmitting = false.obs;
  var isSearching = false.obs;
  var isGettingLocation = false.obs;
  var searchPredictions = <AutocompletePrediction>[].obs;

  // Search controller for location input
  final searchController = TextEditingController();

  // Google Places API
  late GooglePlace googlePlace;

  RxMap map = RxMap({
    'description': null,
    'area': null,
    'lngLat': null,
    'files': List<Uint8List>.empty(
      growable: true,
    ),
  });

  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  final _champApi = Get.put(ChampApi());

  @override
  void onInit() {
    super.onInit();
    googlePlace = GooglePlace(kGoogleApiKey);
    
    // Listen to search text changes
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        searchPlaces(searchController.text);
      } else {
        searchPredictions.clear();
      }
    });
    
    // Automatically get current location when screen is launched
    _autoGetCurrentLocation();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Search for places using Google Places API
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      searchPredictions.clear();
      return;
    }

    try {
      isSearching.value = true;
      
      final result = await googlePlace.autocomplete.get(
        query,
        components: [Component('country', 'ke')],
      );

      if (result != null && result.predictions != null) {
        searchPredictions.value = result.predictions!;
      } else {
        searchPredictions.clear();
      }
    } catch (e) {
      Util.toast('Error searching places: $e');
      searchPredictions.clear();
    } finally {
      isSearching.value = false;
    }
  }

  // Select a place from predictions
  Future<void> selectPlace(AutocompletePrediction prediction) async {
    try {
      final details = await googlePlace.details.get(prediction.placeId!);
      
      if (details != null && details.result != null) {
        final location = details.result!.geometry!.location!;
        
        map['area'] = prediction.description ?? '';
        map['lngLat'] = [location.lng!, location.lat!];
        
        searchController.text = prediction.description ?? '';
        searchPredictions.clear();
        
        // Update map position
        if (updateMap != null) {
          updateMap!(
            LatLng(location.lat!, location.lng!),
            showCircles: false,
            withZoom: kZoomForMarker,
          );
        }
      }
    } catch (e) {
      Util.toast('Error selecting place: $e');
    }
  }

  // Handle map tap to place pin
  Future<void> onMapTap(LatLng position) async {
    try {
      // Update location immediately
      map['lngLat'] = [position.longitude, position.latitude];
      
      // Update map position
      if (updateMap != null) {
        updateMap!(
          position,
          showCircles: false,
          withZoom: kZoomForMarker,
        );
      }

      // Get address from coordinates using reverse geocoding
      final result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        1000, // radius in meters
      );

      if (result != null && result.results != null && result.results!.isNotEmpty) {
        final place = result.results!.first;
        map['area'] = place.name ?? 'Selected Location';
        searchController.text = place.name ?? 'Selected Location';
      } else {
        map['area'] = 'Selected Location';
        searchController.text = 'Selected Location';
      }
    } catch (e) {
      // Fallback if reverse geocoding fails
      map['area'] = 'Selected Location';
      searchController.text = 'Selected Location';
      Util.toast('Location selected');
    }
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      isGettingLocation.value = true;
      
      final position = await Util.currentPosition();
      
      map['lngLat'] = [position.longitude, position.latitude];
      
      // Update map position
      if (updateMap != null) {
        updateMap!(
          LatLng(position.latitude, position.longitude),
          showCircles: false,
          withZoom: kZoomForMarker,
        );
      }

      // Get address from coordinates
      final result = await googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        1000,
      );

      if (result != null && result.results != null && result.results!.isNotEmpty) {
        final place = result.results!.first;
        map['area'] = place.name ?? 'Current Location';
        searchController.text = place.name ?? 'Current Location';
      } else {
        map['area'] = 'Current Location';
        searchController.text = 'Current Location';
      }
    } catch (e) {
      Util.toast('Error getting current location: $e');
    } finally {
      isGettingLocation.value = false;
    }
  }

  // Clear search and reset to initial state
  void clearSearch() {
    searchController.clear();
    searchPredictions.clear();
  }

  submit() async {
    if (isSubmitting.isTrue) return;

    isSubmitting.value = true;

    try {
      if (map['description'] == null ||
          (map['description'] as String).isEmpty) {
        throw 'Tell us why';
      }

      if (map['lngLat'] == null) throw 'Select address';

      var data = Map<String, dynamic>.from(map);

      var champ = (await _champApi.create(data)).data?.champ;

      if (champ != null) {
        Get.back(
          result: true,
        );

        throw 'You applied successfully';
      }

      throw 'Something went wrong. Try again';
    } catch (e) {
      Util.toast(e);
    }

    isSubmitting.value = false;
  }

  // Automatically get current location on screen launch
  Future<void> _autoGetCurrentLocation() async {
    try {
      // Small delay to ensure UI is ready
      await Future.delayed(const Duration(milliseconds: 500));
      await getCurrentLocation();
    } catch (e) {
      // If auto location fails, just continue without showing error
      // User can still manually search or use current location button
      // Silent fail - no action needed
    }
  }
}
