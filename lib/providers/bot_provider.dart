import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final botProvider = StateNotifierProvider<BotNotifier, BotState>((ref) {
  return BotNotifier();
});

class BotNotifier extends StateNotifier<BotState> {
  BotNotifier() : super(BotState.initial()) {
    _loadChatHistory();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _loadChatHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('bot_chats')
            .orderBy('timestamp')
            .get();

    final messages =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return ChatMessage(
            sender: data['sender'] ?? '',
            text: data['text'] ?? '',
            timestamp: (data['timestamp'] as Timestamp).toDate(),
          );
        }).toList();

    state = state.copyWith(messages: messages);
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userMsg = ChatMessage(
      sender: 'user',
      text: message,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
    );

    await _saveMessage(uid, userMsg);

    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": message, "role": state.selectedRole}),
      );

      final botReply =
          response.statusCode == 200
              ? json.decode(response.body)["bot_response"]
              : "⚠️ Error: Unable to get response.";

      final botMsg = ChatMessage(
        sender: 'bot',
        text: botReply,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isLoading: false,
      );

      await _saveMessage(uid, botMsg);
    } catch (e) {
      final errorMsg = ChatMessage(
        sender: 'bot',
        text: "⚠️ Error: $e",
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isLoading: false,
      );

      await _saveMessage(uid, errorMsg);
    }
  }

  Future<void> _saveMessage(String uid, ChatMessage msg) async {
    await _firestore.collection('users').doc(uid).collection('bot_chats').add({
      'sender': msg.sender,
      'text': msg.text,
      'timestamp': msg.timestamp,
    });
  }

  void setRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  void resetChat() {
    state = BotState.initial();
  }
}

class BotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String selectedRole;

  BotState({
    required this.messages,
    required this.isLoading,
    required this.selectedRole,
  });

  factory BotState.initial() =>
      BotState(messages: [], isLoading: false, selectedRole: 'Bestfriend');

  BotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? selectedRole,
  }) {
    return BotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}
