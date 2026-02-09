import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/marketplace_drawer.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() =>
      _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {

  // ================== REUSABLE VARIABLES ==================

  Map<String, dynamic>? dashboardData;
  Map<String, dynamic>? walletData;
  Map<String, dynamic>? user;

  bool isLoading = true;

  String sellerName = "";
  String sellerId = "";
  String token = "";
  String phoneNumber = "";

  // ========================================================

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Load user + token ONCE
  Future<void> _initializeData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      print(userString);

      final firebaseUser = FirebaseAuth.instance.currentUser;

      if (userString == null || firebaseUser == null) {
        setState(() => isLoading = false);
        return;
      }

      token = (await firebaseUser.getIdToken(true)) ?? "";

      user = jsonDecode(userString);
      sellerId = user!['_id'];
      sellerName = user!['displayName'] ?? "Seller";
      // phoneNumber = user!['phoneNumber'] ?? "";

      await Future.wait([
        fetchDashboardData(),
        fetchWalletData(),
      ]);

    } catch (e) {
      Util.toast("initialization_error".tr);
    }

    setState(() => isLoading = false);
  }

  // ================= FETCH DASHBOARD =================

  Future<void> fetchDashboardData() async {
    try {
      final url =
          Uri.parse("${kBaseApiUrl}v1/seller/dashboard/$sellerId/");

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        dashboardData = jsonDecode(response.body);
      } else {
        Util.toast('failed_to_load_dashboard'.tr);
      }
    } catch (e) {
      Util.toast('error_fetching_dashboard'.tr);
    }
  }

  // ================= FETCH WALLET =================

  Future<void> fetchWalletData() async {
    try {
      final url =
          Uri.parse("${kBaseApiUrl}v1/withdraw/wallet/$sellerId/");

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        walletData = jsonDecode(response.body);
      } else {
        Util.toast('failed_to_fetch_wallet'.tr);
      }
    } catch (e) {
      Util.toast('error_fetching_wallet'.tr);
    }
  }

  // ================= WITHDRAW =================

  Future<void> _withdraw() async {
    if(walletData?["data"]?["balance_amount"] <= 100){
      Util.toast("insufficient_balance".tr);
      return;

    }
    try {

      final url =
          Uri.parse("${kBaseApiUrl}v1/withdraw/");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "userId": sellerId,
          "phoneNumber": user!['phoneNumber'] ?? "",
          "amount": walletData?["data"]?["balance_amount"] ?? 0,
        }),
      );

      if (response.statusCode == 200) {

        Util.toast("withdraw_successful".tr);

        await fetchWalletData();
        setState(() {});

      } else {
        Util.toast("withdraw_failed".tr);
      }
    } catch (e) {
      Util.toast("withdraw_error".tr);
    }
  }

  void _handleWithdraw() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("withdraw".tr),
        content: Text("withdraw_text".tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _withdraw();
            },
            child: Text("confirm".tr),
          ),
        ],
      ),
    );
  }

  // ========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        title: Text(
          'dashboard'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Palette.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

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

  // ================= DASHBOARD =================

  Widget _buildDashboardContent() {

    final recentListings = dashboardData?["recentListings"] ?? [];
    final monthlySales = dashboardData?["monthlySales"] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'hi'.tr + ', $sellerName 👋',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 20),

        _buildEarningsCard(),

        const SizedBox(height: 25),

        Text(
          'summary_text'.tr,
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            _buildStatCard(
              title: "total_sales".tr,
              value: "Ksh. ${dashboardData?["totalSales"] ?? 0}",
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            _buildStatCard(
              title: "total_kg_sold".tr,
              value:
                  "${(dashboardData?["totalKgSold"] ?? 0).toString()} kg",
              icon: Icons.scale,
              color: Colors.orange,
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            _buildStatCard(
              title: "pending_orders".tr,
              value: "${dashboardData?["pendingOrders"] ?? 0}",
              icon: Icons.pending_actions,
              color: Colors.blue,
            ),
            _buildStatCard(
              title: "completed_orders".tr,
              value: "${dashboardData?["completedOrders"] ?? 0}",
              icon: Icons.check_circle_outline,
              color: Colors.purple,
            ),
          ],
        ),

        const SizedBox(height: 30),

        Text(
          "monthly_sales".tr,
          style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 15),

        _buildBarChart(monthlySales),

        const SizedBox(height: 30),

        Text(
          "recent_listings".tr,
          style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 15),

        if (recentListings.isEmpty)
          Center(child: Text("no_listings".tr))
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

  // ================= EARNINGS CARD =================

  Widget _buildEarningsCard() {

    final totalAmount = walletData?["data"]?["total_amount"] ?? 0;
    final balanceAmount = walletData?["data"]?["balance_amount"] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Palette.primary,
            Palette.primary.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "total_earnings".tr,
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 8),

          Text(
            "Ksh. $totalAmount",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            "available_balance".tr + ": Ksh. $balanceAmount",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: balanceAmount == 0
                  ? null
                  : _handleWithdraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Palette.primary,
              ),
              child: Text(
                "withdraw_earnings".tr,
                style:
                    TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SMALL WIDGETS =================

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
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor:
                  color.withOpacity(0.1),
              child: Icon(icon,
                  color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(
                    color: Colors.grey)),
          ],
        ),
      ),
    );
  }

 Widget _buildBarChart(List monthlySales) {
  return SizedBox(
    height: 220,
    child: BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),

          /// ✅ Bottom Month Names
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();

                if (index >= monthlySales.length) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    monthlySales[index]["month"], // ⭐ FROM BACKEND
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        barGroups: monthlySales.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: (e.value["sales"] ?? 0).toDouble(),
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


  Widget _buildListingTile({
    required String name,
    required String price,
    required String weight,
    required String status,
    required Color statusColor,
    String? image,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(
              vertical: 8),
      leading: image != null
          ? Image.network(image,
              width: 60,
              fit: BoxFit.cover)
          : const Icon(Icons.image),
      title: Text(name),
      subtitle: Text(weight),
      trailing: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.end,
        children: [
          Text(price,
              style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Palette.primary)),
          Text(status,
              style: TextStyle(
                  color: statusColor)),
        ],
      ),
    );
  }
}
