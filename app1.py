from flask import Flask, render_template, request, redirect, url_for, session, flash
import sqlite3
import hashlib
import os
from transformers import pipeline
import vertexai
from vertexai.preview.generative_models import GenerativeModel

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# ---- DB SETUP ----
def init_db():
    conn = sqlite3.connect("users.db")
    c = conn.cursor()
    c.execute('''
        CREATE TABLE IF NOT EXISTS users (
            username TEXT PRIMARY KEY,
            password TEXT
        )
    ''')
    c.execute('''
        CREATE TABLE IF NOT EXISTS chat_requests (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            role_seeking TEXT,
            status TEXT DEFAULT 'pending',
            matched_with TEXT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (username) REFERENCES users(username)
        )
    ''')
    conn.commit()
    conn.close()

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def signup_user(username, password):
    conn = sqlite3.connect("users.db")
    c = conn.cursor()
    try:
        c.execute("INSERT INTO users (username, password) VALUES (?, ?)", (username, hash_password(password)))
        conn.commit()
        return True
    except sqlite3.IntegrityError:
        return False
    finally:
        conn.close()

def login_user(username, password):
    conn = sqlite3.connect("users.db")
    c = conn.cursor()
    c.execute("SELECT password FROM users WHERE username = ?", (username,))
    data = c.fetchone()
    conn.close()
    return data and data[0] == hash_password(password)

# ---- GEMINI SETUP ----
def initialize_vertexai():
    project_id = 'genz-457123'
    location = 'us-central1'
    credential_path = "D:\\Genz\\genz-457123-1a6c1eeaac70.json"
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credential_path
    vertexai.init(project=project_id, location=location)
    return GenerativeModel("gemini-2.0-flash-lite")

def get_bot_response(model, user_input, emotion, role, prompt=None):
    if not prompt:
        prompt = f"""
        The user's message: '{user_input}'
        Their emotional state is: {emotion}
        You are their {role}. Respond accordingly.
        [full context omitted for brevity...]
        """
    response = model.generate_content(prompt)
    return response.text

# ---- FLASK ROUTES ----
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if login_user(username, password):
            session['logged_in'] = True
            session['username'] = username
            session['messages'] = []  # Initialize messages list
            return redirect(url_for('select_role'))  # Redirect to role selection
        else:
            flash('Invalid credentials.')
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        new_username = request.form['new_username']
        new_password = request.form['new_password']
        if signup_user(new_username, new_password):
            flash('Account created! Login to continue.')
            return redirect(url_for('login'))
        else:
            flash('Username already exists.')
    return render_template('signup.html')

@app.route('/select_role', methods=['GET', 'POST'])
def select_role():
    roles = ["Bestfriend", "Brother", "Sister", "Listener"]
    emojis = ["🤗", "👊", "💕", "👂"]
    role_emoji_pairs = zip(roles, emojis)

    model = initialize_vertexai()

    if request.method == 'POST':
        selected_role = request.form.get('role')
        if selected_role in roles:
            # Generate greeting using Gemini
            greeting_prompt = f"Suppose you are a {selected_role} and are catching up with the user. Greet them in {selected_role} style."
            greeting = get_bot_response(model, "", "", selected_role, greeting_prompt)
            session['current_role'] = selected_role
            session['greeting'] = greeting
            session['messages'].append({"role": "assistant", "content": greeting})  # Add greeting to messages
            return redirect(url_for('chat'))

    return render_template('select_role.html', role_emoji_pairs=role_emoji_pairs)

@app.route('/chat', methods=['GET', 'POST'])
def chat():
    if 'logged_in' not in session or not session['logged_in']:
        return redirect(url_for('login'))

    if 'current_role' not in session:
        return redirect(url_for('select_role'))

    model = initialize_vertexai()
    emotionModel = pipeline('text-classification', model='SamLowe/roberta-base-go_emotions')

    if request.method == 'POST':
        user_input = request.form['user_input']
        emotions = emotionModel(user_input)
        emotions_text = ", ".join([f"{e['label']}: {round(e['score'], 2)}" for e in emotions if e['score'] > 0.1])
        role = session.get('current_role', 'Bestfriend')
        response = get_bot_response(model, user_input, emotions_text, role)
        session['messages'].append({"role": "user", "content": user_input})
        session['messages'].append({"role": "assistant", "content": response})

    return render_template('chat.html', messages=session.get('messages', []))

@app.route('/find_peer', methods=['GET', 'POST'])
def find_peer():
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        role_seeking = request.form.get('role_seeking')
        conn = sqlite3.connect("users.db")
        c = conn.cursor()
        
        # Add user's request
        c.execute("INSERT INTO chat_requests (username, role_seeking) VALUES (?, ?)",
                 (session['username'], role_seeking))
        
        # Look for pending matches
        c.execute("""
            SELECT username FROM chat_requests 
            WHERE status = 'pending' 
            AND username != ? 
            AND role_seeking = ?
            ORDER BY created_at ASC LIMIT 1
        """, (session['username'], role_seeking))
        
        match = c.fetchone()
        if match:
            # Match found, update both users' status
            c.execute("UPDATE chat_requests SET status = 'matched', matched_with = ? WHERE username = ?",
                     (match[0], session['username']))
            c.execute("UPDATE chat_requests SET status = 'matched', matched_with = ? WHERE username = ?",
                     (session['username'], match[0]))
            conn.commit()
            return redirect(url_for('peer_chat', peer=match[0]))
        
        conn.commit()
        conn.close()
        flash('Looking for a peer... Please wait.')
        
    return render_template('find_peer.html')

@app.route('/peer_chat/<peer>')
def peer_chat(peer):
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    return render_template('peer_chat.html', peer=peer)

if __name__ == '__main__':
    init_db()
    app.run(debug=True)