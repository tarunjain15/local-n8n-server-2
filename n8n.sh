#!/bin/bash

# Wrapper script for n8n server management
# Usage: ./n8n.sh [command]
#   where command is one of: start, tunnel, backup, reset, clean, init

COMMAND=${1:-help}

case "$COMMAND" in
  start)
    ./scripts/start.sh
    ;;
  tunnel)
    ./scripts/start-with-tunnel.sh
    ;;
  backup)
    ./scripts/backup.sh
    ;;
  reset)
    ./scripts/reset.sh
    ;;
  clean)
    ./scripts/clean-rebuild.sh
    ;;
  init)
    ./scripts/init.sh
    ;;
  help|*)
    echo "Usage: ./n8n.sh [command]"
    echo "Commands:"
    echo "  start   - Start the n8n server"
    echo "  tunnel  - Start with tunnel access"
    echo "  backup  - Backup n8n data"
    echo "  reset   - Reset n8n data"
    echo "  clean   - Clean cache and rebuild"
    echo "  init    - Initialize setup"
    echo "  help    - Show this help message"
    ;;
esac
