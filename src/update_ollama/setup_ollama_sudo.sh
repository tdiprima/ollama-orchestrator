#!/bin/bash
# ============================================================
# setup_ollama_sudo.sh - One-time setup (run this manually)
#
# What it does:
#   1. Lets YOUR user run update_ollama with sudo, no password
#   2. Installs a cron job: Mon/Wed/Fri at 15:00
#
# Security notes:
#   - Only YOUR user can run the ONE specific script
#   - No passwords stored anywhere
#   - sudoers file is validated before saving
# ============================================================

set -euo pipefail

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPDATE_SCRIPT="$SCRIPT_DIR/update_ollama"
SUDOERS_FILE="/etc/sudoers.d/99-update-ollama"
CRON_SCHEDULE="0 15 * * 1,3,5"   # 15:00 on Mon, Wed, Fri

# --- Step 1: Make the update script executable ---
echo "Making update_ollama executable..."
chmod +x "$UPDATE_SCRIPT"

# --- Step 2: Set up passwordless sudo for JUST this script ---
echo "Configuring sudoers for $USER..."

# Create a temp file, validate it, then install it
TMPFILE=$(mktemp)
echo "$USER ALL=(ALL) NOPASSWD: $UPDATE_SCRIPT" > "$TMPFILE"

# visudo --check validates the syntax before we install it
if sudo visudo --check --file="$TMPFILE" 2>/dev/null; then
    sudo cp "$TMPFILE" "$SUDOERS_FILE"
    sudo chmod 440 "$SUDOERS_FILE"
    sudo chown root:root "$SUDOERS_FILE"
    echo "Sudoers entry installed."
else
    echo "ERROR: sudoers syntax check failed. Aborting."
    rm "$TMPFILE"
    exit 1
fi
rm "$TMPFILE"

# --- Step 3: Install the cron job ---
echo "Installing cron job..."

CRON_CMD="sudo $UPDATE_SCRIPT >> /var/log/update_ollama.log 2>&1"
CRON_LINE="$CRON_SCHEDULE $CRON_CMD"

# Save existing crontab (minus any old update_ollama lines) to a temp file
CRON_TMP=$(mktemp)
crontab -l 2>/dev/null | grep -v "update_ollama" > "$CRON_TMP" || true

# Append the new line
echo "$CRON_LINE" >> "$CRON_TMP"

# Install it
crontab "$CRON_TMP"
rm "$CRON_TMP"

# Verify it took
if crontab -l 2>/dev/null | grep -q "update_ollama"; then
    echo "Cron job installed successfully."
else
    echo "ERROR: Cron job was not installed. Check crontab manually."
    exit 1
fi

echo ""
echo "========================================="
echo " Setup complete!"
echo "========================================="
echo ""
echo " Sudoers: $USER can run $UPDATE_SCRIPT as root (no password)"
echo " Cron:    $CRON_SCHEDULE  (Mon/Wed/Fri at 15:00)"
echo " Log:     /var/log/update_ollama.log"
echo ""
echo " Test it now with:  sudo $UPDATE_SCRIPT"
echo ""
