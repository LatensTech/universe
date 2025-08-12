#!/data/data/com.termux/files/usr/bin/bash

echo "🔧 Bootstrapping Potentia Protocol..."
sleep 3
# ✅ Update system
#pkg update -y
#pkg upgrade -y
#pkg install python termux-api cronie -y

echo " 📁 Creating base directories...~/potentia/drops/universe"

# 📁 Create base directories
mkdir -p ~/potentia/drops
mkdir -p ~/potentia/config
mkdir -p ~/potentia/logs
sleep 1
# 📦 Move current folder (drop) into universe drop folder
CURRENT_DIR=$(pwd)
DROP_DEST=~/potentia/drops/universe
sleep 1
# Remove old drop if exists
rm -rf "$DROP_DEST"
mkdir -p "$DROP_DEST"
cp -r "$CURRENT_DIR"/* "$DROP_DEST"

# 📜 Ensure secrets and logs exist
touch "$DROP_DEST/dailysecrets.txt"
touch "$DROP_DEST/universe.log"
touch ~/potentia/logs/potentia.log
sleep 1
echo "🔗 Syncing Hours With The Universe"
sleep 1

# 🧠 Setup cron job (hourly, silent mode)
CRON_ENTRY="0 * * * * python3 $DROP_DEST/universe.py --silent"
(crontab -l 2>/dev/null | grep -v 'universe.py'; echo "$CRON_ENTRY") | crontab -
sleep 1
# ⚙️ Create config file if missing
CONFIG_FILE=~/potentia/config/potentia.env
if [ ! -f "$CONFIG_FILE" ]; then
    echo "# Potentia Protocol Config" > "$CONFIG_FILE"
    echo "UNIVERSE_ENABLED=true" >> "$CONFIG_FILE"
    echo "INSTALL_DATE=$(date)" >> "$CONFIG_FILE"
else
    sed -i "s/UNIVERSE_ENABLED=.*/UNIVERSE_ENABLED=true/" "$CONFIG_FILE"
fi

sleep 1 
echo "🌎 Setting up Universe"
# 🧙 Add shell alias for Universe™
SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
    PROFILE_FILE=~/.zshrc
else
    PROFILE_FILE=~/.bashrc
fi

ALIAS_CMD='alias universe="python3 ~/potentia/drops/universe/universe.py"'
grep -qxF "$ALIAS_CMD" "$PROFILE_FILE" || echo "$ALIAS_CMD" >> "$PROFILE_FILE"

ALIAS_ENTER='alias drops="cd ~/potentia/drops/universe/"'
grep -qxF "$ALIAS_ENTER" "$PROFILE_FILE" || echo "$ALIAS_ENTER" >> "$PROFILE_FILE"

sleep 2
# 🚀 Launch Universe™ for first ritual
echo "✅ Universe™ installed and synced with Potentia Protocol."
echo "🧠 You’ll start receiving encrypted wisdom every hour."
sleep 1
echo "💯 You can Talk to the universe anytime by just typing universe"
echo "✒️ Edit the Universe by typing drops"
sleep 3
echo "🌌 Initiating First Contact with The Universe..."
sleep 2
python3 "$DROP_DEST/universe.py"


