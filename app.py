from flask import Flask, request, jsonify
from flask_cors import CORS  # Add this import
import os
import vertexai
from vertexai.preview.generative_models import GenerativeModel
from transformers import pipeline

app = Flask(__name__)
CORS(app)  # Enable CORS

# Initialize Vertex AI and emotion model once
def initialize_vertexai():
    project_id = 'genz-457123'
    location = 'us-central1'
    credential_path = "D:\\Genz\\genz-457123-1a6c1eeaac70.json"
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
    vertexai.init(project=project_id, location=location)
    return GenerativeModel("gemini-2.0-flash-lite")

model = initialize_vertexai()
emotionModel = pipeline('text-classification', model='SamLowe/roberta-base-go_emotions')

# Roles and greetings
greetings = {
    "Bestfriend": "Hey bestie! 🤗 Ready for another chat? Tell me what's up!",
    "Brother": "Yo! 👊 Your big bro's here. What's on your mind, sibling?",
    "Sister": "Hey there! 💕 Your sis is here to chat. What's going on with you?",
    "Listener": "Hello! 👋 I'm here to listen and support you. What would you like to share?"
}

def get_bot_response(user_input, emotion, role):
    prompt = f"""
    The user's message: '{user_input}'
    Their emotional state is: {emotion}
    
    You are their {role}. Your personality and response should strictly match this role:

    If you're their Bestfriend:
    - Use casual language and friendly nicknames
    - Share relatable personal experiences
    - Be supportive but not afraid to give honest opinions
    - Use emojis and casual expressions

    If you're their Brother:
    - Be protective and slightly teasing
    - Use "bro" or similar brotherly terms
    - Give practical advice with tough love
    - Share brotherly wisdom and experiences
    - Be protective but encourage independence

    If you're their Sister:
    - Use caring and nurturing language
    - Share sisterly advice and personal experiences
    - Be emotionally supportive and understanding
    - Use gentle guidance and encouragement
    - Mix support with practical solutions

    If you're their Listener:
    - Focus on active listening and validation
    - Ask thoughtful follow-up questions
    - Reflect their feelings back to them
    - Avoid giving unsolicited advice
    - Use phrases like "I hear you" and "That sounds challenging"

    Based on their emotional state ({emotion}), adjust your response to:
    - For positive emotions: Celebrate and amplify their joy
    - For negative emotions: Provide support and understanding
    - For neutral emotions: Engage and show interest

    Remember to maintain your role as their {role} throughout the entire response.
    Respond naturally in a conversational way:
    """

    response = model.generate_content(prompt)
    return response.text

@app.route('/')
@app.route('/api')
def home():
    return jsonify({
        "status": "online",
        "available_roles": list(greetings.keys()),
        "message": "GenZ Flask Chatbot is up and running!"
    })

@app.route('/api/greeting', methods=['POST'])
def get_greeting():
    data = request.get_json()
    role = data.get('role', 'Bestfriend')
    
    if role not in greetings:
        return jsonify({"error": "Invalid role"}), 400
        
    return jsonify({
        "greeting": greetings[role],
        "status": "success"
    })

@app.route("/api/chat", methods=["POST"])
def chat():
    data = request.get_json()

    user_input = data.get("message", "")
    role = data.get("role", "Bestfriend")

    if not user_input or role not in greetings:
        return jsonify({"error": "Invalid input or role"}), 400

    # Emotion Detection
    emotions = emotionModel(user_input)
    significant_emotions = [e for e in emotions if e['score'] > 0.1]
    emotion_text = ", ".join([f"{e['label']}: {round(e['score'], 2)}" for e in significant_emotions])

    # Bot Response
    bot_response = get_bot_response(user_input, emotion_text, role)

    return jsonify({
        "greeting": greetings[role],
        "emotion_detected": emotion_text,
        "bot_response": bot_response
    })

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
