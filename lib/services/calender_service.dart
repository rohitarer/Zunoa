import 'dart:async';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  calendar.CalendarApi? calendarApi;

  // Google Sign-In flow
  Future<void> signIn() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        print('Google Sign-In failed');
        return;
      }

      final GoogleSignInAuthentication auth = await account.authentication;

      // Authenticate and get credentials using access token only
      final authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken(
            'Bearer',
            auth.accessToken!,
            DateTime.now().add(Duration(hours: 1)),
          ),
          "", // No need to provide refresh token
          [calendar.CalendarApi.calendarScope],
        ),
      );

      // Initialize Calendar API
      calendarApi = calendar.CalendarApi(authClient);
      print('Successfully signed in with Google');
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  // Method to create an appointment (Google Meet link)
  Future<void> createAppointment() async {
    if (calendarApi == null) {
      print('Calendar API not initialized');
      return;
    }

    final event =
        calendar.Event()
          ..summary = 'Appointment with Expert'
          ..start = calendar.EventDateTime(
            dateTime: DateTime.now().add(Duration(minutes: 5)),
            timeZone: 'GMT',
          )
          ..end = calendar.EventDateTime(
            dateTime: DateTime.now().add(Duration(hours: 1)),
            timeZone: 'GMT',
          )
          ..conferenceData = calendar.ConferenceData(
            createRequest: calendar.CreateConferenceRequest(
              requestId: 'sample123',
              conferenceSolutionKey: calendar.ConferenceSolutionKey(
                type: 'hangoutsMeet',
              ),
            ),
          );

    try {
      final createdEvent = await calendarApi!.events.insert(
        event,
        'primary',
        conferenceDataVersion: 1,
      );
      print('Meeting created: ${createdEvent.hangoutLink}');
      // You can now use the Google Meet link (createdEvent.hangoutLink)
    } catch (e) {
      print('Error creating Google Calendar event: $e');
    }
  }
}
