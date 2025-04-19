// 📄 anonymous_chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/services/firebase_service.dart'; // Import the FirebaseService

// Define a state notifier to handle chat messages
class AnonymousChatNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final FirebaseService firebaseService;

  // Constructor
  AnonymousChatNotifier({required this.firebaseService}) : super([]);

  // Fetch messages from Firebase
  Future<void> fetchMessages() async {
    final messages = await firebaseService.fetchChatMessages();
    state = messages;
  }

  // Send a message to Firebase
  Future<void> sendMessage(String message) async {
    final user = firebaseService.currentUser;
    if (user == null) return;

    final nickname =
        user.displayName ??
        'Anonymous'; // Use user display name or fallback to Anonymous
    await firebaseService.sendMessage(message);
    await fetchMessages(); // Refresh the chat after sending a message
  }
}

// Define a provider to access AnonymousChatNotifier
final anonymousChatProvider =
    StateNotifierProvider<AnonymousChatNotifier, List<Map<String, dynamic>>>((
      ref,
    ) {
      final firebaseService = ref.read(firebaseServiceProvider);
      return AnonymousChatNotifier(firebaseService: firebaseService);
    });
