import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeEmbedScreen extends StatefulWidget {
  const YouTubeEmbedScreen({super.key});

  @override
  State<YouTubeEmbedScreen> createState() => _YouTubeEmbedScreenState();
}

class _YouTubeEmbedScreenState extends State<YouTubeEmbedScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    const videoUrl =
        'https://www.youtube.com/watch?v=5qap5aO4i9A'; // Lofi live stream
    final videoId = YoutubePlayer.convertUrlToId(videoUrl)!;

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        showLiveFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
      ),
      builder:
          (context, player) => Scaffold(
            appBar: AppBar(
              title: const Text("🎬 Chill Vibes on YouTube"),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                player,
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Enjoy a curated YouTube mood clip 🎶",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
