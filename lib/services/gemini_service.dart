import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String _apiKey =
      'AIzaSyAkoo0CqAAtM6jGmvbbUP3fzYfWQu77zfk'; // Replace with your valid Gemini API key

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'models/gemini-1.5-flash', // ✅ Updated to valid model
      apiKey: _apiKey,
    );
  }

  /// Generates a GenZ styled, meme-worthy, emotionally engaging one-liner or quote
  Future<String> generateVibeLine(String mood) async {
    final prompt = _getPromptForMood(mood);
    print("🔍 Generated prompt for mood '$mood': $prompt");

    try {
      final content = await _model.generateContent([Content.text(prompt)]);
      final response =
          content.text ?? "You're doing great, don't forget that ✨";
      final clean = _sanitizeContent(response);
      print("✅ Gemini response: $clean");
      return clean;
    } catch (e) {
      print("❌ Error fetching content: $e");
      return "🌐 Couldn't fetch vibe, but you're still awesome!";
    }
  }

  /// Removes invalid characters to prevent UI rendering issues
  String _sanitizeContent(String input) {
    try {
      // Removes invalid unicode sequences
      final cleaned = input.replaceAll(RegExp(r'[^ -￿]'), '');
      return cleaned;
    } catch (e) {
      print("⚠️ Sanitize failed: $e");
      return "💭 Vibe couldn't be rendered.";
    }
  }

  /// Prompts customized for each mood (funny, deep, dark, meme-style)
  String _getPromptForMood(String mood) {
    switch (mood) {
      case "😂 Funny":
        return "Roast me with a sarcastic but wholesome GenZ one-liner. Add a bit of chaotic humor or GenZ meme references like Shrek, SpongeBob, or Minions.";
      case "🧘 Calm":
        return "Create a soft, relatable, aesthetic quote that sounds like a Tumblr post written by a tea-loving introvert.";
      case "❤️ Romantic":
        return "Write a poetic pickup line that sounds like it came from a hopeless romantic GenZ watching anime at 2AM.";
      case "😎 Chill":
        return "Give a cool, vibey, chill one-liner as if a GenZ skateboarder just tweeted it with sunglasses on.";
      case "🧠 Think":
        return "Write a darkly humorous yet insightful quote that sounds like a meme caption but makes you reflect on life. Add a twist ending.";
      default:
        return "Write a savage yet wholesome GenZ-style one-liner that sounds like a caption from a viral meme page.";
    }
  }
}

final geminiService = GeminiService();

// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   final String _apiKey =
//       'AIzaSyAkoo0CqAAtM6jGmvbbUP3fzYfWQu77zfk'; // Replace with your valid Gemini API key

//   late final GenerativeModel _model;

//   GeminiService() {
//     _model = GenerativeModel(
//       model: 'models/gemini-1.5-flash', // ✅ Updated to valid model
//       apiKey: _apiKey,
//     );
//   }

//   /// Generates an emotionally uplifting line based on the given mood
//   Future<String> generateVibeLine(String mood) async {
//     final prompt = _getPromptForMood(mood);
//     print("🔍 Generated prompt for mood '$mood': $prompt");

//     try {
//       final content = await _model.generateContent([Content.text(prompt)]);
//       final response =
//           content.text ?? "You're doing great, don't forget that ✨";
//       final clean = _sanitizeContent(response);
//       print("✅ Gemini response: $clean");
//       return clean;
//     } catch (e) {
//       print("❌ Error fetching content: $e");
//       return "🌐 Couldn't fetch vibe, but you're still awesome!";
//     }
//   }

//   /// Cleans up any unexpected characters to prevent rendering issues
//   String _sanitizeContent(String input) {
//     try {
//       // Remove invalid Unicode characters (e.g., unpaired surrogates)
//       final cleaned = input.replaceAll(RegExp(r'[^\u0000-\uFFFF]'), '');
//       return cleaned;
//     } catch (e) {
//       print("⚠️ Sanitize failed: $e");
//       return "💭 Vibe couldn't be rendered.";
//     }
//   }

//   /// Generates a prompt string based on mood
//   String _getPromptForMood(String mood) {
//     switch (mood) {
//       case "😂 Funny":
//         return "Generate an emotionally uplifting one-liner in a humorous tone for GenZ.";
//       case "🧘 Calm":
//         return "Give me a calming 3-line quote for someone feeling anxious.";
//       case "❤️ Romantic":
//         return "Write a romantic poetic one-liner as a pickup line.";
//       case "😎 Chill":
//         return "Give a cool, confident one-liner to boost someone’s vibe.";
//       case "🧠 Think":
//         return "Write a deep, emotional quote that inspires self-reflection.";
//       default:
//         return "Write an emotionally supportive one-liner.";
//     }
//   }
// }

// final geminiService = GeminiService();
