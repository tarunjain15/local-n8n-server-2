#!/bin/bash

# Script to list and manage custom n8n nodes
# Created for Tarun's n8n setup

set -e

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$SERVER_DIR/.env"

# Function to print header
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Function to print success message
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning message
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error message
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to list custom nodes
list_custom_nodes() {
    print_header "Custom Nodes Currently Configured"
    
    # Check if N8N_CUSTOM_EXTENSIONS exists in .env
    if grep -q "N8N_CUSTOM_EXTENSIONS" "$ENV_FILE"; then
        # Extract the value
        EXTENSIONS=$(grep "N8N_CUSTOM_EXTENSIONS" "$ENV_FILE" | cut -d= -f2)
        
        if [ -z "$EXTENSIONS" ]; then
            print_warning "No custom nodes are configured"
            return
        fi
        
        # Split by comma and display
        IFS=',' read -ra NODE_ARRAY <<< "$EXTENSIONS"
        for node in "${NODE_ARRAY[@]}"; do
            # Check if node module exists
            if [ -d "$SERVER_DIR/node_modules/$node" ]; then
                # Try to extract version from package.json
                if [ -f "$SERVER_DIR/node_modules/$node/package.json" ]; then
                    VERSION=$(grep -o '"version": "[^"]*' "$SERVER_DIR/node_modules/$node/package.json" | cut -d'"' -f4)
                    echo -e "${GREEN}✓ $node${NC} (v$VERSION) - INSTALLED"
                else
                    echo -e "${GREEN}✓ $node${NC} - INSTALLED"
                fi
            else
                echo -e "${RED}✗ $node${NC} - NOT FOUND (configured but not installed)"
            fi
        done
    else
        print_warning "No custom nodes are configured in your .env file"
    fi
    
    echo -e "\n${BLUE}Checking for physically linked nodes in node_modules:${NC}"
    for dir in "$SERVER_DIR/node_modules/"*; do
        if [ -d "$dir" ] && [ -f "$dir/package.json" ]; then
            # Check if it's an n8n nodes package by looking for n8n keywords
            if grep -q '"keywords": \[.*"n8n-community-node-package".*\]' "$dir/package.json" 2>/dev/null || grep -q '"n8n": {' "$dir/package.json" 2>/dev/null; then
                NAME=$(basename "$dir")
                VERSION=$(grep -o '"version": "[^"]*' "$dir/package.json" | cut -d'"' -f4)
                
                # Check if it's in the environment variable
                if ! grep -q "N8N_CUSTOM_EXTENSIONS=.*$NAME.*" "$ENV_FILE" 2>/dev/null; then
                    echo -e "${YELLOW}⚠ $NAME${NC} (v$VERSION) - LINKED BUT NOT CONFIGURED in .env"
                fi
            fi
        fi
    done
}

# Function to add a custom node
add_custom_node() {
    NODE_NAME="$1"
    
    if [ -z "$NODE_NAME" ]; then
        print_error "No node name provided"
        echo "Usage: $0 add <node-name>"
        return 1
    fi

    print_header "Adding Custom Node: $NODE_NAME"
    
    # Check if node exists
    if [ ! -d "$SERVER_DIR/node_modules/$NODE_NAME" ]; then
        print_warning "Node module '$NODE_NAME' not found in node_modules."
        print_warning "Make sure the node is properly linked or installed."
    fi
    
    # Check if N8N_CUSTOM_EXTENSIONS already exists in .env
    if grep -q "N8N_CUSTOM_EXTENSIONS" "$ENV_FILE"; then
        # Check if the node is already in the list
        if grep -q "N8N_CUSTOM_EXTENSIONS=.*$NODE_NAME.*" "$ENV_FILE"; then
            print_warning "Custom node '$NODE_NAME' is already configured"
            return 0
        else
            # Append to existing list
            sed -i '' "s/N8N_CUSTOM_EXTENSIONS=\(.*\)/N8N_CUSTOM_EXTENSIONS=\1,$NODE_NAME/" "$ENV_FILE"
        fi
    else
        # Add new variable
        echo "N8N_CUSTOM_EXTENSIONS=$NODE_NAME" >> "$ENV_FILE"
    fi
    
    print_success "Custom node '$NODE_NAME' added to configuration"
    print_warning "Remember to restart n8n for changes to take effect"
}

