#!/bin/bash

# Simple wrapper around the common manage-nodes.sh script
# Automatically passes the server directory and forwards command and arguments

# Get the server directory (where this script's parent directory is located)
SERVER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
COMMON_DIR="$SERVER_DIR/../tools-for-local-servers"

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <command> [options]"
  echo "Commands: list, link, unlink, check"
  echo "For more details, run: $0 help"
  exit 1
fi

# Get the command from first argument
COMMAND="$1"
shift

# Pass command, arguments and server directory
if [ "$COMMAND" = "list" ]; then
  "$COMMON_DIR/manage-nodes.sh" list "$SERVER_DIR"
elif [ "$COMMAND" = "link" ] || [ "$COMMAND" = "unlink" ] || [ "$COMMAND" = "check" ]; then
  # Node directory is required for these commands
  if [ -z "$1" ]; then
    echo "Error: No node directory specified."
    echo "Usage: $0 $COMMAND <node_dir>"
    exit 1
  fi
  "$COMMON_DIR/manage-nodes.sh" "$COMMAND" "$@" "$SERVER_DIR"
else
  "$COMMON_DIR/manage-nodes.sh" "$COMMAND" "$@"
fi