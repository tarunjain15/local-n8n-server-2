#!/bin/bash

# Updated start script that uses the new robust start-n8n.sh script
# instead of calling the common script directly

SERVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
"$SERVER_DIR/start-n8n.sh"
