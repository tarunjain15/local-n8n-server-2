#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."
PROJECT_ROOT="$(pwd)"

echo "WARNING: This will delete all your n8n data."
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Creating backup before reset..."
    "$SCRIPT_DIR/backup.sh"
    
    echo "Removing n8n data directory..."
    rm -rf "$PROJECT_ROOT/.n8n"
    
    echo "Reset completed!"
else
    echo "Reset cancelled."
fi
