import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentScreen extends StatelessWidget {
  final Map<String, dynamic> expert;
  final String joinUrl; // Add joinUrl as a parameter

  const AppointmentScreen({
    super.key,
    required this.expert,
    required this.joinUrl,
  }); // Update constructor to accept joinUrl

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointment with ${expert['name']}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your appointment has been scheduled!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Join the meeting using the link below:'),
            SizedBox(height: 20),
            Text(
              joinUrl, // Display the Zoom meeting link
              style: TextStyle(color: Colors.blue),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you can add logic to launch the URL in the browser or Zoom app
                launch(
                  joinUrl,
                ); // Use launch to open the URL (you may need to import a package for it, like url_launcher)
              },
              child: Text('Join Meeting'),
            ),
          ],
        ),
      ),
    );
  }
}
