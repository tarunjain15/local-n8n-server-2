# Local N8N Server 2

This is a secondary n8n workflow automation server.

## Quick Start

```bash
# Start the server
npm run start

# Clean cache and start fresh
npm run rub-slate

# Completely reset server and start fresh
npm run new-slate
```

## Available Commands

| Command | Description |
|---------|-------------|
| `npm run start` | Start the n8n server |
| `npm run rub-slate` | Clean cache and start fresh |
| `npm run new-slate` | Reset server data with backup and start fresh |
| `npm run dev` | Start n8n in development mode |
| `npm run nodes` | List installed custom nodes |
| `npm run nodes:install <package>` | Install custom nodes from NPM or Git |
| `npm run nodes:uninstall <n>` | Uninstall custom nodes |
| `npm run dev-nodes` | Manage custom node development |
| `npm run info` | Show server information |
| `npm run health` | Check server health |
| `npm run quality` | Run quality checks |
| `npm run backup` | Create a backup of workflows and data |
| `npm run version` | Check compatibility between components |

## All N8N Server Operations

You can also use the scripts directly from the `n8n-local-server-tools` directory:

```bash
# Start all servers
cd ../n8n-local-server-tools
./start.sh all

# Clean and start all servers
./rub-slate-and-start.sh all

# Reset and start all servers
./new-slate-start.sh all
```

See the main tools directory for more detailed documentation.
