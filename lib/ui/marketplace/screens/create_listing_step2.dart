import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baustaka/config/palette.dart';
import 'all_listings_screen.dart';
import 'package:get/get.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './marketplace_home_screen.dart';

class CreateListingStep2 extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final File? imageFile;

  const CreateListingStep2({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    this.imageFile,
  });

  @override
  State<CreateListingStep2> createState() => _CreateListingStep2State();
}

class _CreateListingStep2State extends State<CreateListingStep2> {
  final _priceController = TextEditingController();
  final _weightController = TextEditingController();

  bool isLoading = false;
  bool locationLoading = false;

  String selectedLocationName = "Detecting location...";
  double? selectedLatitude;
  double? selectedLongitude;
  final List<String> allowedLocations = [
  'Nairobi',
  'Mombasa',
  'Kwale',
  'Kilifi',
];


  // get cached location
  Future<Map<String, dynamic>> getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final double? latitude = prefs.getDouble('latitude');
    final double? longitude = prefs.getDouble('longitude');
    final String? locationName = prefs.getString('locationName');

    if (latitude != null && longitude != null && locationName != null) {
      return {
        'latitude': latitude,
        'longitude': longitude,
        'locationName': locationName,
      };
    } else {
      throw Exception("no_cached_location".tr);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final loc = await getCachedLocation();
      setState(() {
        selectedLatitude = loc['latitude'];
        selectedLongitude = loc['longitude'];
        selectedLocationName = loc['locationName'];
      });
    } catch (_) {
      setState(() => selectedLocationName = "Location not set");
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => locationLoading = true);

    try {
      final cached = await getCachedLocation();
      setState(() {
        selectedLatitude = cached['latitude'];
        selectedLongitude = cached['longitude'];
        selectedLocationName = cached['locationName'];
      });
      Util.toast("current_location_selected".tr);
    } catch (e) {
      Util.toast("no_gps_location_saved_yet".tr);
    }

    setState(() => locationLoading = false);
  }

  // void _changeLocationDialog() {
  //   final controller = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: const Text("Change Location"),
  //       content: TextField(
  //         controller: controller,
  //         decoration: const InputDecoration(
  //           hintText: "Enter town or area name",
  //         ),
  //       ),
  //       actions: [
  //         TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
  //         ElevatedButton(
  //           onPressed: () async {
  //             final name = controller.text.trim();
  //             if (name.isEmpty) return;

  //             final prefs = await SharedPreferences.getInstance();
  //             await prefs.setString('locationName', name);

  //             setState(() {
  //               selectedLocationName = name;
  //               selectedLatitude ??= 0.0;
  //               selectedLongitude ??= 0.0;
  //             });

  //             Get.back();
  //           },
  //           child: const Text("Save"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _changeLocationDialog() {
  String tempLocation = allowedLocations.first;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("choose_location".tr),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return DropdownButtonFormField<String>(
            value: tempLocation,
            items: allowedLocations.map((loc) {
              return DropdownMenuItem(
                value: loc,
                child: Text(loc),
              );
            }).toList(),
            onChanged: (value) {
              setDialogState(() {
                tempLocation = value!;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("cancel".tr),
        ),
        ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('locationName', tempLocation);

            setState(() {
              selectedLocationName = tempLocation;
              selectedLatitude ??= 0.0;
              selectedLongitude ??= 0.0;
            });

            Get.back();
          },
          child: Text("save".tr),
        ),
      ],
    ),
  );
}


  Future<void> _submitListing() async {
    final price = _priceController.text.trim();
    final double? weight = double.tryParse(_weightController.text.trim());
    if (!allowedLocations.contains(selectedLocationName)) {
        Util.toast("invalid_location_selected".tr);
        return;
    }


    if (price.isEmpty || weight == null) {
      Util.toast("enter_valid_price_and_weight".tr);
      return;
    }

    final formattedWeight = weight.toStringAsFixed(2);

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final token = await firebaseUser!.getIdToken(true);
    final storedUser = prefs.getString('user');

    if (token == null || storedUser == null) {
      Util.toast("login_expired".tr);
      return;
    }

    final user = jsonDecode(storedUser);
    final sellerId = user['_id'];
    final url = Uri.parse('${kBaseApiUrl}v1/listings/');

    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['title'] = widget.title;
      request.fields['description'] = widget.description;
      request.fields['category'] = widget.category;
      request.fields['price'] = price;
      request.fields['weight'] = formattedWeight;
      request.fields['locationName'] = selectedLocationName;
      request.fields['latitude'] = selectedLatitude.toString();
      request.fields['longitude'] = selectedLongitude.toString();
      request.fields['sellerId'] = sellerId.toString();

      if (widget.imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', widget.imageFile!.path),
        );
      }

      var response = await request.send();
      var body = await http.Response.fromStream(response);

      setState(() => isLoading = false);

      if (body.statusCode == 201 || body.statusCode == 200) {
        Util.toast("listing_uploaded_successfully".tr);
        Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => const MarketplaceHomeScreen()),
  (route) => false,
);

      } else {
        Util.toast("upload_failed".tr);
        print(body.body);
      }
    } catch (e) {
      setState(() => isLoading = false);
      Util.toast("error_uploading_listing".tr);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "step_2_header".tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins',),
        ),
        backgroundColor: Palette.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        _buildTextField(_priceController, "price".tr, Icons.monetization_on),

        const SizedBox(height: 15),

        _buildTextField(
          _weightController,
          "weight".tr,
          Icons.scale,
          allowDecimal: true,
        ),

        const SizedBox(height: 20),

        _buildLocationSection(),

        const SizedBox(height: 30), // ✅ replace Spacer()

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _submitListing,
            icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
            label: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "upload_listing".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("choose_location".tr,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Palette.primary.withOpacity(0.4)),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(selectedLocationName)),
              PopupMenuButton(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'current', child: Text("Use Current Location", style: TextStyle(fontFamily: 'Poppins',))),
                  PopupMenuItem(value: 'change', child: Text("Change Location", style: TextStyle(fontFamily: 'Poppins',))),
                ],
                onSelected: (value) {
                  if (value == 'current') _useCurrentLocation();
                  if (value == 'change') _changeLocationDialog();
                },
              )
            ],
          ),
        ),
        Padding(
  padding: const EdgeInsets.only(top: 8),
  child: Text(
    "Note: We are currently operating in Nairobi, Mombasa, Kwale and Kilifi.",
    style: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.orange,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
  ),
),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool allowDecimal = false}) {
    return TextField(
      controller: controller,
      keyboardType: allowDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: allowDecimal
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
          : [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Palette.primary),
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Palette.primary),
        ),
      ),
    );
  }
}
