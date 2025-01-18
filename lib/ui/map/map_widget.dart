import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/map/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends ResponsiveWidget<MapController> {
  final List<Marker>? markers;
  final bool scrollGesturesEnabled;

  MapWidget({
    super.key,
    this.markers,
    this.scrollGesturesEnabled = true,
  });

  @override
  String get tag => 'map';

  @override
  MapController get controller => Get.put(
        MapController(),
        tag: tag,
        permanent: true,
      );

  @override
  init() {
    controller.fetch();
  }

  @override
  Widget? desktop() => GoogleMap(
        scrollGesturesEnabled: scrollGesturesEnabled,
        gestureRecognizers: scrollGesturesEnabled
            ? <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              }
            : <Factory<OneSequenceGestureRecognizer>>{},
        initialCameraPosition: CameraPosition(
          target: markers != null && markers!.isNotEmpty
              ? markers?.first.position ?? const LatLng(-4.0435, 39.6682)
              : const LatLng(-4.0435, 39.6682),
          zoom: 12.8,
        ),
        onMapCreated: (mapController) async {},
        markers: markers?.toSet() ?? const <Marker>{},
        myLocationButtonEnabled: false,
      );
}
