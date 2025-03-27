# local-n8n-server-2

A duplicate n8n server setup running on port 5679.

## Quick Start

1. Initialize the server:
   ```
   ./n8n.sh init
   ```

2. Start the server:
   ```
   npm run server
   ```
   or
   ```
   ./n8n.sh start
   ```

3. Access the n8n interface at: http://localhost:5679

## Available Commands

- `./n8n.sh start` - Start the n8n server
- `./n8n.sh tunnel` - Start with tunnel access
- `./n8n.sh backup` - Backup n8n data
- `./n8n.sh reset` - Reset n8n data
- `./n8n.sh clean` - Clean cache and rebuild
- `./n8n.sh init` - Initialize setup

## NPM Scripts

- `npm run start`: Start the n8n server directly
- `npm run server`: Start the n8n server using the wrapper script (same as `./n8n.sh start`)
- `npm run dev`: Start with tunnel access
- `npm run start-with-tunnel`: Same as above
- `npm run install-n8n`: Install n8n
- `npm run reset-data`: Reset all n8n data
- `npm run backup`: Backup n8n data
- `npm run clean-rebuild`: Run clean rebuild script

## Custom Nodes

To manage custom nodes:
- `npm run nodes:list` - List all configured custom nodes
- `npm run nodes:add <node-name>` - Add a custom node to configuration
- `npm run nodes:remove <node-name>` - Remove a custom node from configuration
- `npm run nodes:link <path-to-node-dir>` - Link a local node directory and add to configuration
