#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."

echo "Cleaning n8n cache and rebuilding..."
echo "Working directory: $(pwd)"

# Stop any running n8n processes
echo "Stopping any running n8n processes..."
pkill -f "n8n" || true

# Remove cache folders
echo "Removing cache folders..."
if [ -d "node_modules/.cache" ]; then
  rm -rf node_modules/.cache
fi
if [ -d "node_modules/.vite" ]; then
  rm -rf node_modules/.vite
fi
if [ -d ".n8n/cache" ]; then
  rm -rf .n8n/cache
fi
if [ -d ".n8n/tmp" ]; then
  rm -rf .n8n/tmp
fi

# Optional: remove node_modules completely for a full clean install
read -p "Do you want to perform a full clean install (delete node_modules)? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Removing node_modules..."
    rm -rf node_modules
    echo "Reinstalling dependencies..."
    npm install
else
    echo "Skipping node_modules removal."
fi

echo "Clean rebuild completed!"
echo "You can now start the server with: ./n8n.sh start"
