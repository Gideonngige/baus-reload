import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'notifications_screen.dart';
import 'all_listings_screen.dart';
import 'create_order_screen.dart';
import 'create_listing_step1.dart';
import 'chat_screen.dart';
import 'buyer_orders_screen.dart';
import 'seller_dashboard_screen.dart';
import '../widgets/message_pop.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import '../widgets/marketplace_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';



class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  final List<String> imageList = [
    'assets/images/marketplace/collect_litters.jpg',
    'assets/images/marketplace/ground_littered.jpg',
    'assets/images/marketplace/little_boys.png',
  ];

  List<dynamic> listings = [];
  bool isLoading = true;

  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  String? token;
  String? location;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchListings();
    _startAutoSlide();
    _getUserLocation();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // final storedToken = prefs.getString('token');
    final storedUser = prefs.getString('user');
    print("Stored user: $storedUser");
   


    if (storedUser != null) {
      setState(() {
        user = jsonDecode(storedUser);
        // token = storedToken;
      });
      await _fetchListings(); //fetch listings after user is loaded
    }
  }

  Future<void> _fetchListings() async {
    try {
      final headers = await Session.headers();
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final token = await firebaseUser!.getIdToken(true);

      final response = await http.get(
        Uri.parse('${kBaseApiUrl}v1/listings/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          listings = data;
          isLoading = false;
        });
      } else {
        print('Failed to load listings: ${response.body}');
        Util.toast('Failed to load listings.');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching listings: $e');
      Util.toast('An error occured while fetching listings');
      setState(() => isLoading = false);
    }
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= imageList.length) nextPage = 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // function to get current user location
  Future<void> _getUserLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return;
  }

  // Check for permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return;
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');

  // Convert coordinates to address
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  Placemark place = placemarks[0];
  // String locationName = place.locality ?? place.subLocality ?? place.name ?? "";
  String locationName = [
  place.locality,     // city/town
  place.administrativeArea, // state/province
  place.country       // country
].where((s) => s != null && s.isNotEmpty).join(', ');
location = locationName;
      // "${place.locality}, ${place.country}" ?? "Meru, Kenya"; // e.g. "Meru, Kenya"
  print("Location Name");
  print("Location Name: $locationName");
  
  // cache the location data
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('latitude', position.latitude);
  await prefs.setDouble('longitude', position.longitude);
  await prefs.setString('locationName', locationName);
}

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        elevation: 0,
        title: const Text(
          'Marketplace',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

  // drawer
  drawer: MarketplaceDrawer(user: user),

      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.green[800]))
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //  Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Palette.primary, size: 24),
                            const SizedBox(width: 5),
                            Text(
                              '$location' ?? 'Meru, Kenya',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen()),
                            );
                          },
                          icon: const Icon(Icons.notifications_none_rounded,
                              size: 28, color: Palette.primary),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 👋 Greeting
                    Text(
                      'Hi, ${user?['displayName'] ?? 'User'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🖼️ Slider
                    SizedBox(
                      height: 180,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: imageList.length,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                imageList[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Slider dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == entry.key
                                ? Colors.green[800]
                                : Colors.grey.shade400,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 25),

                    // 📦 Top Listings Header with View All
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'Top Listings',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    if (listings.isNotEmpty)
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AllListingsScreen(),
            ),
          );
        },
        child: const Text(
          'View all',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Palette.primary,
          ),
        ),
      ),
  ],
),

const SizedBox(height: 15),


                    listings.isEmpty
                        ? const Center(
                            child: Text('No listings available.'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: listings.length,
                            itemBuilder: (context, index) {
                              final item = listings[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateOrderScreen(item: item),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item['image'] != null ? '$kBaseImageUrl${item['image']}' : 'https://via.placeholder.com/70',
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'] ?? 'No title',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Ksh. ${item['price']}/kg',
                                              style: TextStyle(
                                                  color: Palette.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${item['locationName']}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),

                                            ),
                                          ],
                                        ),
                                      ),
                                      


                                      const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                          size: 18),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                    const SizedBox(height: 20),


                  ],
                ),
              ),
      ),
    );
  }
}