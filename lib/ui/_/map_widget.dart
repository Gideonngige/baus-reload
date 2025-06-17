import 'dart:async';

import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/theme.dart';
import 'package:baustaka/helper/util.dart';
import 'package:baustaka/ui/_/progress_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kInitialLatLng = LatLng(
  0,
  0,
);
const kZoomMax = 12.4;
const kZoomMin = 8.7;
const kZoomForMarker = 17.0;
const kCircleRadius = 5000.0;

class MapWidget extends StatefulWidget {
  final Function(
    Function(
      LatLng? newPosition, {
      double? radius,
      double? withZoom,
      bool? showMarkers,
      bool? showCircles,
    }) updateMap,
  )? onMapCreated;

  final double? aspectRatio, radius;
  final bool scrollGesturesEnabled, fullscreen;
  final LatLng? initialLatLng;
  final Function(LatLng latLng)? onTap;

  const MapWidget({
    super.key,
    this.onMapCreated,
    this.aspectRatio = 16 / 9,
    this.scrollGesturesEnabled = false,
    this.initialLatLng,
    this.onTap,
    this.fullscreen = false,
    this.radius = kDefaultRadius,
  });
  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  GoogleMapController? googleMapController;

  final Set<Marker> markers = {};

  final Set<Circle> circles = {};

  var zoom = kZoomMax;

  LatLng? newPosition;

  updateMap(
    LatLng? newPosition, {
    double? withZoom,
    double? radius,
    bool? showMarkers = true,
    bool? showCircles = true,
  }) async {
    this.newPosition = newPosition;

    zoom = withZoom ??
        kZoomMin +
            (kZoomMax - kZoomMin) * (kCircleRadius / (radius ?? kCircleRadius));

    if (newPosition != null) {
      await googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: zoom,
          ),
        ),
      );
    }

    await Future.delayed(const Duration(
      milliseconds: 300,
    ));

    setState(() {
      markers.clear();

      if (showMarkers == true && newPosition != null) {
        markers.add(
          Marker(
            markerId: const MarkerId('anyUniqueId'),
            position: newPosition,
          ),
        );
      }

      circles.clear();

      if (showCircles == true && newPosition != null) {
        circles.add(
          Circle(
            center: newPosition,
            circleId: const CircleId('anyUniqueId'),
            radius: radius ?? kCircleRadius,
            fillColor: Palette.primary.withValues(alpha: 0.2),
            strokeWidth: 0,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    googleMapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fullscreen) {
      // For fullscreen mode, remove any decorations that might cause layout issues
      return _buildMap();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(widget.radius ?? kDefaultRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius ?? kDefaultRadius),
        child: widget.aspectRatio != null
            ? AspectRatio(
                aspectRatio: widget.aspectRatio!,
                child: _buildMap(),
              )
            : _buildMap(),
      ),
    );
  }

  _buildMap() => FutureBuilder(
        future: Future.delayed(
          const Duration(
            milliseconds: 300,
          ),
          () => 300,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Visibility(
              visible: true,
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: widget.initialLatLng ?? kInitialLatLng,
                      zoom: zoom,
                    ),
                    onMapCreated: (controller) {
                      googleMapController = controller;

                      if (widget.onMapCreated != null) {
                        widget.onMapCreated!(updateMap);
                      }
                    },
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    markers: markers,
                    circles: circles,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: widget.scrollGesturesEnabled,
                    rotateGesturesEnabled: widget.scrollGesturesEnabled,
                    zoomGesturesEnabled: widget.scrollGesturesEnabled,
                    tiltGesturesEnabled: widget.scrollGesturesEnabled,
                    gestureRecognizers: widget.scrollGesturesEnabled
                        ? <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          }
                        : <Factory<OneSequenceGestureRecognizer>>{},
                    onTap: widget.onTap,
                  ),
                  if (widget.fullscreen != true)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () async => await Get.to(
                          () => FullMapWidget(
                            initialLatLng: newPosition ?? widget.initialLatLng,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(
                                widget.radius ?? kDefaultRadius),
                          ),
                          child: const Icon(
                            Icons.minimize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(
            child: ProgressWidget(
              color: Palette.primary,
            ),
          );
        },
      );
}

class FullMapWidget extends StatelessWidget {
  final LatLng? initialLatLng;

  const FullMapWidget({
    super.key,
    required this.initialLatLng,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: MapWidget(
          key: Key(initialLatLng.toString()),
          fullscreen: true,
          onTap: (latLng) async => await Util.directions(
            [latLng.longitude, latLng.latitude],
          ),
          initialLatLng: initialLatLng,
          onMapCreated: (updateMap) async {
            if (initialLatLng != null) {
              updateMap(
                initialLatLng!,
                showCircles: true,
                showMarkers: true,
                radius: kDefaultRadius,
                withZoom: kZoomForMarker,
              );
            }
          },
          scrollGesturesEnabled: true,
        ),
      );
}
