import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/message_pop.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  bool _isLoading = true;
  String? userId;
  String? token;

  // 🔹 Replace with your backend base URL
  final String baseUrl = "http://192.168.100.5:5363/v1/chat";

  @override
  void initState() {
    super.initState();
    _loadUserDataAndMessages();
  }

  Future<void> _loadUserDataAndMessages() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user');
  final storedToken = prefs.getString('token');

  if (userString != null && storedToken != null) {  // <- use storedToken here
    final user = jsonDecode(userString);
    setState(() {
      userId = user['_id'];
      token = storedToken; // assign token here
    });
    await _fetchMessages();
  } else {
    // If no user/token, stop loading
    setState(() {
      _isLoading = false;
    });
  }
}


  Future<void> _fetchMessages() async {
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/message/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages = data['data'] ?? [];
          _isLoading = false;
        });
      } else {
        showBaustakaMessage(context, 'Failed to load messages.');
        print('Failed to load messages: ${response.body}');
        setState(() => _isLoading = false);
      }
    } catch (e) {
        showBaustakaMessage(context, 'Error fetching messages: $e.');
        print('Error fetching messages: $e');
        setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || userId == null) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "sender": userId,
          "receiver": "685a67c58564d3fd46253aaa", // assuming admin user has ID = 1
          "message": text,
        }),
      );

      if (response.statusCode == 201) {
        final newMsg = jsonDecode(response.body)['data'];
        setState(() {
          _messages.add(newMsg);
          _messageController.clear();
        });
      } else {
        showBaustakaMessage(context, 'Message not sent: ${response.body}.');
        print("Failed to send message: ${response.body}");
      }
    } catch (e) {
        showBaustakaMessage(context, 'Error sending message: $e.');
        print("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              radius: 18,
              child: const Icon(Icons.support_agent, color: Colors.green, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              "Baus Taka Support",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.green[800]))
                : _messages.isEmpty
                    ? const Center(child: Text("No messages yet"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
final isMe = msg['senderId'] == userId;
final text = msg['message'] ?? '';
final response = msg['response'];
final time = msg['createdAt']?.toString().substring(11, 16) ?? '';

return Column(
  crossAxisAlignment:
      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  children: [
    // ✅ User message bubble
    Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    ),

    // ✅ Admin response bubble (only show if available)
    if (response != null && response.toString().trim().isNotEmpty)
      Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            response,
            style: const TextStyle(color: Colors.black87, fontSize: 15),
          ),
        ),
      ),
  ],
);

                        },
                      ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green[800],
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}