#!/bin/bash

# =====================================
# Hospital Linux Server Updater Script
# =====================================

# Configuration
SERVER_LIST="./servers_list.txt"    # File containing list of servers
LOG_DIR="./logs"                    # Directory where logs will be stored
mkdir -p "$LOG_DIR"                 # Create logs directory if not exists
LOGFILE="$LOG_DIR/update_servers_$(date +%F).log"   # Log file with today's date
USER="adminuser"                     # SSH username

echo "Starting update process at $(date)" | tee -a "$LOGFILE"

# Loop through each server in the list
while IFS= read -r SERVER
do
    # Skip empty lines
    if [ -z "$SERVER" ]; then
        continue
    fi

    echo "Connecting to $SERVER..." | tee -a "$LOGFILE"

    ssh "$USER@$SERVER" bash <<'EOF'
        echo "Updating server..."
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt upgrade -y
        elif command -v yum >/dev/null 2>&1; then
            sudo yum update -y
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf upgrade -y
        else
            echo "Unknown package manager."
            exit 1
        fi
EOF

    # Check if SSH command succeeded
    if [ $? -eq 0 ]; then
        echo "$SERVER updated successfully." | tee -a "$LOGFILE"
    else
        echo "$SERVER update FAILED!" | tee -a "$LOGFILE"
    fi

    echo "Rebooting $SERVER..." | tee -a "$LOGFILE"
    ssh "$USER@$SERVER" "sudo reboot"

done < "$SERVER_LIST"

echo "Update process finished at $(date)" | tee -a "$LOGFILE"
