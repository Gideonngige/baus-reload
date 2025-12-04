import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/message_pop.dart';
import 'package:baustaka/config/palette.dart';
import 'all_listings_screen.dart';
import 'package:get/get.dart';


class CreateListingStep2 extends StatefulWidget {
  final String title;
  final String description;
  final File? imageFile;

  const CreateListingStep2({
    super.key,
    required this.title,
    required this.description,
    this.imageFile,
  });

  @override
  State<CreateListingStep2> createState() => _CreateListingStep2State();
}

class _CreateListingStep2State extends State<CreateListingStep2> {
  
  final _priceController = TextEditingController();
  final _weightController = TextEditingController();
  bool isLoading = false;
  
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
    throw Exception("No cached location found");
  }
}

  Future<void> _submitListing() async {
   final price = _priceController.text.trim();
  final double? weight = double.tryParse(_weightController.text.trim());

if (weight == null) {
  setState(() => isLoading = false);
  showBaustakaMessage(context, "Enter valid weight (e.g. 2.50)");
  return;
}

// force 2 decimal places
final formattedWeight = weight.toStringAsFixed(2);


    if (price.isEmpty || weight == null) {
    setState(() => isLoading = false);
    showBaustakaMessage(context, 'Fill in all the fields!.');
    return;
  }

  setState(() => isLoading = true);

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final storedUser = prefs.getString('user');

  final cachedLocation = await getCachedLocation();

  final latitude = cachedLocation['latitude'];
  final longitude = cachedLocation['longitude'];
  final locationName = cachedLocation['locationName'];


  if (token == null || storedUser == null) return;

  final user = jsonDecode(storedUser);
  final sellerId = user['_id'];
  final url = Uri.parse('http://192.168.100.5:5363/v1/listings/');

  try {
    // Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';

    // Add text fields
    request.fields['title'] = widget.title;
    request.fields['description'] = widget.description;
    request.fields['price'] = price;
    request.fields['weight'] = formattedWeight;
    request.fields['locationName'] = locationName ?? "Meru, Kenya";
    request.fields['latitude'] = (latitude ?? 0.1231765).toString();
    request.fields['longitude'] = (longitude ?? 37.7211678).toString();
    request.fields['sellerId'] = sellerId.toString();

    //Attach image file if selected
    if (widget.imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        widget.imageFile!.path,
      ));
    }

    // Send the request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    setState(() => isLoading = false);

    if (response.statusCode == 201) {
        showBaustakaMessage(context, 'Listing uploaded successfully!.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AllListingsScreen()),
        );
    } else {
        showBaustakaMessage(context, 'Failed to upload listing.');
        print("Failed response: ${response.body}");
    }
  } catch (e) {
    setState(() => isLoading = false);
    showBaustakaMessage(context, 'An error occurred while uploading listing!.');
    print("Error uploading: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
            "Step 2: Pricing & Location",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        backgroundColor: Palette.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildTextField(_priceController, "Price (Ksh)", Icons.monetization_on),
            const SizedBox(height: 15),
            _buildTextField(_weightController, "Weight (kg)", Icons.scale, allowDecimal: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _submitListing,
                icon: const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                label: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload Listing", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool allowDecimal = false,
  }) {
  return TextField(
    controller: controller,
    keyboardType:
        allowDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
    inputFormatters: allowDecimal
        ? [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ]
        : [
            FilteringTextInputFormatter.digitsOnly,
          ],
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Palette.primary),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Palette.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Palette.primary, width: 1.5),
      ),
    ),
  );
}

}