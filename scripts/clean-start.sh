#!/bin/bash

# Simple wrapper around the common clean-start.sh script
# Automatically passes the server directory and forwards any arguments

# Get the server directory (where this script's parent directory is located)
SERVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
COMMON_DIR="$SERVER_DIR/../n8n-local-server-tools"

# Call the common script with the server directory and pass any additional arguments
"$COMMON_DIR/clean-start.sh" "$SERVER_DIR" "$@"
