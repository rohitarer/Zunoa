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

  void updateMessages(ChatMessage message, bool isUserMessage) {
    final updatedMessages = [...state.messages, message];
    state = state.copyWith(
      messages: updatedMessages,
      isLoading: isUserMessage, // Show loading if user is sending the message
    );
  }

  // Load chat history from Firestore
  Future<void> _loadChatHistory() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
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
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  // Send message logic
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

    // Save user message to Firestore
    await _saveMessage(uid, userMsg);

    try {
      // Send message to backend and get response
      final response = await http.post(
        Uri.parse("http://localhost:5000/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"message": message, "role": state.selectedRole}),
      );

      final botReply =
          response.statusCode == 200
              ? json.decode(response.body)["bot_response"]
              : "⚠️ Error: Unable to get response.";

      // Create bot message
      final botMsg = ChatMessage(
        sender: 'bot',
        text: botReply,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, botMsg],
        isLoading: false,
      );

      // Save bot message to Firestore
      await _saveMessage(uid, botMsg);
    } catch (e) {
      // Handle error
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

  // Save messages to Firestore
  Future<void> _saveMessage(String uid, ChatMessage msg) async {
    try {
      await _firestore.collection('users').doc(uid).collection('bot_chats').add(
        {'sender': msg.sender, 'text': msg.text, 'timestamp': msg.timestamp},
      );
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  // Set role for the bot
  void setRole(String role) {
    state = state.copyWith(selectedRole: role);
  }

  // Reset the chat to initial state
  void resetChat() {
    state = BotState.initial();
  }

  // Get user UID (used for Firestore operations)
  String? getUid() {
    return _auth.currentUser?.uid;
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
