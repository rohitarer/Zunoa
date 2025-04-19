// import 'package:flutter/material.dart';
// import 'package:flutter_web_auth/flutter_web_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ZoomOAuth {
//   final String clientId =
//       'eZefB3a4QwCNRU4y8s2oTg'; // Replace with your Zoom Client ID
//   final String clientSecret =
//       'jQjF6OtApiDprb786kiru1F4EISNaRdl'; // Replace with your Zoom Client Secret
//   final String redirectUri =
//       'YOUR_REDIRECT_URI'; // Replace with your redirect URI

//   Future<void> authenticate(BuildContext context) async {
//     // Zoom's OAuth URL to get the authorization code
//     final url = Uri.parse(
//       'https://zoom.us/oauth/authorize?response_type=code&client_id=$clientId&redirect_uri=$redirectUri',
//     );

//     // Trigger the OAuth flow
//     final result = await FlutterWebAuth.authenticate(
//       url: url.toString(),
//       callbackUrlScheme: 'zoomapp',
//     );

//     // Get the authorization code from the callback URL
//     final code = Uri.parse(result).queryParameters['code'];

//     if (code != null) {
//       final accessToken = await getAccessToken(code);
//       print('Access Token: $accessToken');
//     } else {
//       print('Authorization failed!');
//     }
//   }

//   Future<String> getAccessToken(String code) async {
//     // Exchange the authorization code for an access token
//     final tokenUrl = 'https://zoom.us/oauth/token';
//     final response = await http.post(
//       Uri.parse(tokenUrl),
//       headers: {
//         'Authorization':
//             'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {
//         'grant_type': 'authorization_code',
//         'code': code,
//         'redirect_uri': redirectUri,
//       },
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       return data['access_token'];
//     } else {
//       throw Exception('Failed to get access token');
//     }
//   }
// }
