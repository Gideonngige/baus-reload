import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/message_pop.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  Map<String, dynamic>? dashboardData;
  bool isLoading = true;
  String? sellerName;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      final token = prefs.getString('token');


      if (userString == null || token == null) {
        setState(() => isLoading = false);
        return;
      }

      final user = jsonDecode(userString);
      final sellerId = user['_id'];
      sellerName = user['displayName'];
      print("Seller ID: $sellerId");

      final url = Uri.parse("http://192.168.100.5:5363/v1/seller/dashboard/$sellerId/");

      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        setState(() {
          dashboardData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showBaustakaMessage(context, 'Failed to fetch dashboard.');
        print("Failed to fetch dashboard: ${response.body}");
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
      showBaustakaMessage(context, 'Error fetching dashboard: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    if (dashboardData == null) {
      return const Scaffold(
        body: Center(child: Text("No dashboard data available.")),
      );
    }

    final recentListings = dashboardData!["recentListings"] ?? [];
    final monthlySales = dashboardData!["monthlySales"] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Seller Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 Welcome Section
            Text(
              'Hi, ${sellerName ?? 'User'} 👋',
              // "Seller",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Here’s your sales summary for this month.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 25),

            // 🔹 Top Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: "Total Sales",
                  value: "Ksh. ${dashboardData!["totalSales"] ?? 0}",
                  icon: Icons.attach_money_rounded,
                  color: Colors.green,
                ),
                _buildStatCard(
                  title: "Total KG Sold",
                  value: "${dashboardData!["totalKgSold"] ?? 0} kg",
                  icon: Icons.scale_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: "Pending Orders",
                  value: "${dashboardData!["pendingOrders"] ?? 0}",
                  icon: Icons.pending_actions_rounded,
                  color: Colors.blue,
                ),
                _buildStatCard(
                  title: "Completed",
                  value: "${dashboardData!["completedOrders"] ?? 0}",
                  icon: Icons.check_circle_outline,
                  color: Colors.purple,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Bar Chart
            const Text(
              "Monthly Sales Overview",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 15),
            Container(
              height: 220,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: BarChart(
  BarChartData(
    alignment: BarChartAlignment.spaceAround,
    gridData: const FlGridData(show: false),
    borderData: FlBorderData(show: false),
    titlesData: FlTitlesData(
      leftTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles:
          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            if (value.toInt() < monthlySales.length) {
              return Text(
                monthlySales[value.toInt()]["month"] ?? "",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              );
            }
            return const Text("");
          },
        ),
      ),
    ),
    // ✅ FIXED HERE ↓↓↓
    barGroups: monthlySales.asMap().entries.map((entry) {
      final index = entry.key;
      final sale = entry.value;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
          toY: (sale["sales"] ?? 0).toDouble(),
          color: Colors.green,
          width: 18,
          borderRadius: BorderRadius.circular(6),
        ),
      ]);
    }).toList().cast<BarChartGroupData>(), // 👈 Add this cast
  ),
),

            ),

            const SizedBox(height: 30),

            //  Recent Listings
            const Text(
              "Recent Listings",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 15),

            if (recentListings.isEmpty)
              const Center(child: Text("No listings available"))
            else
              Column(
                children: recentListings.map<Widget>((item) {
                  return _buildListingTile(
                    item["title"] ?? "Unknown",
                    "Ksh. ${item["price"] ?? 0}",
                    "${item["weight"] ?? 0} kg",
                    item["status"] ?? "N/A",
                    item["status"] == "available"
                        ? Colors.green
                        : Colors.orange,
                    image: item["image"],
                  );
                }).toList(),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  //  Helper: Stat Card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper: Listing Tile
  Widget _buildListingTile(
      String name, String price, String weight, String status, Color statusColor,
      {String? image}) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            )
          else
            const Icon(Icons.image_not_supported, size: 70, color: Colors.grey),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(weight, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: statusColor),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}