#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Change to the parent directory (project root)
cd "$SCRIPT_DIR/.."

echo "Running backup from: $(pwd)"

# Create backup directory if it doesn't exist
mkdir -p ./backups

# Check first if we have a local .n8n directory
if [ -d ".n8n" ]; then
  BACKUP_FILE="./backups/n8n-backup-$(date +%Y%m%d-%H%M%S)"
  echo "Creating backup at $BACKUP_FILE"
  cp -r .n8n $BACKUP_FILE
  echo "Backup completed successfully!"
# If not, check if there's one in the user's home directory (default location)
elif [ -d "$HOME/.n8n" ]; then
  BACKUP_FILE="./backups/n8n-backup-$(date +%Y%m%d-%H%M%S)"
  echo "Creating backup of $HOME/.n8n at $BACKUP_FILE"
  cp -r "$HOME/.n8n" $BACKUP_FILE
  echo "Backup completed successfully!"
else
  echo "Warning: No .n8n directory found in project root or home directory. Nothing to backup."
  echo "This is normal if you haven't started n8n yet."
fi
