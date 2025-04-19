// 📄 anonymous_chat_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/providers/anonymous_provider.dart'; // Import the new provider

class AnonymousChatScreen extends ConsumerStatefulWidget {
  const AnonymousChatScreen({super.key});

  @override
  ConsumerState<AnonymousChatScreen> createState() =>
      _AnonymousChatScreenState();
}

class _AnonymousChatScreenState extends ConsumerState<AnonymousChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch messages when the screen is initialized
    ref.read(anonymousChatProvider.notifier).fetchMessages();
  }

  // Send a message
  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Use the provider to send the message
      await ref.read(anonymousChatProvider.notifier).sendMessage(message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(anonymousChatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Anonymous Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final timestamp = DateFormat(
                  'hh:mm a',
                ).format((message['timestamp'] as Timestamp).toDate());

                return ListTile(
                  title: Text(
                    message['nickname'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                  subtitle: Text(
                    message['message'],
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  trailing: Text(timestamp),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
