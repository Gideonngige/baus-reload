import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/session.dart';
import 'package:baustaka/helper/util.dart';
import './model/order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DriverHomeWidget extends StatefulWidget {
  const DriverHomeWidget({super.key});

  @override
  State<DriverHomeWidget> createState() => _DriverHomeWidgetState();
}

class _DriverHomeWidgetState extends State<DriverHomeWidget> {

  bool isLoading = false;
  List<Order> orders = [];
  String? token;
  Map<String, dynamic>? cached_user;

  /// ✅ SAFE setState (prevents crashes after navigation)
  void safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadUserData);
  }

  /// ✅ Load cached login data
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    final storedUser = prefs.getString('user');

    if (!mounted) return;

    if (storedToken != null && storedUser != null) {
      safeSetState(() {
        cached_user = jsonDecode(storedUser);
        token = storedToken;
      });
      await fetchDriverOrders(); 
    }
  }

  /// ✅ Fetch driver orders from API
  Future<void> fetchDriverOrders() async {
    safeSetState(() => isLoading = true);

    try {
      final user = Session.user;
      if (user == null) throw Exception('User not logged in');

      final token = await user.getIdToken();
      final driverId = cached_user?['_id'];

      if (driverId == null) {
        Util.toast('No driver profile found for this user');
        return;
      }

      final response = await Dio().get(
        '${kBaseApiUrl}v1/orders/driver/$driverId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 304) {
        safeSetState(() {
          orders = (response.data as List)
              .map((e) => Order.fromJson(e))
              .toList();
        });
      } else {
        Util.toast('Failed to fetch orders: ${response.statusMessage}');
      }
    } catch (e) {
      Util.toast('Failed to fetch orders');
      debugPrint("Order Fetch Error: $e");
    } finally {
      safeSetState(() => isLoading = false);
    }
  }

  /// ✅ Delivery confirmation dialog
  void showVerificationDialog(Order order) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Delivery Code'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Delivery code'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Confirm'),
            onPressed: () {
              Navigator.pop(context);
              verifyDelivery(order.id, controller.text);
            },
          ),
        ],
      ),
    );
  }

  /// ✅ Verify delivery API call
  Future<void> verifyDelivery(String orderId, String code) async {
    try {
      final driverId = cached_user?['_id'];
      if (driverId == null) throw Exception('Driver ID not found');

      final response = await Dio().post(
        '${kBaseApiUrl}v1/orders/verify-delivery-driver/',
        data: {
          'orderId': orderId,
          'driverId': driverId,
          'verificationToken': code,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Util.toast('Order marked as delivered');
        await fetchDriverOrders();
      } else {
        Util.toast('Invalid code');
      }
    } catch (e) {
      Util.toast('Failed to verify delivery');
      debugPrint("Verify Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose(); // Ready for future Stream/Timer cleanup
  }

  /// ✅ UI
  @override
  Widget build(BuildContext context) {

    if (cached_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Home'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text('No assigned orders'))
              : RefreshIndicator(
                  onRefresh: fetchDriverOrders,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(order.listing.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Buyer: ${order.buyer.displayName}'),
                              Text('Location: ${order.locationName}'),
                              Text('Status: ${order.deliveryStatus}'),
                            ],
                          ),
                          trailing: order.deliveryStatus != 'delivered'
                              ? ElevatedButton(
                                  child: const Text('Mark Delivered'),
                                  onPressed: () => showVerificationDialog(order),
                                )
                              : const Text(
                                  'Delivered',
                                  style: TextStyle(color: Colors.green),
                                ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
