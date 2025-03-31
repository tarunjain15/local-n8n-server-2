#!/bin/bash

# Simple wrapper around the common quality-check.sh script
# Automatically passes the server directory

# Get the server directory (where this script's parent directory is located)
SERVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
COMMON_DIR="$SERVER_DIR/../tools-for-local-servers"

# Call the common script with the server directory
"$COMMON_DIR/quality-check.sh" "$SERVER_DIR"