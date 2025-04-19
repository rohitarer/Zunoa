// import 'package:flutter/material.dart';
// import 'package:zunoa/core/theme.dart';
// import 'package:zunoa/services/calender_service.dart';
// import 'package:zunoa/ui/screens/appointment_screen.dart';
// import 'package:zunoa/ui/widgets/custom_button.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ExpertDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> expert;

//   const ExpertDetailScreen({super.key, required this.expert});

//   Future<String> createZoomMeeting(String accessToken) async {
//     final url = Uri.parse('https://api.zoom.us/v2/users/me/meetings');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'topic': 'Appointment with Expert',
//         'type': 2, // Scheduled meeting
//         'start_time': '2025-04-19T15:00:00Z', // Example start time
//         'duration': 60, // Duration in minutes
//         'timezone': 'UTC',
//         'agenda': 'Discuss mental health issues',
//         'settings': {
//           'host_video': true,
//           'participant_video': true,
//           'join_before_host': true,
//           'mute_upon_entry': false,
//           'audio':
//               'voip', // 'voip' for internet audio, 'telephony' for phone audio
//           'auto_recording': 'none',
//           'meeting_authentication': false,
//         },
//       }),
//     );

//     if (response.statusCode == 201) {
//       final meetingData = json.decode(response.body);
//       print('Meeting Created Successfully');
//       print('Join URL: ${meetingData['join_url']}'); // Log the Zoom join URL
//       return meetingData['join_url']; // Return the Zoom join URL
//     } else {
//       throw Exception('Failed to create meeting');
//     }
//   }

//   // Function to create Zoom meeting and return the join URL
//   Future<void> _bookAppointment(BuildContext context) async {
//     try {
//       // Create the Zoom meeting and get the join URL
//       final accessToken =
//           'your_zoom_access_token'; // Replace with actual access token
//       final joinUrl = await createZoomMeeting(accessToken);

//       // Navigate to the Appointment screen with the Zoom link
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => AppointmentScreen(
//                 expert: expert,
//                 joinUrl: joinUrl, // Pass the joinUrl here
//               ),
//         ),
//       );

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Appointment booked successfully!")),
//       );
//     } catch (e) {
//       // Show error message if meeting creation fails
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to book appointment: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final availability = expert['availability'] as Map<String, dynamic>;

//     return Scaffold(
//       appBar: AppBar(title: Text(expert['name']), centerTitle: true),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 expert['profileImage'],
//                 width: double.infinity,
//                 height: 220,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               expert['degrees'],
//               style: Theme.of(
//                 context,
//               ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Charges per visit: ₹${expert['price']}",
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: Colors.green.shade700,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             CustomButton(
//               text: "Book Appointment",
//               onPressed: () => _bookAppointment(context), // Pass context here
//               backgroundColor: AppTheme.primaryColor,
//               textColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               borderRadius: 10,
//               width: double.infinity,
//             ),
//             const SizedBox(height: 24),
//             Card(
//               color: Colors.white,
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Experience:",
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       expert['experience'],
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "About:",
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       expert['description'],
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "Availability:",
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     ...availability.entries.map(
//                       (entry) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2),
//                         child: Text(
//                           "${entry.key[0].toUpperCase()}${entry.key.substring(1)}: ${entry.value}",
//                           style: Theme.of(context).textTheme.bodySmall,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/services/calender_service.dart';
import 'package:zunoa/ui/screens/appointment_screen.dart';
import 'package:zunoa/ui/widgets/custom_button.dart';

class ExpertDetailScreen extends StatelessWidget {
  final Map<String, dynamic> expert;

  const ExpertDetailScreen({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    final availability = expert['availability'] as Map<String, dynamic>;

    // Handle the booking action
    void _bookAppointment() async {
      // Attempt to sign in and book the appointment via Google Calendar
      try {
        // Sign in using the GoogleSignIn method and then create the appointment
        await GoogleCalendarService().signIn(); // Trigger Google Sign-In
        final calendarApi = GoogleCalendarService().calendarApi;

        // Create the appointment using Google Calendar API
        await GoogleCalendarService().createAppointment();

        // Show confirmation to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Appointment booked successfully!")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to book appointment: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(expert['name']), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                expert['profileImage'],
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              expert['degrees'],
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Charges per visit: ₹${expert['price']}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Book Appointment",
              onPressed: _bookAppointment, // Call the function on button press
              backgroundColor: AppTheme.primaryColor,
              textColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              borderRadius: 10,
              width: double.infinity,
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Experience:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expert['experience'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "About:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expert['description'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Availability:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...availability.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "${entry.key[0].toUpperCase()}${entry.key.substring(1)}: ${entry.value}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
