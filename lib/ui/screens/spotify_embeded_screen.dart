import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // ✅ Required for Android-specific implementation

class SpotifyEmbedScreen extends StatefulWidget {
  const SpotifyEmbedScreen({super.key});

  @override
  State<SpotifyEmbedScreen> createState() => _SpotifyEmbedScreenState();
}

class _SpotifyEmbedScreenState extends State<SpotifyEmbedScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // ✅ Correct way to set the Android platform
    final PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    _controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              'https://open.spotify.com/embed/track/4u2kqfkbKl1lxBhLRMbDA4',
            ),
          );

    // Optional: Add platform-specific settings
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎧 Spotify Mood Track"),
        backgroundColor: Colors.green[700],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
