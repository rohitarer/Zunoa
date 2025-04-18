# Zunoa
Your **GenZ Chat Bot** project is an emotionally intelligent chatbot built using a mix of modern ML, NLP, and web technologies. Here's the full **tech stack**:

---

### 💻 **Frontend & Interface**
- **[Streamlit](https://streamlit.io/)**:  
  Used to build the interactive, real-time chat UI with chat history, markdown support, and user input handling.

---

### 🧠 **Natural Language Processing (NLP) & Emotion Detection**
- **[Hugging Face Transformers](https://huggingface.co/)**:  
  - Model: `j-hartmann/emotion-english-distilroberta-base`  
  - Purpose: Emotion classification using the `pipeline("text-classification")` method.
- **Text Classification Pipeline**: To identify emotions like joy, sadness, anger, fear, love, surprise.

---

### 🤖 **Conversational AI**
- **Google Vertex AI** (via `vertexai` SDK):  
  - Model used: `"gemini-2.0-flash-lite"` from **Generative AI models (preview)**.  
  - Purpose: Generates context-aware, empathetic responses.

---

### 🔒 **Authentication & Cloud Integration**
- **Google Cloud SDK credentials**:  
  - Uses `GOOGLE_APPLICATION_CREDENTIALS` env variable for secure access to Vertex AI.

---

### 🔗 **Miscellaneous / Support Libraries**
- **`os`**: For environment variable management.
- **`tf_keras`** and **`tensorflow`**: Though imported, not actively used in your code snippet (might be legacy or planned future usage).

---

### ✅ Optional: Runtime Environment
- Python 3.9+  
- Hugging Face Transformers >= 4.x  
- Google Cloud SDK  
- Vertex AI Preview SDK  

---

If you'd like, I can suggest optimizations, additions like sentiment graphs, or deploy options!
