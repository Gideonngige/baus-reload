import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:baustaka/config/palette.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:baustaka/config/palette.dart';
import '../widgets/message_pop.dart';

class TrackingScreen extends StatefulWidget {
  final Map<String, dynamic> order; // receives order from BuyerOrdersScreen
  const TrackingScreen({super.key, required this.order});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late GoogleMapController mapController;
  late LatLng _startPoint;
  late LatLng _destinationPoint;
  late LatLng _truckLocation;
  bool _isMarkingDelivered = false;

  @override
  void initState() {
    super.initState();
    final order = widget.order;

    _destinationPoint = LatLng(
      order["latitude"]?.toDouble() ?? -1.2921,
      order["longitude"]?.toDouble() ?? 36.8219,
    );

    final driver = order["driver"];
    if (driver != null &&
        driver["latitude"] != null &&
        driver["longitude"] != null) {
      _truckLocation = LatLng(
        driver["latitude"]?.toDouble() ?? -1.2921,
        driver["longitude"]?.toDouble() ?? 36.8219,
      );
    } else {
      _truckLocation = _destinationPoint;
    }

    _startPoint = const LatLng(-1.2921, 36.8219); // warehouse/source
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final driver = order["driver"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tracking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                // Truck Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Truck Number',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(driver?["truckNumber"] ?? "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 10),
                          const Text('Driver Name',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black54)),
                          const SizedBox(height: 4),
                          Text(driver?["name"] ?? "Not Assigned",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Status',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black54)),
                          Text(order["deliveryStatus"] ?? "Pending",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: _getStatusColor(
                                      order["deliveryStatus"]))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Driver Info
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Palette.primary,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(driver?["name"] ?? "Not Assigned",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                            const Text('Truck Driver',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 14)),
                          ],
                        ),
                      ),
                      if (driver != null)
                        Container(
                          decoration: const BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final phoneNumber = driver?["phone"];
                              if (phoneNumber != null && phoneNumber.isNotEmpty) {
                                final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
                                if (await canLaunchUrl(callUri)) {
                                  await launchUrl(callUri);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Could not launch phone call')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('No phone number available')),
                                );
                              }
                            },
                            icon: const Icon(Icons.phone, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Live Map
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _truckLocation,
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                            markerId: const MarkerId('start'),
                            position: _startPoint,
                            infoWindow:
                                const InfoWindow(title: 'Pickup Location'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed)),
                        Marker(
                            markerId: const MarkerId('destination'),
                            position: _destinationPoint,
                            infoWindow: InfoWindow(title: order["locationName"]),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueGreen)),
                        Marker(
                            markerId: const MarkerId('truck'),
                            position: _truckLocation,
                            infoWindow:
                                const InfoWindow(title: 'Driver Location'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueAzure)),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
