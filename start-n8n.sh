#!/bin/bash

# Define the server directory path
SERVER_DIR="/Users/tarun/workspace/home/local-n8n-servers/local-n8n-server-2"

# Change to the server directory
cd "$SERVER_DIR" || {
    echo "Error: Failed to change to server directory: $SERVER_DIR"
    exit 1
}

# Check if n8n is already running by looking for its process
if pgrep -f "n8n start" > /dev/null; then
    echo "n8n is already running. If you want to restart, kill the existing process first."
    echo "You can use: pkill -f \"n8n start\""
    exit 0
}

# Set environment variables from .env if it exists
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Set required paths
export N8N_USER_FOLDER="$SERVER_DIR"
export N8N_DB_SQLITE_PATH="$SERVER_DIR/.n8n/database.sqlite"

# Create custom directory if it doesn't exist
if [ ! -d "$SERVER_DIR/.n8n/custom" ]; then
    mkdir -p "$SERVER_DIR/.n8n/custom"
    echo "Created custom nodes directory: $SERVER_DIR/.n8n/custom"
fi

# Read encryption key from config if it exists
if [ -f "$SERVER_DIR/.n8n/config" ]; then
    ENCRYPTION_KEY=$(grep -o '"encryptionKey": "[^"]*"' "$SERVER_DIR/.n8n/config" | cut -d '"' -f 4)
    if [ ! -z "$ENCRYPTION_KEY" ]; then
        export N8N_ENCRYPTION_KEY="$ENCRYPTION_KEY"
        echo "Using encryption key from config file"
    fi
fi

# Start n8n
echo "Starting n8n server on http://localhost:${N8N_PORT:-5678}"
npx n8n start
