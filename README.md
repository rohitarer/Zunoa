# Zunoa
A conversational chatbot built with Streamlit, Google Vertex AI (Gemini 2.0), and RoBERTa-based emotion detection. The bot understands your emotions and replies empathetically using GenAI.

Features
Powered by Gemini 2.0 Flash Lite from Google Vertex AI

Emotion detection using SamLowe/roberta-base-go_emotions

Real-time chat interface with Streamlit

Emotion-aware responses: supportive, excited, calming, or joyful

Lightweight and fast for Gen-Z vibes

Requirements
Make sure you have the following installed:

bash
Copy
Edit
pip install streamlit vertexai google-cloud-aiplatform transformers torch
Setup
Google Vertex AI Setup

Create a project on Google Cloud Console

Enable Vertex AI API

Generate a service account key and download the JSON file

Add your credentials

Update the path in your script:

python
Copy
Edit
credential_path = "D:\\Genz\\genz-457123-1a6c1eeaac70.json"
Set project and region

python
Copy
Edit
project_id = 'genz-457123'
location = 'us-central1'
Run the Bot
bash
Copy
Edit
streamlit run app.py
The chatbot will open in your default web browser.

How It Works
User inputs a message

Emotion detection using a RoBERTa-based Hugging Face model

Prompt crafting based on detected emotion

Gemini model responds empathetically

Streamlit renders the interaction like a chat

Technologies Used
Streamlit

Vertex AI (Gemini 2.0 Flash)

Hugging Face Transformers

RoBERTa (go_emotions)

Python

Future Ideas
Add voice input and response

Improve emotion contextual memory

Multilingual support

Emoji-based sentiment indicators
