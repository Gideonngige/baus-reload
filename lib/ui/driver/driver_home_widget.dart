import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import './model/order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:baustaka/config/palette.dart';
import './notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverHomeWidget extends StatefulWidget {
  const DriverHomeWidget({super.key});

  @override
  State<DriverHomeWidget> createState() => _DriverHomeWidgetState();
}

class _DriverHomeWidgetState extends State<DriverHomeWidget> {

  bool isLoading = false;
  List<Order> orders = [];
  Map<String, dynamic>? cachedUser;

  void safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadUser);
  }

  // ==========================
  // CALL BUYER
  // ==========================
  Future<void> _callBuyer(String? phone) async {
    if (phone == null || phone.isEmpty) {
      Util.toast("Buyer phone not available");
      return;
    }

    final Uri url = Uri.parse("tel:$phone");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Util.toast("Cannot make a call from this device");
    }
  }

  // ==========================
  // LOAD USER
  // ==========================
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final u = prefs.getString('user');

    if (u != null) {
      safeSetState(() => cachedUser = jsonDecode(u));
      fetchDriverOrders();
    }
  }

  // ==========================
  // FETCH ORDERS
  // ==========================
  Future<void> fetchDriverOrders() async {
    safeSetState(() => isLoading = true);

    try {
      final user = Session.user;
      if (user == null) throw Exception("Not logged in");

      final token = await user.getIdToken();
      final driverId = cachedUser?['_id'];

      final res = await Dio().get(
        '${kBaseApiUrl}v1/orders/driver/$driverId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        safeSetState(() {
          orders = (res.data as List)
              .map((e) => Order.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      Util.toast("Failed loading orders");
      debugPrint(e.toString());
    } finally {
      safeSetState(() => isLoading = false);
    }
  }

  // ==========================
  // VERIFY DELIVERY
  // ==========================
  Future<void> verifyDelivery(String orderId, String code) async {
    try {
      final driverId = cachedUser?['_id'];
      final user = Session.user;
      if (user == null) throw Exception("Not logged in");
      final token = await user.getIdToken();
      final res = await Dio().post(
        '${kBaseApiUrl}v1/orders/verify-delivery-driver/',
        data: {
          'orderId': orderId,
          'driverId': driverId,
          'verificationToken': code,
        },
        options: Options(
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  ),
      );

      if (!mounted) return;

      if (res.statusCode == 200) {
        Util.toast("Order delivered");
        fetchDriverOrders();
      }
    } catch (_) {
      Util.toast("Verification failed");
    }
  }

  // ==========================
  // CONFIRM UI
  // ==========================
  void showVerificationDialog(Order order) {
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delivery Code"),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Code'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            child: const Text("Confirm"),
            onPressed: () {
              Navigator.pop(context);
              verifyDelivery(order.id, ctrl.text);
            },
          ),
        ],
      ),
    );
  }

  // ==========================
  // STATUS BADGE
  // ==========================
  Widget statusBadge(String status) {
    final color = status == 'delivered' ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ==========================
  // UI
  // ==========================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assigned Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.primary,
        centerTitle: true,
        actions: [

          // Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Session.logout();
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pop(context);
            },
          ),

          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text("No orders assigned"))
          : RefreshIndicator(
        onRefresh: fetchDriverOrders,
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (_, i) => orderCard(orders[i]),
        ),
      ),
    );
  }

  // ==========================
  // CARD UI
  // ==========================
  Widget orderCard(Order order) {

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // PRODUCT
            Text(order.listing.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

            const SizedBox(height: 6),

            // STATUS
            // LOCATION + STATUS (VERTICAL)
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(order.locationName),
    const SizedBox(height: 6),
    statusBadge(order.deliveryStatus),
  ],
),


            const Divider(height: 20),

            // BUYER DETAILS
            Row(
              children: [

                // Avatar
                const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),

                const SizedBox(width: 10),

                // Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Buyer",
                          style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      Text(order.buyer.displayName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ),

                // CALL BUTTON
                MaterialButton(
                  color: Colors.green,
                  shape: const CircleBorder(),
                  onPressed: () => _callBuyer(order.buyer.phoneNumber),
                  child: const Icon(Icons.call, color: Colors.white),
                )
              ],
            ),

            const Divider(height: 20),

            // ACTION BUTTON
            order.deliveryStatus != 'delivered'
                ? SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("MARK DELIVERED"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => showVerificationDialog(order),
              ),
            )
                : const Center(
              child: Text(
                "Delivery Complete",
                style:
                TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
