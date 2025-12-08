import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baustaka/config/palette.dart';
import 'package:baustaka/helper/format_date.dart';
import 'package:baustaka/config/env.dart';
import 'package:baustaka/helper/util.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
      final userString = prefs.getString('user');

      if (userString == null || token == null) {
        setState(() => isLoading = false);
        return;
      }

      final user = jsonDecode(userString);
      final userId = user['_id'];

      final url = Uri.parse('${kBaseApiUrl}v1/notifications/$userId');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded['notifications'] ?? [];
        setState(() {
          notifications = data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        Util.toast('Failed to load notifications.');
        print('Failed to load notifications: ${response.body}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      Util.toast('An error occurred while fetching notifications.');
      print('Error fetching notifications: $e');
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final url = Uri.parse('${kBaseApiUrl}v1/notifications/read/$id');
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final index = notifications.indexWhere((n) => n['_id'] == id);
          if (index != -1) notifications[index]['isRead'] = true;
        });
        Util.toast('Notification marked as read');
      } else {
        Util.toast('Failed to mark notification as read');
        print('Failed to mark notification as read');
      }
    } catch (e) {
        Util.toast('An error occurred while marking notification as read.');
        print('Error marking as read: $e');
    }
  }

  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Palette.primary,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: markAllAsRead,
            child: const Text(
              'Mark all as read',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Palette.primary))
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    'No notifications yet',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
  padding: const EdgeInsets.all(15),
  itemCount: notifications.length,
  itemBuilder: (context, index) {
    final n = notifications[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.15),
          child: const Icon(Icons.notifications, color: Palette.primary),
        ),

        title: Text(
          n['title'] ?? 'No title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: n['isRead'] == true ? Colors.black87 : Palette.primary,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              n['message'] ?? 'No message',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 6),
            Text(
              formatDate(n['createdAt']),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),

        onTap: () => markAsRead(n['_id']),
      ),
    );
  },
)

    );
  }
}