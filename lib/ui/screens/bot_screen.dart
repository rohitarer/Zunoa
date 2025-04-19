import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zunoa/providers/bot_provider.dart';

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
      await ref.read(botProvider.notifier).sendMessage(msg);
      _inputController.clear();
      _listKey.currentState?.insertItem(
        ref.read(botProvider).messages.length - 1,
        duration: const Duration(milliseconds: 300),
      );
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart'; // For timestamp formatting

// class BotScreen extends StatefulWidget {
//   const BotScreen({super.key});

//   @override
//   State<BotScreen> createState() => _BotScreenState();
// }

// class _BotScreenState extends State<BotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   final List<Map<String, dynamic>> _messages = []; // Modified to hold timestamp
//   String selectedRole = 'Bestfriend';
//   bool _isLoading = false;

//   Future<void> _sendMessage(String message) async {
//     if (message.trim().isEmpty) return;

//     setState(() {
//       _messages.add({
//         "sender": "user",
//         "text": message,
//         "timestamp": DateTime.now().toLocal(),
//       });
//       _isLoading = true;
//     });

//     final response = await http.post(
//       Uri.parse("http://localhost:5000/api/chat"),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"message": message, "role": selectedRole}),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final reply = data["bot_response"];

//       setState(() {
//         _messages.add({
//           "sender": "bot",
//           "text": reply,
//           "timestamp": DateTime.now().toLocal(),
//         });
//       });
//     } else {
//       setState(() {
//         _messages.add({
//           "sender": "bot",
//           "text": "⚠️ Error: Unable to get response.",
//           "timestamp": DateTime.now().toLocal(),
//         });
//       });
//     }

//     setState(() => _isLoading = false);
//     _controller.clear();
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent + 100,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Chatbot"),
//         actions: [
//           DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: selectedRole,
//               dropdownColor: Colors.white,
//               icon: const Icon(Icons.person_outline, color: Colors.white),
//               items:
//                   ["Bestfriend", "Brother", "Sister", "Listener"]
//                       .map(
//                         (role) =>
//                             DropdownMenuItem(value: role, child: Text(role)),
//                       )
//                       .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() => selectedRole = value);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isUser = msg["sender"] == "user";
//                 final timestamp =
//                     msg["timestamp"] != null
//                         ? DateFormat('hh:mm a').format(msg["timestamp"])
//                         : '';

//                 return Container(
//                   alignment:
//                       isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 6,
//                   ),
//                   child: Row(
//                     mainAxisAlignment:
//                         isUser
//                             ? MainAxisAlignment.end
//                             : MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (!isUser)
//                         const CircleAvatar(radius: 16, child: Text("🤖")),
//                       if (!isUser) const SizedBox(width: 8),
//                       Flexible(
//                         child: Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: isUser ? Colors.blue[100] : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(msg["text"] ?? ""),
//                               const SizedBox(height: 4),
//                               Text(
//                                 timestamp,
//                                 style: const TextStyle(
//                                   fontSize: 10,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (isUser) const SizedBox(width: 8),
//                       if (isUser)
//                         const CircleAvatar(radius: 16, child: Text("👨‍🦱")),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (_isLoading) const LinearProgressIndicator(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Type your message...",
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: _sendMessage,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () => _sendMessage(_controller.text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