# Function to remove a custom node
remove_custom_node() {
    NODE_NAME="$1"
    
    if [ -z "$NODE_NAME" ]; then
        print_error "No node name provided"
        echo "Usage: $0 remove <node-name>"
        return 1
    fi

    print_header "Removing Custom Node: $NODE_NAME"
    
    # Check if N8N_CUSTOM_EXTENSIONS exists in .env
    if grep -q "N8N_CUSTOM_EXTENSIONS" "$ENV_FILE"; then
        # Check if the node is in the list
        if ! grep -q "N8N_CUSTOM_EXTENSIONS=.*$NODE_NAME.*" "$ENV_FILE"; then
            print_warning "Custom node '$NODE_NAME' is not configured"
            return 0
        fi
        
        # Extract the current value
        EXTENSIONS=$(grep "N8N_CUSTOM_EXTENSIONS" "$ENV_FILE" | cut -d= -f2)
        
        # Remove the node and handle commas correctly
        NEW_EXTENSIONS=$(echo "$EXTENSIONS" | sed "s/,$NODE_NAME,/,/g" | sed "s/^$NODE_NAME,//g" | sed "s/,$NODE_NAME$//g" | sed "s/^$NODE_NAME$//g")
        
        # Update the file
        sed -i '' "s/N8N_CUSTOM_EXTENSIONS=.*/N8N_CUSTOM_EXTENSIONS=$NEW_EXTENSIONS/" "$ENV_FILE"
        
        print_success "Custom node '$NODE_NAME' removed from configuration"
        print_warning "Remember to restart n8n for changes to take effect"
    else
        print_warning "No custom nodes are configured in your .env file"
    fi
}

# Function to link a custom node from a local directory
link_custom_node() {
    NODE_PATH="$1"
    
    if [ -z "$NODE_PATH" ]; then
        print_error "No node path provided"
        echo "Usage: $0 link <path-to-node-directory>"
        return 1
    fi

    # Get absolute path
    NODE_ABS_PATH=$(cd "$NODE_PATH" 2>/dev/null && pwd) || {
        print_error "Cannot access path: $NODE_PATH"
        return 1
    }
    
    # Extract node name from package.json
    if [ ! -f "$NODE_ABS_PATH/package.json" ]; then
        print_error "No package.json found in $NODE_PATH"
        return 1
    fi
    
    NODE_NAME=$(grep -o '"name": "[^"]*' "$NODE_ABS_PATH/package.json" | head -1 | cut -d'"' -f4)
    
    if [ -z "$NODE_NAME" ]; then
        NODE_NAME=$(basename "$NODE_ABS_PATH")
        print_warning "Could not find package name, using directory name: $NODE_NAME"
    fi
    
    print_header "Linking Custom Node: $NODE_NAME from $NODE_ABS_PATH"
    
    # Create symbolic link
    mkdir -p "$SERVER_DIR/node_modules"
    ln -sf "$NODE_ABS_PATH" "$SERVER_DIR/node_modules/$NODE_NAME"
    
    print_success "Created symbolic link for $NODE_NAME"
    
    # Add to configuration if not already there
    if ! grep -q "N8N_CUSTOM_EXTENSIONS=.*$NODE_NAME.*" "$ENV_FILE" 2>/dev/null; then
        add_custom_node "$NODE_NAME"
    else
        print_warning "Custom node '$NODE_NAME' is already configured in .env"
    fi
    
    print_success "Custom node linked successfully"
    print_warning "Remember to restart n8n for changes to take effect"
}

# Main script logic
case "$1" in
    "list")
        list_custom_nodes
        ;;
    "add")
        add_custom_node "$2"
        ;;
    "remove")
        remove_custom_node "$2"
        ;;
    "link")
        link_custom_node "$2"
        ;;
    *)
        print_header "n8n Custom Nodes Manager"
        echo "Usage:"
        echo "  $0 list                     - List all configured custom nodes"
        echo "  $0 add <node-name>          - Add a custom node to configuration"
        echo "  $0 remove <node-name>       - Remove a custom node from configuration"
        echo "  $0 link <path-to-node-dir>  - Link a local node directory and add to configuration"
        echo ""
                echo "Examples:"
        echo "  $0 list"
        echo "  $0 add custom-node-template"
        echo "  $0 remove custom-node-template"
        echo "  $0 link ../custom-n8n-nodes/custom-node-template"
        ;;
esac

exit 0
