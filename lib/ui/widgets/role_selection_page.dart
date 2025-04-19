import 'package:flutter/material.dart';
import 'package:zunoa/ui/screens/bot_screen.dart';

class RoleSelectionPage extends StatelessWidget {
  final List<String> roles = [
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
  ];

  RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(roles[index]),
            onTap: () {
              // Navigate to Chat Screen with the selected role
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BotScreen(role: roles[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
