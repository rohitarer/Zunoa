import streamlit as st
import vertexai
from vertexai.preview.generative_models import GenerativeModel
import os
from transformers import pipeline
import tensorflow as tf
import tf_keras

def initialize_vertexai():
    project_id = 'genz-457123'
    location = 'us-central1'
    credential_path = "D:\Genz\genz-457123-1a6c1eeaac70.json"
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
    vertexai.init(project=project_id, location=location)
    return GenerativeModel("gemini-2.0-flash-lite")

def predict_mood(classifier, text):
    results = classifier(text, top_k=None)  # Get all emotions with their scores
    # Filter emotions with significant confidence (e.g., > 0.1)
    emotions = [(result['label'], round(result['score'], 2)) for result in results if result['score'] > 0.1]
    return emotions

def get_bot_response(model, user_input, emotion):
    # Create a context-aware prompt based on detected emotion
    prompt = f"""
    The user's message: '{user_input}'
    Their emotional state is: {emotion}
    
    Respond empathetically, matching their emotional state. If they're:
    - joy: match their enthusiasm
    - sadness: be supportive and understanding
    - anger: be calming and helpful
    - fear: be reassuring
    - love: be warm and friendly
    - surprise: share their excitement
    
    Respond in a natural, conversational way:
    """
    
    response = model.generate_content(prompt)
    return response.text

def main():
    st.title("GenZ Chat Bot")
    
    # Initialize the models
    model = initialize_vertexai()
    emotion_classifier = pipeline("text-classification", 
                                model="j-hartmann/emotion-english-distilroberta-base")
    
    # Initialize chat history and greeting flag
    if "messages" not in st.session_state:
        st.session_state.messages = []
        greeting = "Hello! 👋 I'm your GenZ assistant. How can I help you today?"
        st.session_state.messages.append({"role": "assistant", "content": greeting})

    # Display chat history
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    # Chat input
    if user_input := st.chat_input("What's on your mind?"):
        # Predict emotion using DistilRoBERTa
        emotions = predict_mood(emotion_classifier, user_input)
        print(f"\nDetected Emotions for: '{user_input}'")
        for emotion, score in emotions:
            print(f"- {emotion.upper()}: {score}")
        
        st.session_state.messages.append({"role": "user", "content": user_input})
        with st.chat_message("user"):
            st.markdown(user_input)

        # Get bot response
        with st.chat_message("assistant"):
            emotions_text = ", ".join([f"{emotion}: {score}" for emotion, score in emotions])  # Fixed unpacking
            st.markdown(f"*Detected emotions: {emotions_text}*")
            st.markdown("---")
            bot_response = get_bot_response(model, user_input, emotions_text)
            st.markdown(bot_response)
            
        st.session_state.messages.append({"role": "assistant", "content": bot_response})
        print(f"\nEmotion: {emotions_text}")
        print(f"Bot Response: {bot_response}\n")

if __name__ == "__main__":
    main()