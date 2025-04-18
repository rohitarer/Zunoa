import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/core/theme.dart';
import 'package:zunoa/providers/explore_provider.dart';
import 'package:zunoa/ui/screens/chats_screen.dart';
import 'package:zunoa/ui/screens/spotify_embeded_screen.dart';
import 'package:zunoa/ui/screens/youtube_embeded_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Zunoa"),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat), // Chat Icon
            onPressed: () {
              // Navigate to the Chat Screen when the chat icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: exploreState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (e, _) => Center(
                child: Text(
                  '⚠️ Failed to load content:\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          data: (cards) {
            return ListView.builder(
              itemCount: 10000,
              itemBuilder: (context, index) => cards[index % cards.length],
            );
          },
        ),
      ),
      floatingActionButton: PopupMenuButton<String>(
        icon: const Icon(Icons.music_note, color: Colors.white),
        color: Colors.white,
        onSelected: (value) {
          // Debug print when an option is selected
          print("Selected option: $value");

          if (value == 'YouTube') {
            // Debug print to ensure YouTube menu item is selected
            print("Navigating to YouTube Embed Screen");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const YouTubeEmbedScreen()),
            );
          } else if (value == 'Spotify') {
            // Debug print to ensure Spotify menu item is selected
            print("Navigating to Spotify Embed Screen");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SpotifyEmbedScreen()),
            );
          }
        },
        itemBuilder:
            (context) => [
              const PopupMenuItem(
                value: 'YouTube',
                child: ListTile(
                  leading: Icon(Icons.ondemand_video),
                  title: Text("YouTube Clip"),
                ),
              ),
              const PopupMenuItem(
                value: 'Spotify',
                child: ListTile(
                  leading: Icon(Icons.library_music),
                  title: Text("Spotify Song"),
                ),
              ),
            ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:zunoa/core/theme.dart';
// import 'package:zunoa/providers/explore_provider.dart';

// class ExploreScreen extends ConsumerWidget {
//   const ExploreScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final exploreState = ref.watch(exploreProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Explore"),
//         backgroundColor: AppTheme.primaryColor,
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//           Expanded(
//             child: exploreState.when(
//               data:
//                   (cards) => ListView.builder(
//                     itemBuilder:
//                         (context, index) => cards[index % cards.length],
//                   ),
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error:
//                   (e, _) => Center(child: Text('Failed to load content: $e')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
