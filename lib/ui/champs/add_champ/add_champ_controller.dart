import 'dart:typed_data';

import 'package:baustaka/api/champ_api.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:baustaka/helper/util.dart';

class AddChampController extends GetxController {
  var isSubmitting = false.obs;

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
}
