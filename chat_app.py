import streamlit as st
import vertexai
from vertexai.preview.generative_models import GenerativeModel
import os
from transformers import pipeline

def initialize_vertexai():
    project_id = 'genz-457123'
    location = 'us-central1'
    credential_path = "D:\Genz\genz-457123-1a6c1eeaac70.json"
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
    vertexai.init(project=project_id, location=location)
    return GenerativeModel("gemini-2.0-flash-lite")

def get_bot_response(model, user_input, emotion, role):
    # Create a context-aware prompt based on detected emotion and role
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

def main():
    st.title("GenZ Chat Bot")
    
    # Initialize the models
    model = initialize_vertexai()
    emotionModel = pipeline('text-classification', model='SamLowe/roberta-base-go_emotions')
    
    # Store the current role in session state
    if "current_role" not in st.session_state:
        st.session_state.current_role = "Bestfriend"
    
    # Role selection
    role = st.sidebar.radio(
        "Choose who you want me to be:",
        ["Bestfriend", "Brother", "Sister", "Listener"],
        index=0
    )
    
    # Role-specific greetings
    greetings = {
        "Bestfriend": "Hey bestie! 🤗 Ready for another chat? Tell me what's up!",
        "Brother": "Yo! 👊 Your big bro's here. What's on your mind, sibling?",
        "Sister": "Hey there! 💕 Your sis is here to chat. What's going on with you?",
        "Listener": "Hello! 👋 I'm here to listen and support you. What would you like to share?"
    }
    
    # Reset chat history when role changes
    if role != st.session_state.current_role:
        st.session_state.messages = []
        st.session_state.messages.append({"role": "assistant", "content": greetings[role]})
        st.session_state.current_role = role
    
    # Initialize chat history if it doesn't exist
    if "messages" not in st.session_state:
        st.session_state.messages = []
        greeting = greetings[role]
        st.session_state.messages.append({"role": "assistant", "content": greeting})

    # Display chat history
    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    # Chat input
    if user_input := st.chat_input("What's on your mind?"):
        # Predict emotion using emotionModel directly
        emotions = emotionModel(user_input)
        print(f"\nDetected Emotions for: '{user_input}'")
        for emotion in emotions:
            print(f"- {emotion['label'].upper()}: {round(emotion['score'], 2)}")
        
        st.session_state.messages.append({"role": "user", "content": user_input})
        with st.chat_message("user"):
            st.markdown(user_input)

        # Get bot response
        with st.chat_message("assistant"):
            # Filter emotions with significant confidence (e.g., > 0.1)
            significant_emotions = [emotion for emotion in emotions if emotion['score'] > 0.1]
            emotions_text = ", ".join([f"{emotion['label']}: {round(emotion['score'], 2)}" for emotion in significant_emotions])
            #st.markdown(f"*Detected emotions: {emotions_text}*")
            #st.markdown("---")
            bot_response = get_bot_response(model, user_input, emotions_text, role)
            st.markdown(bot_response)
            
        st.session_state.messages.append({"role": "assistant", "content": bot_response})
        print(f"\nEmotion: {emotions_text}")
        print(f"Bot Response: {bot_response}\n")

if __name__ == "__main__":
    main()