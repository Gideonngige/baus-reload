import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/message_pop.dart';
import '../widgets/marketplace_drawer.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  Map<String, dynamic>? dashboardData;
  Map<String, dynamic>? user;

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

      final decodedUser = jsonDecode(userString);
      final sellerId = decodedUser['_id'];

      setState(() {
        user = decodedUser;
        sellerName = decodedUser['displayName'];
      });

      final url =
          Uri.parse("${kBaseApiUrl}v1/seller/dashboard/$sellerId/");

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          dashboardData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        Util.toast('Failed to fetch dashboard.');
        setState(() => isLoading = false);
      }
    } catch (e) {
      Util.toast('Error fetching dashboard');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Palette.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ✅ REUSABLE DRAWER
      drawer: MarketplaceDrawer(user: user),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Palette.primary),
            )
          : dashboardData == null
              ? const Center(child: Text("No dashboard data available."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildDashboardContent(),
                ),
    );
  }

  // ================= DASHBOARD CONTENT =================

  Widget _buildDashboardContent() {
    final recentListings = dashboardData!["recentListings"] ?? [];
    final monthlySales = dashboardData!["monthlySales"] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, ${sellerName ?? 'User'} 👋',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Here’s your sales summary for this month.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),

        const SizedBox(height: 25),

        Row(
          children: [
            _buildStatCard(
              title: "Total Sales",
              value: "Ksh. ${dashboardData!["totalSales"] ?? 0}",
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            _buildStatCard(
              title: "Total KG Sold",
              value: "${(dashboardData!["totalKgSold"] ?? 0).toStringAsFixed(2)} kg",
              icon: Icons.scale,
              color: Colors.orange,
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            _buildStatCard(
              title: "Pending Orders",
              value: "${dashboardData!["pendingOrders"] ?? 0}",
              icon: Icons.pending_actions,
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

        const Text(
          "Monthly Sales",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),

        _buildBarChart(monthlySales),

        const SizedBox(height: 30),

        const Text(
          "Recent Listings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 15),

        if (recentListings.isEmpty)
          const Center(child: Text("No listings available"))
        else
          Column(
            children: recentListings.map<Widget>((item) {
              return _buildListingTile(
                name: item["title"] ?? "Unknown",
                price: "Ksh. ${item["price"] ?? 0}",
                weight: "${item["weight"] ?? 0} kg",
                status: item["status"] ?? "N/A",
                statusColor: item["status"] == "available"
                    ? Palette.primary
                    : Colors.orange,
                image: item["image"] != null
                    ? '$kBaseImageUrl${item["image"]}'
                    : null,
              );
            }).toList(),
          ),
      ],
    );
  }

  // ================= WIDGETS =================

  Widget _buildBarChart(List monthlySales) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
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
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < monthlySales.length) {
                    return Text(
                      monthlySales[value.toInt()]["month"] ?? "",
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  }
                  return const Text("");
                },
              ),
            ),
          ),
          barGroups: monthlySales.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: (entry.value["sales"] ?? 0).toDouble(),
                  color: Colors.green,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

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
            Text(value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(title,
                style:
                    const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildListingTile({
    required String name,
    required String price,
    required String weight,
    required String status,
    required Color statusColor,
    String? image,
  }) {
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
          )
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
            const Icon(Icons.image_not_supported, size: 70),

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
                      fontWeight: FontWeight.bold,
                      color: Palette.primary)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: statusColor),
                  const SizedBox(width: 4),
                  Text(status,
                      style:
                          TextStyle(color: statusColor, fontSize: 13)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
