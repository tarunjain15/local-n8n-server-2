#!/bin/bash

# Simple wrapper around the common custom-nodes.sh script
# Automatically passes the server directory

# Get the server directory (where this script's parent directory is located)
SERVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
COMMON_DIR="$SERVER_DIR/../tools-for-local-servers"

# Call the common script with the server directory and pass all other arguments
"$COMMON_DIR/custom-nodes.sh" "$SERVER_DIR" "$@"