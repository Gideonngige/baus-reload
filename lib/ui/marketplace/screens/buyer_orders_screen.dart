import 'package:flutter/material.dart';
import 'tracking_screen.dart';
import 'dart:convert'; // for jsonDecode
import 'package:http/http.dart' as http; // for API calls
import 'package:shared_preferences/shared_preferences.dart'; // for prefs
import '../widgets/message_pop.dart';
import 'package:baustaka/config/palette.dart';


class BuyerOrdersScreen extends StatefulWidget {
  const BuyerOrdersScreen({super.key});

  @override
  State<BuyerOrdersScreen> createState() => _BuyerOrdersScreenState();
}

class _BuyerOrdersScreenState extends State<BuyerOrdersScreen> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String? token;
  Map<String, dynamic>? user;
  String baseUrl = 'http://192.168.100.5:5363';

  @override
  void initState(){
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString('token');
      final storedUser = prefs.getString('user');

      // print('Stored Token: $storedToken');
      // print('Stored User: $storedUser');

      if(storedToken == null || storedUser == null){
        setState(() => isLoading = false); 
        return;
      }

      token = storedToken;
      user = jsonDecode(storedUser);

      final buyerId = user!['_id'];
      final url = Uri.parse('http://192.168.100.5:5363/v1/orders/$buyerId');

      final response = await http.get(
        url,
        headers: {
          'Authorization':'Bearer $token',
          'Content-Type':'application/json',
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201){
        final data = jsonDecode(response.body);
        setState((){
          orders = data;
          isLoading = false;
        });
      }else{
        setState(() => isLoading = false);
        showBaustakaMessage(context, 'Failed to load orders.');
        print('Failed to load orders: ${response.body}');
      }

    }catch(e){
      print('Error fetching orders: $e');
      showBaustakaMessage(context, 'Error fetching orders.$e');
      setState(() => isLoading = false);
    }
  }


  Color _getStatusColor(String? status) {
  switch (status) {
    case 'Delivered':
      return Colors.green;
    case 'On Transit':
      return Colors.orange;
    case 'Pending':
    default:
      return Colors.grey;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
        backgroundColor: Palette.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
    ? const Center(child: CircularProgressIndicator(color: Palette.primary))
    : orders.isEmpty
        ? const Center(
            child: Text('No orders yet',
                style: TextStyle(color: Colors.grey, fontSize: 16)),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderItem(order);
            },
          ),

     
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            '$baseUrl${order['listing']['image']}' ?? 'https://via.placeholder.com/150',
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order['listing']['title'] ?? 'Unknown Item',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 5),
              Text("Ksh. ${order['totalPrice'] ?? '0'}",
                  style: const TextStyle(
                      color: Palette.primary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order['deliveryStatus']),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(order['deliveryStatus'] ?? 'Pending',
                      style: TextStyle(
                          color: _getStatusColor(order['deliveryStatus']),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
        if (order['deliveryStatus'] != 'Delivered')
          ElevatedButton(
            onPressed: () {
              print("Navigating with order: $order");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TrackingScreen(order: order)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Track',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
      ],
    ),
  );
}



}