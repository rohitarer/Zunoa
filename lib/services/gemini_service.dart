import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
// Replace with your actual Gemini API key

  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash', // Ensure the correct model is used
      apiKey: _apiKey,
    );
  }

  Future<String> generateChatResponse(String role, String message) async {
    final prompt = _getRolePrompt(role, message);
    print("🔍 Generated prompt for role '$role': $prompt");

    try {
      final content = await _model.generateContent([Content.text(prompt)]);
      print("✅ Content generated: ${content.text}");

      if (content.text != null && content.text!.isNotEmpty) {
        return content.text!;
      } else {
        print("❌ Empty response from Gemini");
        return "🌐 No response received, try again later.";
      }
    } catch (e) {
      print("❌ Error fetching content: $e");
      return "🌐 Couldn't continue conversation, but you're still awesome!";
    }
  }

  String _getRolePrompt(String role, String message) {
    // Main prompt to set the tone for conversation flow
    String mainPrompt =
        "You are a chatbot acting as a $role. Your responses should feel natural, short, and relatable. Keep the tone informal, friendly, and conversational, like you're chatting with a friend. Use simple, real-life language, just like an Indian would speak. Make sure the responses are not too long and feel human, not robotic.";

    switch (role) {
      case 'Boyfriend':
        return "$mainPrompt Respond in a romantic, caring, and lighthearted way to the following message: '$message'. Keep it simple and sweet, no long sentences.";
      case 'Girlfriend':
        return "$mainPrompt Respond lovingly and supportively to this message: '$message'. Keep it short and genuine, like you're talking to someone close.";
      case 'Male Bestie':
        return "$mainPrompt Respond playfully but supportively to your best friend: '$message'. Keep it casual, friendly, and relatable.";
      case 'Female Bestie':
        return "$mainPrompt Respond with warmth, support, and care to your best friend: '$message'. Keep it lighthearted and real.";
      case 'Brother':
        return "$mainPrompt Respond in a protective and caring way, like a brother would: '$message'. Keep it warm and not too serious.";
      case 'Sister':
        return "$mainPrompt Respond lovingly and supportively, like a sister: '$message'. Keep it simple and conversational.";
      case 'Teacher':
        return "$mainPrompt Respond with feedback and encouragement in a clear, short manner: '$message'. Avoid long explanations.";
      case 'Aunt':
        return "$mainPrompt Respond with life advice and humor, like an aunt would: '$message'. Keep it wise but short.";
      case 'Mom':
        return "$mainPrompt Respond with love and care, like a mom would: '$message'. Keep it short, warm, and encouraging.";
      case 'Dad':
        return "$mainPrompt Respond with fatherly advice and support: '$message'. Keep it clear and to the point.";
      case 'Uncle':
        return "$mainPrompt Respond in a fun, playful tone, like a cool uncle: '$message'. Keep it light and fun.";
      case 'Male Stranger':
        return "$mainPrompt Respond casually but respectfully to this message from a male stranger: '$message'. Keep it friendly and not too personal.";
      case 'Female Stranger':
        return "$mainPrompt Respond politely and casually to this message from a female stranger: '$message'. Keep it friendly but respectful.";
      default:
        return "$mainPrompt Respond naturally and kindly to this message: '$message'. Keep the tone conversational and relatable.";
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

//   /// Generates a GenZ styled, meme-worthy, emotionally engaging one-liner or quote
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

//   /// Removes invalid characters to prevent UI rendering issues
//   String _sanitizeContent(String input) {
//     try {
//       // Removes invalid unicode sequences
//       final cleaned = input.replaceAll(RegExp(r'[^ -￿]'), '');
//       return cleaned;
//     } catch (e) {
//       print("⚠️ Sanitize failed: $e");
//       return "💭 Vibe couldn't be rendered.";
//     }
//   }

//   /// Prompts customized for each mood (funny, deep, dark, meme-style)
//   String _getPromptForMood(String mood) {
//     switch (mood) {
//       case "😂 Funny":
//         return "Roast me with a sarcastic but wholesome GenZ one-liner. Add a bit of chaotic humor or GenZ meme references like Shrek, SpongeBob, or Minions.";
//       case "🧘 Calm":
//         return "Create a soft, relatable, aesthetic quote that sounds like a Tumblr post written by a tea-loving introvert.";
//       case "❤️ Romantic":
//         return "Write a poetic pickup line that sounds like it came from a hopeless romantic GenZ watching anime at 2AM.";
//       case "😎 Chill":
//         return "Give a cool, vibey, chill one-liner as if a GenZ skateboarder just tweeted it with sunglasses on.";
//       case "🧠 Think":
//         return "Write a darkly humorous yet insightful quote that sounds like a meme caption but makes you reflect on life. Add a twist ending.";
//       default:
//         return "Write a savage yet wholesome GenZ-style one-liner that sounds like a caption from a viral meme page.";
//     }
//   }
// }

// final geminiService = GeminiService();
