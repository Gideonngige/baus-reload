import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  setState(() => isLoading = true);

  final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('token');
//   final storedUser = prefs.getString('user');

  final token = 'dummy_token_12345';
final storedUser = '{"id": 1, "name": "Test Seller", "email": "seller@test.com"}';

  final cachedLocation = await getCachedLocation();

  final latitude = cachedLocation['latitude'];
  final longitude = cachedLocation['longitude'];
  final locationName = cachedLocation['locationName'];


  if (token == null || storedUser == null) return;

  final price = _priceController.text.trim();
  final weight = _weightController.text.trim();

  if (price.isEmpty || weight.isEmpty) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fill in all the fields!")),
    );
    return;
  }

  final user = jsonDecode(storedUser);
  final sellerId = user['id'];
  final url = Uri.parse('https://baustaka-backend.onrender.com/api/listings/create');

  try {
    // ✅ Create a multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers
    request.headers['Authorization'] = 'Bearer $token';

    // Add text fields
    request.fields['title'] = widget.title;
    request.fields['description'] = widget.description;
    request.fields['price'] = price;
    request.fields['weight'] = weight;
    request.fields['locationName'] = locationName ?? "Meru, Kenya";
    request.fields['latitude'] = (latitude ?? 0.1231765).toString();
    request.fields['longitude'] = (longitude ?? 37.7211678).toString();
    request.fields['sellerId'] = sellerId.toString();

    // ✅ Attach image file if selected
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing uploaded successfully!')),
      );
      Navigator.pop(context);
    } else {
      print("Failed response: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${response.body}')),
      );
    }
  } catch (e) {
    setState(() => isLoading = false);
    print("Error uploading: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
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
        backgroundColor: Colors.green[800],
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
            _buildTextField(_weightController, "Weight (kg)", Icons.scale),
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
                  backgroundColor: Colors.green[800],
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green[800]),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.green[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
      ),
    );
  }
}