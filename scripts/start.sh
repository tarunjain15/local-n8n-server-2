#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."

# Load environment variables
set -a
source .env
set +a

# Start n8n server
echo "Starting n8n server on $N8N_PROTOCOL://$N8N_HOST:$N8N_PORT"
npm run start
