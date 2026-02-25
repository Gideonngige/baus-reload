import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../screens/notifications_screen.dart';
import '../screens/all_listings_screen.dart';
import '../screens/create_listing_step1.dart';
import '../screens/chat_screen.dart';
import '../screens/buyer_orders_screen.dart';
import '../screens/seller_dashboard_screen.dart';
import '../screens/marketplace_home_screen.dart';

import '../widgets/message_pop.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/ui/main/main_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class MarketplaceDrawer extends StatelessWidget {
  final Map<String, dynamic>? user;

  const MarketplaceDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?['displayName'] ?? 'Market User', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(user?['email'] ?? 'marketuser@example.com', style: GoogleFonts.poppins(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Palette.primary),
            ),
            decoration: BoxDecoration(
              color: Palette.primary,
            ),
          ),

          _drawerItem(
  context,
  icon: Icons.home,
  title: 'home'.tr,
  onTap: () {
    Navigator.pop(context); // close drawer
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MarketplaceHomeScreen(),
      ),
      (route) => false,
    );
  },
),


          _drawerItem(
            context,
            icon: Icons.list,
            title: 'all_listings'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AllListingsScreen()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'sell'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const CreateListingStep1()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.receipt_long,
            title: 'my_orders'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const BuyerOrdersScreen()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.dashboard,
            title: 'dashboard'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SellerDashboardScreen()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.chat,
            title: 'chat'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.notifications,
            title: 'notifications'.tr,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationsScreen()),
              );
            },
          ),

          _drawerItem(
            context,
            icon: Icons.language,
            title: Get.locale?.languageCode == 'sw' ? 'Switch to English' : 'Badili kwenda Kiswahili',
            onTap: (){
              if(Get.locale?.languageCode == 'en'){
                Get.updateLocale(const Locale('sw', 'KE'));
              }else{
                Get.updateLocale(const Locale('en', 'US'));
              }
              Navigator.pop(context);
            },
          ),

          const Divider(),

          _drawerItem(
            context,
            icon: Icons.apps,
            title: 'back_to_main'.tr,
            onTap: () async {
              Navigator.pop(context);
              // Go back to main app shell
              Get.offAll(() => MainWidget());
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
