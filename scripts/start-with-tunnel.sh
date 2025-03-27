#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."

# Load environment variables
set -a
source .env
set +a

# Start n8n server with tunnel
echo "Starting n8n server with tunnel access"
npm run start-with-tunnel
