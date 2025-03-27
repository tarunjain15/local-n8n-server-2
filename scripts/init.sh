#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."

echo "Initializing local n8n server setup..."
echo "Working directory: $(pwd)"

# Create data directory
echo "Creating n8n data directory..."
mkdir -p .n8n

# Install dependencies
echo "Installing dependencies..."
npm install

# Generate random encryption key if not set
if grep -q "your-random-encryption-key-for-server-2" .env; then
  RANDOM_KEY=$(openssl rand -hex 16)
  sed -i '' "s/your-random-encryption-key-for-server-2/$RANDOM_KEY/" .env
  echo "Generated random encryption key"
fi

echo "Setup completed successfully!"
echo "You can now start the server with: ./n8n.sh start"
