import 'package:flutter/material.dart';
import 'package:zunoa/services/gemini_service.dart';

class BotScreen extends StatefulWidget {
  String role;

  BotScreen({super.key, required this.role});

  @override
  _BotScreenState createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _dotAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for dots (typing indicator)
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _dotAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.insert(0, {'sender': 'You', 'message': message});
      _isLoading = true;
    });

    _controller.clear();

    print("Sending message: $message with role: ${widget.role}");

    try {
      final response = await geminiService.generateChatResponse(
        widget.role,
        message,
      );

      print("Received response: $response");

      setState(() {
        if (response.isNotEmpty) {
          _messages.insert(0, {'sender': widget.role, 'message': response});
        } else {
          _messages.insert(0, {
            'sender': widget.role,
            'message': "No response, try again!",
          });
        }
        _isLoading = false;
      });
    } catch (e) {
      print("Error in receiving Gemini response: $e");
      setState(() {
        _messages.insert(0, {'sender': widget.role, 'message': "Error: $e"});
        _isLoading = false;
      });
    }
  }

  void _selectRole() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Role'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  [
                    'Boyfriend',
                    'Girlfriend',
                    'Male Bestie',
                    'Female Bestie',
                    'Brother',
                    'Sister',
                    'Teacher',
                    'Aunt',
                    'Mom',
                    'Dad',
                    'Uncle',
                    'Male Stranger',
                    'Female Stranger',
                  ].map((role) {
                    return ListTile(
                      title: Text(role),
                      onTap: () {
                        setState(() {
                          widget.role = role; // Update the role dynamically
                        });
                        Navigator.pop(context);
                        print("Role selected: $role");
                      },
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }

  // Widget for Typing Indicator with "typing" text, vertically centered
  Widget _buildTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          CrossAxisAlignment.center, // Vertically center the dots and the text
      children: [
        // "Typing" text
        Text(
          'Typing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 10),
        // Dots animation
        Row(
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: FadeTransition(
                opacity: _dotAnimation,
                child: Text(
                  '.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.role}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _selectRole, // Show the role selection dialog
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true, // This ensures the list starts from the bottom
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    child: Row(
                      mainAxisAlignment:
                          message['sender'] == 'You'
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        if (message['sender'] != 'You') ...[
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Text(
                              widget.role.substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  message['sender'] == 'You'
                                      ? Colors.blueAccent
                                      : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['sender']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        message['sender'] == 'You'
                                            ? Colors.white
                                            : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  message['message']!,
                                  style: TextStyle(
                                    color:
                                        message['sender'] == 'You'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  softWrap: true, // Ensure text wraps
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              _buildTypingIndicator(), // Show the typing indicator
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
