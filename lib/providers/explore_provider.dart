import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zunoa/services/gemini_service.dart';
import 'package:zunoa/ui/widgets/vibe_card.dart';
import 'package:zunoa/ui/widgets/vibe_meme_card.dart';
import 'package:zunoa/ui/widgets/mood_affirmation_card.dart';

final exploreProvider = FutureProvider.autoDispose<List<Widget>>((ref) async {
  final moods = ["😂 Funny", "🧘 Calm", "❤️ Romantic", "😎 Chill", "🧠 Think"];

  final List<Widget> cards = [];

  for (final mood in moods) {
    try {
      final vibeLine = await geminiService.generateVibeLine(mood);

      // VibeCard
      cards.add(VibeCard(mood: mood, emoji: _emojiMap[mood] ?? "✨"));

      // MoodAffirmationCard
      cards.add(MoodAffirmationCard(moodTag: mood));

      // VibeMemeCard
      cards.add(
        VibeMemeCard(
          mood: mood,
          imageUrl: "https://picsum.photos/seed/${mood.hashCode}/400/200",
          preloadedCaption: vibeLine,
        ),
      );
    } catch (e) {
      cards.add(
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text("⚠️ Failed to load vibe for $mood.\n$e"),
          ),
        ),
      );
    }
  }

  return cards;
});

// Emoji mapping for moods
const Map<String, String> _emojiMap = {
  "😂 Funny": "😂",
  "🧘 Calm": "🧘",
  "❤️ Romantic": "❤️",
  "😎 Chill": "😎",
  "🧠 Think": "🧠",
};
