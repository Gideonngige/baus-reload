import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/api/cbo_api.dart';
import 'package:baustaka/helper/util.dart';

class AddCboController extends GetxController {
  var isSubmitting = false.obs;

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
}
