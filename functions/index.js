// File: functions/index.js

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { HttpsError } = require("firebase-functions/lib/providers/https");
const { pipeline } = require("@xenova/transformers");
const { GoogleGenerativeAI } = require("@google/generative-ai");

admin.initializeApp();

// Initialize Vertex AI Gemini API
const genAI = new GoogleGenerativeAI("YOUR_API_KEY");
const gemini = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

// Initialize HuggingFace Emotion Model (Simulated via pipeline)
const emotionModel = pipeline("text-classification", "Xenova/roberta-base-go_emotions");

// Role-based greetings
const greetings = {
  Bestfriend: "Hey bestie! 🤗 Ready for another chat? Tell me what's up!",
  Brother: "Yo! 👊 Your big bro's here. What's on your mind, sibling?",
  Sister: "Hey there! 💕 Your sis is here to chat. What's going on with you?",
  Listener: "Hello! 👋 I'm here to listen and support you. What would you like to share?",
};

exports.chatbot = functions.https.onRequest(async (req, res) => {
  try {
    const { message, role = "Bestfriend" } = req.body;
    if (!message || !greetings[role]) {
      throw new HttpsError("invalid-argument", "Invalid message or role.");
    }

    // Detect emotions
    const emotions = await emotionModel(message);
    const filtered = emotions.filter((e) => e.score > 0.1);
    const emotionText = filtered.map((e) => `${e.label}: ${e.score.toFixed(2)}`).join(", ");

    // Create prompt for Gemini
    const prompt = `The user's message: '${message}'\nTheir emotional state is: ${emotionText}\nYou are their ${role}. Respond with empathy and relevance.`;

    const result = await gemini.generateContentStream({ contents: [{ role: "user", parts: [{ text: prompt }] }] });
    const response = await result.response;
    const botReply = response.text();

    return res.status(200).json({
      greeting: greetings[role],
      emotion_detected: emotionText,
      bot_response: botReply,
    });
  } catch (error) {
    console.error("🔥 Chatbot error:", error);
    return res.status(500).json({ error: error.message || "Unknown error" });
  }
});
