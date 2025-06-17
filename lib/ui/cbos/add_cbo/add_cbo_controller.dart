import 'dart:typed_data';

import 'package:baustaka/config/env.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/api/cbo_api.dart';
import 'package:baustaka/helper/util.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/material.dart';


class AddCboController extends GetxController {
  var isSubmitting = false.obs;
  var isSearching = false.obs;
  var isRequestingMyLocation = false.obs;

  RxMap map = RxMap({
    'title': null,
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

  final _cboApi = Get.put(CboApi());
  final _googlePlace = GooglePlace(kGoogleApiKey);
  
  // Search functionality
  final TextEditingController searchController = TextEditingController();
  RxList<AutocompletePrediction> searchSuggestions = RxList.empty(growable: true);

  submit() async {
    if (isSubmitting.isTrue) return;

    isSubmitting.value = true;

    try {
      if (map['title'] == null || (map['title'] as String).isEmpty) {
        throw 'What is the title or name?';
      }

      if (map['description'] == null ||
          (map['description'] as String).isEmpty) {
        throw 'Tell us more about it';
      }

      if (map['lngLat'] == null) throw 'Select address';

      var data = Map<String, dynamic>.from(map);

      var cbo = (await _cboApi.create(data)).data?.cbo;

      if (cbo != null) {
        Get.back(
          result: true,
        );

        throw 'You added CBO successfully';
      }

      throw 'Something went wrong. Try again';
    } catch (e) {
      Util.toast(e);
    }

    isSubmitting.value = false;
  }

  // Enhanced location search functionality
  void searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      searchSuggestions.clear();
      return;
    }

    if (isSearching.value) return;

    isSearching.value = true;

    try {
      var result = await _googlePlace.autocomplete.get(
        query,
        components: [Component('country', 'ke')],
      );

      if (result != null && result.predictions != null) {
        searchSuggestions.assignAll(result.predictions!);
      }
    } catch (e) {
      Util.toast('Search failed: ${e.toString()}');
    } finally {
      isSearching.value = false;
    }
  }

  void selectPlace(AutocompletePrediction prediction) async {
    try {
      searchController.text = prediction.description ?? '';
      searchSuggestions.clear();

      var details = await _googlePlace.details.get(prediction.placeId!);

      if (details != null && details.result != null) {
        map.update('area', (value) => prediction.description);
        map.update('lngLat', (value) => [
          details.result!.geometry!.location!.lng,
          details.result!.geometry!.location!.lat,
        ]);

        goToPosition();
      }
    } catch (e) {
      Util.toast('Failed to get place details: ${e.toString()}');
    }
  }

  void updateLocationFromMap(LatLng position) async {
    try {
      // Update the location data
      map.update('lngLat', (value) => [
        position.longitude,
        position.latitude,
      ]);

      // Update the map pin
      goToPosition();

      // Get the address for this location using reverse geocoding
      await _reverseGeocode(position);
    } catch (e) {
      Util.toast('Failed to update location: ${e.toString()}');
    }
  }

  Future<void> _reverseGeocode(LatLng position) async {
    try {
      // Use Google Places API for reverse geocoding
      final result = await _googlePlace.search.getNearBySearch(
        Location(lat: position.latitude, lng: position.longitude),
        1000, // radius in meters
      );

      if (result != null && result.results != null && result.results!.isNotEmpty) {
        final place = result.results!.first;
        final address = place.name ?? place.vicinity ?? 'Selected location';
        
        map.update('area', (value) => address);
        searchController.text = address;
      } else {
        // Fallback to coordinates
        final coords = 'Selected location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
        map.update('area', (value) => coords);
        searchController.text = coords;
      }
    } catch (e) {
      // Fallback to coordinates if reverse geocoding fails
      final coords = 'Selected location (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
      map.update('area', (value) => coords);
      searchController.text = coords;
    }
  }

  Future<void> updateCurrentLocation() async {
    if (isRequestingMyLocation.isTrue) return;

    isRequestingMyLocation.value = true;

    try {
      var position = await Util.currentPosition();

      map.update('area', (value) => 'Current location');
      map.update('lngLat', (value) => [
        position.longitude,
        position.latitude,
      ]);

      goToPosition();
    } catch (e) {
      Util.toast(e);
    }

    isRequestingMyLocation.value = false;
  }

  void goToPosition() async {
    var newPosition = LatLng(
      (map['lngLat'] as List<double>?)?[1] ?? -1.2921,  // Default to Nairobi coordinates
      (map['lngLat'] as List<double>?)?[0] ?? 36.8219,
    );

    if (updateMap != null) {
      updateMap!(
        newPosition,
        showCircles: false,
        withZoom: 15.0,  // Default zoom level for marker
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
