#!/data/data/com.termux/files/usr/bin/python

import subprocess
import random
import os
from datetime import datetime

# 🔧 Setup paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
QUOTE_FILE = os.path.join(BASE_DIR, "dailysecrets.txt")
LOG_FILE = os.path.join(BASE_DIR, "universe.log")

# ✅ Check Termux API
def check_termux_api():
    result = subprocess.run(["which", "termux-notification"], capture_output=True)
    if result.returncode != 0:
        print("❌ Termux API not installed. Run: pkg install termux-api")
        exit(1)

# 🧠 Get a random quote
def get_random_quote():
    try:
        with open(QUOTE_FILE, "r") as f:
            quotes = [line.strip() for line in f if line.strip()]
        return random.choice(quotes)
    except:
        return "Keep going. Your future self will thank you."

# ✨ Add flair
def add_flair(quote):
    flair = random.choice(["🌟", "🔥", "🧠", "💭", "📜", "✨", "💡", "🛸"])
    return f"{flair} {quote}"

# 🧘 Dynamic title
def get_dynamic_title():
    return random.choice([
        "💬 Morning Wisdom",
        "🎯 Daily Push",
        "🧘 Focus Mode",
        "⚡ Power Byte",
        "🧠 Mind Spark",
        "🌅 Rise & Grind"
    ])

# 📜 Send notification
def send_notification(message, title):
    subprocess.run([
        "termux-notification",
        "--title", title,
        "--content", message,
        "--priority", "high"
    ])

# 📝 Log event
def log_event(message):
    try:
        with open(LOG_FILE, "a") as log:
            log.write(f"{datetime.now()} - {message}\n")
    except:
        pass

# ➕ Append user secret
def append_to_secrets(secret):
    try:
        with open(QUOTE_FILE, "a") as f:
            f.write(f"{secret}\n")
    except:
        pass

import sys

# 🚀 Main
if __name__ == "__main__":
    check_termux_api()

    if "--silent" in sys.argv:
        quote = get_random_quote()
        message = add_flair(quote)
        title = get_dynamic_title()
        send_notification(message, title)
        log_event(f"Sent silently: {message}")
        exit(0)


    print("\n🌌 Welcome, The Universe Speaks.")
    print("Do You Listen?\n")
    print("(TYPE NO. TO SELECT)")
    print("1. Get a secret from the universe")
    print("2. Add your own secret to the universe")
    print("3. Exit\n")

    choice = input("→ ").strip()

    if choice == "1":
        quote = get_random_quote()
        message = add_flair(quote)
        title = get_dynamic_title()
        send_notification(message, title)
        log_event(f"Sent: {message}")
        print(f"\n✅ Listen... {message}")

    elif choice == "2":
        secret = input("📜 Add your own secret to the universe:\n→ ").strip()
        if secret:
            append_to_secrets(secret)
            log_event(f"User Secret: {secret}")
            print("🌌 Added. Your signal is now part of the system.")
        else:
            print("⚠️ No input. Nothing added.")

    elif choice == "3":
        print("👻 No transmission today. Universe™ remains silent.")
        exit(0)

    else:
        print("❌ Invalid choice. Try again.")
