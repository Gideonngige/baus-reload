import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'create_listing_step2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:baustaka/config/palette.dart';
import 'package:get/get.dart';

class CreateListingStep1 extends StatefulWidget {
  const CreateListingStep1({super.key});

  @override
  State<CreateListingStep1> createState() => _CreateListingStep1State();
}

class _CreateListingStep1State extends State<CreateListingStep1> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedImage;
  final List<String> _categories = [
  'Plastic waste',
  'Recycled products',
  'Upcycled products',
  'Circular products',
  'Metal waste',
  'Glass waste',
  'Paper waste',
  'E-waste',
  'Furniture waste',
  'Construction waste',
  'Food Waste',
  'Other waste',
];

String? _selectedCategory;


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  void _goToNextStep() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateListingStep2(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            category: _selectedCategory!,
            imageFile: _selectedImage,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Palette.primary,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "step_header".tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize:20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "sell_your_item".tr,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Palette.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "step_details".tr,
                style: GoogleFonts.poppins(color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),

              // Image Upload Section
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage == null
                    ? Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Palette.primary),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 60, color: Palette.primary),
                            const SizedBox(height: 10),
                            Text(
                              "tap_to_upload_image".tr,
                              style: GoogleFonts.poppins(
                                  color: Palette.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          _selectedImage!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 25),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      _titleController,
                      "item_title".tr,
                      Icons.label_outline_rounded,
                    ),

                    const SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: _selectedCategory,
  validator: (value) =>
      value == null ? 'Please select a category' : null,
  style: GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
  items: _categories
      .map(
        (category) => DropdownMenuItem<String>(
          value: category,
          child: Text(
            category,
            style: GoogleFonts.poppins(),
          ),
        ),
      )
      .toList(),
  onChanged: (value) {
    setState(() {
      _selectedCategory = value;
    });
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(
      Icons.category_outlined,
      color: Colors.green[800],
    ),
    labelText: 'category'.tr,
    labelStyle: GoogleFonts.poppins(color: Palette.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Palette.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Palette.primary, width: 1.5),
    ),
  ),
),



                    const SizedBox(height: 15),
                    _buildTextField(
                      _descController,
                      "description".tr,
                      Icons.description_outlined,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Next Button
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      validator: (val) => val!.isEmpty ? 'Please enter $label' : null,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.green[800]),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Palette.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Palette.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Palette.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _goToNextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          "next".tr,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}