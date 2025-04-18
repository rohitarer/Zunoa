// import 'package:groq/groq.dart';

// class GroqService {
//   late Groq _client;
//   bool _initialized = false;

//   Future<void> init(String apiKey) async {
//     if (_initialized) return;

//     try {
//       _client = Groq(
//         apiKey: apiKey,
//         model: "meta-llama/llama-4-scout-17b-16e-instruct",
//       );

//       _client.startChat(); // 🔄 No await here
//       _client.setCustomInstructionsWith(
//         "You are a witty AI that creates short, mood-based memes and quotes for GenZ. Respond concisely and creatively.",
//       );

//       _initialized = true;
//       print('✅ GroqService initialized successfully.');
//     } catch (e) {
//       print('💥 Groq init error: $e');
//     }
//   }

//   Future<String> generateText(String prompt) async {
//     try {
//       final response = await _client.sendMessage(prompt);
//       return response.choices.first.message.content.trim();
//     } catch (e) {
//       print("💥 Groq error: $e");
//       return "Oops! Couldn't load a vibe right now.";
//     }
//   }

//   String getPromptForMood(String mood) {
//     switch (mood) {
//       case "😂 Funny":
//         return "Give me a hilarious one-liner meme about life with a GenZ tone.";
//       case "🧘 Calm":
//         return "Write a short, peaceful affirmation for anxiety relief.";
//       case "❤️ Romantic":
//         return "Create a poetic and romantic one-liner that sounds modern.";
//       case "😎 Chill":
//         return "Generate a cool, breezy quote to vibe with GenZ energy.";
//       case "🧠 Think":
//         return "Make a deep, reflective quote that feels wise yet relatable.";
//       default:
//         return "Write a fun one-liner for emotional well-being.";
//     }
//   }
// }

// final groqService = GroqService();
