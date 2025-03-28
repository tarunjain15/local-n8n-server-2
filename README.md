# Local n8n Server 2

This is a secondary local development instance of n8n. 

## Available Scripts

| Script | Description | Command |
|--------|-------------|---------|
| `start_n8n.sh` | Start the n8n server | `npm run server` |
| `start_tunnel.sh` | Start with tunnel access | `npm run tunnel` |
| `dump-data.sh` | Reset n8n data (with backup) | `npm run dump-data` |
| `clean-start.sh` | Clean cache and restart | `npm run clean-start` |
| `manage-nodes.sh` | Manage custom nodes | See below |

## Managing Custom Nodes

The `manage-nodes.sh` script provides commands for working with custom nodes:

```bash
# List all custom nodes linked to this server
npm run nodes

# Link a custom node to this server
npm run nodes:link -- /path/to/custom-node

# Unlink a custom node from this server
npm run nodes:unlink -- /path/to/custom-node

# Check link status of a custom node
npm run nodes:check -- /path/to/custom-node
```

## Advanced Options

You can use additional options with some scripts:

```bash
# Reset without confirmation prompt
./scripts/dump-data.sh --force

# Perform a full clean install (removes node_modules)
./scripts/clean-start.sh --full

# Skip confirmation in clean-start
./scripts/clean-start.sh --force
```
