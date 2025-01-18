import 'package:baustaka/ui/_/responsive_widget.dart';
import 'package:baustaka/ui/map/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends ResponsiveWidget<MapController> {
  final List<Marker>? markers;
  final Position? position;
  final bool scrollGesturesEnabled;

  final Function(GoogleMapController) onMapCreated;

  MapWidget({
    super.key,
    this.markers,
    this.position,
    this.scrollGesturesEnabled = true,
    required this.onMapCreated,
  });

  @override
  String get tag => 'map-picker';

  @override
  MapController get controller => Get.put(
        MapController(),
        tag: tag,
        permanent: true,
      );

  @override
  Widget? desktop() {
    return GoogleMap(
      scrollGesturesEnabled: scrollGesturesEnabled,
      gestureRecognizers: scrollGesturesEnabled
          ? <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            }
          : <Factory<OneSequenceGestureRecognizer>>{},
      initialCameraPosition: CameraPosition(
        target: position != null
            ? LatLng(position!.latitude, position!.longitude)
            : markers != null && markers!.isNotEmpty
                ? markers?.first.position ?? const LatLng(-4.0435, 39.6682)
                : const LatLng(-4.0435, 39.6682),
        zoom: 12.8,
      ),
      onMapCreated: onMapCreated,
      markers: _markers(),
      myLocationButtonEnabled: true,
    );
  }

  _markers() {
    var m = <Marker>{};

    if (markers != null) m.addAll(markers!.toSet());

    if (position != null) {
      m.add(Marker(
        position: LatLng(position!.latitude, position!.longitude),
        markerId: const MarkerId('position'),
        infoWindow: const InfoWindow(
          title: 'My Current Location',
          snippet: 'This location changes as you move',
        ),
      ));
    }

    return m;
  }
}
