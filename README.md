Chat Bot is a conversational AI built with Streamlit, Google Vertex AI (Gemini 2.0 Flash), and a RoBERTa-based emotion detection model. It simulates different social roles (Bestfriend, Brother, Sister, Listener) and replies empathetically based on the detected emotional tone of the user's message.

Features
Real-time chat interface with a role-based personality

Emotion detection using SamLowe/roberta-base-go_emotions

Empathetic responses generated by Google Vertex AI (Gemini 2.0 Flash Lite)

Different conversational tones for each role (Bestfriend, Brother, Sister, Listener)

Requirements
Install the following packages:

bash
Copy
Edit
pip install streamlit vertexai google-cloud-aiplatform transformers torch
Setup Instructions
Google Cloud Setup

Create a Google Cloud project

Enable the Vertex AI API

Create a service account and download the JSON key file

Configure Environment in Code
Update the credential_path in your initialize_vertexai function:

python
Copy
Edit
credential_path = "D:\\Genz\\genz-457123-1a6c1eeaac70.json"
Also, ensure the project_id and location are correct:

python
Copy
Edit
project_id = 'genz-457123'
location = 'us-central1'
Running the App
Run the application using:

bash
Copy
Edit
streamlit run app.py
It will launch the chatbot in your default web browser.

Role Options
When interacting with the bot, choose the desired role from the sidebar:

Bestfriend: Casual, friendly tone

Brother: Protective, teasing, practical advice

Sister: Caring, emotionally supportive

Listener: Reflective, validating, non-judgmental

Each role adjusts the tone and content of responses accordingly.

How It Works
User types a message

The emotion detection model identifies the emotional state

A prompt is dynamically crafted based on emotion and selected role

Gemini 2.0 Flash Lite generates a role-aligned, empathetic response

Streamlit displays the conversation in chat format

Technologies Used
Streamlit

Google Vertex AI (GenerativeModel)

Hugging Face Transformers

Python

RoBERTa (Go Emotions Model)
