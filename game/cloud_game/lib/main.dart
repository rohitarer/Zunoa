import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Launcher App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class GameButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String gameUrl;

  const GameButton({
    super.key,
    required this.icon,
    required this.label,
    required this.gameUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameWebView(gameUrl: gameUrl),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 48),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center), // Center the text
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Games'),
      ),
      body: Column( // Use a Column as the main body
        children: <Widget>[
          SingleChildScrollView( // Make the horizontal row scrollable if there are many buttons
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16.0), // Add some padding around the buttons
            child: Row( // Arrange the GameButtons horizontally
              mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the start
              children: const <Widget>[
                GameButton(
                  icon: Icons.directions_run,
                  label: 'Subway Surfers',
                  gameUrl: 'https://poki.com/en/g/subway-surfers',
                ),
                SizedBox(width: 20), // Add horizontal spacing between buttons
                GameButton(
                  icon: Icons.motorcycle,
                  label: 'Stunt Bike Extreme',
                  gameUrl: 'https://poki.com/en/g/stunt-bike-extreme',
                ),
                SizedBox(width: 20),
                GameButton(
                  icon: Icons.psychology,
                  label: 'Brain Test',
                  gameUrl: 'https://poki.com/en/g/brain-test-tricky-puzzles',
                ),
                // Add more GameButton widgets here for your other games with SizedBox for spacing
              ],
            ),
          ),
          const Expanded( // Use Expanded to take up the remaining vertical space for other content if needed
            child: Center(
              child: Text('Other content can go here'), // Placeholder for other UI elements
            ),
          ),
        ],
      ),
    );
  }
}

class GameWebView extends StatefulWidget {
  final String gameUrl;
  const GameWebView({super.key, required this.gameUrl});

  @override
  State<GameWebView> createState() => _GameWebViewState();
}

class _GameWebViewState extends State<GameWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.gameUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'), // You might want to dynamically set the title
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}