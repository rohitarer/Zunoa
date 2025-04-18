import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  // Sample data for users
  final List<Map<String, String>> users = [
    {"name": "John Doe", "avatarUrl": "assets/male_avatar.png"},
    {"name": "Jane Smith", "avatarUrl": "assets/female_avatar.png"},
    {"name": "Mark Wilson", "avatarUrl": "assets/male_avatar.png"},
    {"name": "Emily Davis", "avatarUrl": "assets/female_avatar.png"},
    {"name": "Michael Brown", "avatarUrl": "assets/male_avatar.png"},
    {"name": "Sarah Lee", "avatarUrl": "assets/female_avatar.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.blue, // Customize your app bar color
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user["avatarUrl"]!),
            ),
            title: Text(user["name"]!),
            onTap: () {
              // Add your chat screen navigation logic here
              // For example, navigate to a chat with the selected user
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final Map<String, String> user;

  const ChatDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${user["name"]}")),
      body: Center(child: Text("Chat content with ${user["name"]}")),
    );
  }
}
