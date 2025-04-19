import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:zunoa/providers/bot_provider.dart'; // Ensure bot provider logic

class BotScreen extends ConsumerStatefulWidget {
  const BotScreen({super.key});

  @override
  ConsumerState<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends ConsumerState<BotScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    final messages = ref.read(botProvider).messages;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < messages.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    });
  }

  void _send() async {
    final msg = _inputController.text.trim();
    if (msg.isNotEmpty) {
      final uid = ref.read(botProvider.notifier).getUid(); // Ensure valid UID
      if (uid == null) return;

      // Add user message to the state
      final userMsg = ChatMessage(
        sender: 'user',
        text: msg,
        timestamp: DateTime.now(),
      );

      ref.read(botProvider.notifier).updateMessages(userMsg, true);

      // Ensure list key is inserted properly and add message
      _listKey.currentState?.insertItem(
        ref.read(botProvider).messages.length - 1,
      );

      _inputController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      // Save message to Firestore
      await _saveMessage(uid, userMsg);

      try {
        // Send message to the backend and get the bot's response
        final response = await http.post(
          Uri.parse("http://localhost:5000/api/chat"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "message": msg,
            "role": ref.read(botProvider).selectedRole,
          }),
        );

        final botReply =
            response.statusCode == 200
                ? json.decode(response.body)["bot_response"]
                : "⚠️ Error: Unable to get response.";

        // Create and add bot message
        final botMsg = ChatMessage(
          sender: 'bot',
          text: botReply,
          timestamp: DateTime.now(),
        );

        ref.read(botProvider.notifier).updateMessages(botMsg, false);

        // Insert bot message and scroll to the bottom
        _listKey.currentState?.insertItem(
          ref.read(botProvider).messages.length - 1,
        );
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        await _saveMessage(uid, botMsg); // Save bot message to Firestore
      } catch (e) {
        // Handle error
        final errorMsg = ChatMessage(
          sender: 'bot',
          text: "⚠️ Error: $e",
          timestamp: DateTime.now(),
        );

        ref.read(botProvider.notifier).updateMessages(errorMsg, false);

        _listKey.currentState?.insertItem(
          ref.read(botProvider).messages.length - 1,
        );
        await _saveMessage(uid, errorMsg);
      }
    }
  }

  // Function to save message to Firestore
  Future<void> _saveMessage(String uid, ChatMessage msg) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bot_chats')
          .add({
            'sender': msg.sender,
            'text': msg.text,
            'timestamp': msg.timestamp,
          });
    } catch (e) {
      print("Error saving message to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final botState = ref.watch(botProvider);
    final controller = ref.read(botProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: botState.selectedRole,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.person_outline, color: Colors.white),
              items:
                  ["Bestfriend", "Brother", "Sister", "Listener"]
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.setRole(value);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              controller: _scrollController,
              initialItemCount: botState.messages.length,
              itemBuilder: (context, index, animation) {
                final msg = botState.messages[index];
                final isUser = msg.sender == "user";
                final timestamp = DateFormat('hh:mm a').format(msg.timestamp);

                return SizeTransition(
                  sizeFactor: animation,
                  child: Container(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser)
                          const CircleAvatar(radius: 16, child: Text("🤖")),
                        if (!isUser) const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isUser ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msg.text),
                                const SizedBox(height: 4),
                                Text(
                                  timestamp,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isUser) const SizedBox(width: 8),
                        if (isUser)
                          const CircleAvatar(radius: 16, child: Text("👨‍🦱")),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (botState.isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
