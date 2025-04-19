from flask import Flask, jsonify, request
from flask_cors import CORS
import os
from dotenv import load_dotenv
import vertexai
from vertexai.preview.generative_models import GenerativeModel
from transformers import pipeline

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Initialize Vertex AI
vertexai.init(
    project=os.getenv("VERTEX_PROJECT_ID", "genz-457123"),
    location=os.getenv("VERTEX_LOCATION", "us-central1")
)
model = GenerativeModel("gemini-2.0-flash-lite")

# Emotion detection model (force PyTorch)
emotion_model = pipeline(
    'text-classification',
    model='SamLowe/roberta-base-go_emotions',
    framework='pt'
)

# Role-based greetings
greetings = {
    "Bestfriend": "Hey bestie! 🤗 Ready for another chat? Tell me what's up!",
    "Brother": "Yo! 👊 Your big bro's here. What's on your mind, sibling?",
    "Sister": "Hey there! 💕 Your sis is here to chat. What's going on with you?",
    "Listener": "Hello! 👋 I'm here to listen and support you. What would you like to share?"
}

# Health check endpoint
@app.route("/", methods=["GET"])
def health():
    return jsonify({
        "status": "healthy",
        "vertex_ai": "ready",
        "emotion_model": "ready"
    }), 200

# Greeting endpoint
@app.route("/greet", methods=["POST"])
def greeting():
    data = request.get_json(silent=True)
    role = data.get("role", "Bestfriend")

    if role not in greetings:
        return jsonify({"error": "Invalid role"}), 400

    return jsonify({"greeting": greetings[role]}), 200

# Chat handler endpoint
@app.route("/chat", methods=["POST"])
def chat():
    data = request.get_json(silent=True)
    message = data.get("message")
    role = data.get("role", "Bestfriend")

    if not message or role not in greetings:
        return jsonify({"error": "Invalid input"}), 400

    emotions = emotion_model(message)
    emotion_text = ", ".join([f"{e['label']}: {round(e['score'], 2)}" for e in emotions if e['score'] > 0.1])

    prompt = f"""
    The user's message: '{message}'
    Their emotional state is: {emotion_text}

    You are their {role}. Your personality and response should strictly match this role...
    Respond naturally:
    """

    response = model.generate_content(prompt)

    return jsonify({
        "bot_response": response.text,
        "emotion_detected": emotion_text,
        "greeting": greetings[role]
    })

# Required for gunicorn entry
if __name__ == "__main__":
    app.run(debug=True)




# # functions/main.py (Firebase Cloud Function replacing Flask backend)

# import functions_framework
# from flask import jsonify, request
# import os
# import vertexai
# from vertexai.preview.generative_models import GenerativeModel
# from transformers import pipeline
# from flask_cors import cross_origin
# from dotenv import load_dotenv

# # Load .env if running locally
# load_dotenv()

# # Initialize Vertex AI
# vertexai.init(project=os.getenv("VERTEX_PROJECT_ID", "genz-457123"),
#               location=os.getenv("VERTEX_LOCATION", "us-central1"))
# model = GenerativeModel("gemini-2.0-flash-lite")
# # emotion_model = pipeline('text-classification', model='SamLowe/roberta-base-go_emotions')
# emotion_model = pipeline(
#     'text-classification',
#     model='SamLowe/roberta-base-go_emotions',
#     framework='pt'  # Explicitly force PyTorch
# )


# greetings = {
#     "Bestfriend": "Hey bestie! 🤗 Ready for another chat? Tell me what's up!",
#     "Brother": "Yo! 👊 Your big bro's here. What's on your mind, sibling?",
#     "Sister": "Hey there! 💕 Your sis is here to chat. What's going on with you?",
#     "Listener": "Hello! 👋 I'm here to listen and support you. What would you like to share?"
# }

# # Cloud Function Entry: Health check
# @functions_framework.http
# @cross_origin()
# def health(request):
#     return jsonify({
#         "status": "healthy",
#         "vertex_ai": "ready",
#         "emotion_model": "ready"
#     }), 200

# # Cloud Function Entry: Greeting
# @functions_framework.http
# @cross_origin()
# def greeting(request):
#     data = request.get_json(silent=True)
#     role = data.get("role", "Bestfriend")
    
#     if role not in greetings:
#         return jsonify({"error": "Invalid role"}), 400

#     return jsonify({"greeting": greetings[role]}), 200

# # Cloud Function Entry: Chat handler
# @functions_framework.http
# @cross_origin()
# def chat(request):
#     data = request.get_json(silent=True)
#     message = data.get("message")
#     role = data.get("role", "Bestfriend")

#     if not message or role not in greetings:
#         return jsonify({"error": "Invalid input"}), 400

#     # Detect emotion
#     emotions = emotion_model(message)
#     emotion_text = ", ".join([f"{e['label']}: {round(e['score'], 2)}" for e in emotions if e['score'] > 0.1])

#     # Construct prompt
#     prompt = f"""
#     The user's message: '{message}'
#     Their emotional state is: {emotion_text}

#     You are their {role}. Your personality and response should strictly match this role...
#     Respond naturally:
#     """

#     response = model.generate_content(prompt)
#     return jsonify({
#         "bot_response": response.text,
#         "emotion_detected": emotion_text,
#         "greeting": greetings[role]
#     })



# # # app.py - Main application entry point
# # from flask import Flask
# # from flask_jwt_extended import JWTManager
# # from flask_cors import CORS
# # import firebase_admin
# # from firebase_admin import credentials
# # import os
# # from dotenv import load_dotenv
# # from app.routes import auth_routes, chat_routes, peer_routes

# # # Load environment variables
# # load_dotenv()

# # def create_app():
# #     # Initialize Flask application
# #     app = Flask(__name__)
    
# #     # Configure CORS
# #     CORS(app, resources={r"/*": {"origins": "*"}})
    
# #     # Application configuration
# #     app.config.update({
# #         "JWT_SECRET_KEY": os.getenv("JWT_SECRET_KEY"),
# #         "GEMINI_MODEL": "gemini-2.0-flash-lite",
# #         "FIREBASE_CREDENTIALS": os.path.join(
# #             os.path.dirname(__file__), 
# #             'app/firebase/serviceAccountKey.json'
# #         )
# #     })
    
# #     # Initialize Firebase
# #     try:
# #         cred = credentials.Certificate(app.config["FIREBASE_CREDENTIALS"])
# #         firebase_admin.initialize_app(cred)
# #     except Exception as e:
# #         print(f"Error initializing Firebase: {str(e)}")
# #         exit(1)
        
# #     # Initialize JWT
# #     jwt = JWTManager(app)
    
# #     # Register blueprints
# #     app.register_blueprint(auth_routes.auth_bp)
# #     app.register_blueprint(chat_routes.chat_bp)
# #     app.register_blueprint(peer_routes.peer_bp)
    
# #     # Basic health check endpoint
# #     @app.route('/health')
# #     def health_check():
# #         return jsonify({"status": "healthy", "service": "genz-chat-api"}), 200

# #     return app

# # if __name__ == '__main__':
# #     app = create_app()
# #     app.run(
# #         host=os.getenv("FLASK_HOST", "0.0.0.0"),
# #         port=int(os.getenv("FLASK_PORT", 5000)),
# #         debug=os.getenv("FLASK_DEBUG", "false").lower() == "true"
# #     )