import 'package:baustaka/api/dumping_api.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/config/routes.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/socket/user.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as google_place;
import 'package:image_picker/image_picker.dart';

class AddDumpingController extends GetxController {
  var isAdding = false.obs;
  var isRequestingMyLocation = false.obs;

  final _dumpingApi = Get.put(DumpingApi());

  Rx<String?> message = Rx<String?>(null);
  Rx<String?> area = Rx(null);
  double? latitude;
  double? longitude;

  Rx<Uint8List?> bytes = Rx(null);

  final _imagePicker = ImagePicker();
  
  // Search functionality
  final searchController = TextEditingController();
  late google_place.GooglePlace _googlePlace;
  RxList<google_place.AutocompletePrediction> searchResults = <google_place.AutocompletePrediction>[].obs;

  final userSocket = Get.put(
    UserSocket(),
    permanent: true,
  );

  RxList<Picker> pickers = RxList.empty(growable: true);

  // Map update function
  Function(
    LatLng newPosition, {
    double? radius,
    double? withZoom,
    bool? showMarkers,
    bool? showCircles,
  })? updateMap;

  @override
  void onInit() async {
    // Initialize Google Places API
    _googlePlace = google_place.GooglePlace(kGoogleApiKey);
    
    ever(userSocket.picker, (value) {
      var picker = userSocket.picker.value;

      if (picker != null) {
        pickers.removeWhere((element) => element.id == picker.id);

        pickers.insert(0, picker);

        if (kDebugMode) {
          print('Picker ${pickers.length}');
        }
      }
    });

    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();

    await updateCurrentLocation();
  }

  pickFile(ImageSource source) async {
    try {
      bytes.value = await (await _imagePicker.pickImage(
        source: source,
        maxHeight: 720,
        maxWidth: 720,
      ))
          ?.readAsBytes();
    } catch (e) {
      Util.toast(e);
    }
  }

  add() async {
    if (isAdding.isTrue) return;

    isAdding.value = true;

    if (check()) {
      try {
        var formData = dio.FormData.fromMap({
          'message': message.trim(),
          'area': area.trim(),
          'latitude': latitude,
          'longitude': longitude,
        });

        formData.files.add(
          MapEntry(
            'file',
            dio.MultipartFile.fromBytes(
              bytes.value!,
              filename: 'file.jpg',
            ),
          ),
        );

        var dumping = (await _dumpingApi.create(formData)).data!.dumping;

        await Get.offAndToNamed('${Routes.kDumping}${dumping!.id}');
      } catch (e) {
        Util.toast(e);
      }
    }

    isAdding.value = false;
  }

  updateCurrentLocation() async {
    if (isRequestingMyLocation.isTrue) return;

    isRequestingMyLocation.value = true;

    try {
      var position = await Util.currentPosition();

      area.value = 'Current location';
      latitude = position.latitude;
      longitude = position.longitude;
      searchController.text = 'Current location';

      // Update map if available
      if (updateMap != null) {
        updateMap!(
          LatLng(position.latitude, position.longitude),
          showCircles: false,
          showMarkers: true,
          withZoom: 15.0,
        );
      }
    } catch (e) {
      Util.toast(e);
    }

    isRequestingMyLocation.value = false;
  }

  // Search places functionality
  searchPlaces(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      var result = await _googlePlace.autocomplete.get(
        query,
        components: [google_place.Component('country', 'ke')],
      );

      if (result != null && result.predictions != null) {
        searchResults.value = result.predictions!;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Search error: $e');
      }
    }
  }

  // Select a place from search results
  selectPlace(google_place.AutocompletePrediction prediction) async {
    try {
      searchResults.clear();
      searchController.text = prediction.description ?? '';
      
      var details = await _googlePlace.details.get(prediction.placeId!);

      if (details != null && details.result != null) {
        area.value = prediction.description;
        latitude = details.result!.geometry!.location!.lat;
        longitude = details.result!.geometry!.location!.lng;
        
        // Update the map to show the selected location
        if (updateMap != null) {
          updateMap!(
            LatLng(latitude!, longitude!),
            showCircles: false,
            showMarkers: true,
            withZoom: 15.0,
          );
        }
      }
    } catch (e) {
      Util.toast(e);
    }
  }

  bool check() {
    try {
      if (bytes.value == null) throw 'Add an image';

      if (area.value == null || area.value!.isEmpty) throw 'Select location';

      if (message.value == null || message.value!.isEmpty) {
        throw 'Type message';
      }

      return true;
    } catch (e) {
      Util.toast(e);

      return false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
