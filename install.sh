#!/bin/bash

# Ghostcleaner - Universal Installer
# Supports: macOS, Linux, Windows (WSL/Git Bash)

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/daiokawa/ghostcleaner"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="ghostcleaner"

echo -e "${GREEN}Ghostcleaner Installer${NC}"
echo "========================="

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
        exit 1
    fi
    echo -e "${GREEN}Detected OS: $OS${NC}"
}

# Check dependencies
check_dependencies() {
    local deps=("git" "bash")
    
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${RED}Missing dependency: $dep${NC}"
            echo "Please install $dep and try again."
            exit 1
        fi
    done
    
    # Check bash version
    bash_version=$(bash --version | head -n1 | cut -d' ' -f4 | cut -d'.' -f1)
    if [ "$bash_version" -lt 4 ] && [ "$OS" == "macos" ]; then
        echo -e "${YELLOW}Warning: macOS comes with bash 3.x. The script is compatible but consider upgrading.${NC}"
        echo "To upgrade: brew install bash"
    fi
}

# Install from source
install_from_source() {
    echo -e "${GREEN}Installing from source...${NC}"
    
    # Create temp directory
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Clone repository
    echo "Cloning repository..."
    git clone "$REPO_URL" ghostcleaner
    cd ghostcleaner
    
    # Make script executable
    chmod +x ghostcleaner.sh
    
    # Check if we need sudo
    if [ -w "$INSTALL_DIR" ]; then
        cp ghostcleaner.sh "$INSTALL_DIR/$SCRIPT_NAME"
    else
        echo -e "${YELLOW}Need sudo permission to install to $INSTALL_DIR${NC}"
        sudo cp ghostcleaner.sh "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    # Clean up
    cd /
    rm -rf "$temp_dir"
    
    echo -e "${GREEN}Installation complete!${NC}"
}

# Install with curl/wget (direct download)
install_direct() {
    echo -e "${GREEN}Direct installation...${NC}"
    
    local script_url="https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/ghostcleaner.sh"
    
    # Download script
    if command -v curl &> /dev/null; then
        curl -sSL "$script_url" -o /tmp/ghostcleaner.sh
    elif command -v wget &> /dev/null; then
        wget -q "$script_url" -O /tmp/ghostcleaner.sh
    else
        echo -e "${RED}Neither curl nor wget found. Please install one.${NC}"
        exit 1
    fi
    
    # Make executable and install
    chmod +x /tmp/ghostcleaner.sh
    
    if [ -w "$INSTALL_DIR" ]; then
        mv /tmp/ghostcleaner.sh "$INSTALL_DIR/$SCRIPT_NAME"
    else
        echo -e "${YELLOW}Need sudo permission to install to $INSTALL_DIR${NC}"
        sudo mv /tmp/ghostcleaner.sh "$INSTALL_DIR/$SCRIPT_NAME"
    fi
    
    echo -e "${GREEN}Installation complete!${NC}"
}

# Post-installation setup
post_install() {
    echo -e "\n${GREEN}Post-installation setup${NC}"
    
    # Create config directory
    config_dir="$HOME/.config/ghostcleaner"
    mkdir -p "$config_dir"
    
    # Download example config if not exists
    if [ ! -f "$HOME/.cleanerrc" ]; then
        echo "Downloading example configuration..."
        if command -v curl &> /dev/null; then
            curl -sSL "https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/example.cleanerrc" -o "$config_dir/example.cleanerrc"
        fi
        echo -e "${YELLOW}Example config saved to: $config_dir/example.cleanerrc${NC}"
        echo "Copy to ~/.cleanerrc and customize as needed."
    fi
    
    # Verify installation
    if command -v "$SCRIPT_NAME" &> /dev/null; then
        echo -e "\n${GREEN}✓ Ghostcleaner installed successfully!${NC}"
        echo -e "Version: $($SCRIPT_NAME --version 2>/dev/null || echo "1.0.0")"
        echo -e "\nUsage:"
        echo -e "  ${GREEN}$SCRIPT_NAME --dry-run${NC}    # Preview what will be cleaned"
        echo -e "  ${GREEN}$SCRIPT_NAME${NC}             # Run cleanup"
        echo -e "  ${GREEN}$SCRIPT_NAME --aggressive${NC} # Clean old versions too"
        echo -e "\nRun '$SCRIPT_NAME --help' for more options."
    else
        echo -e "${RED}Installation verification failed${NC}"
        echo "You may need to add $INSTALL_DIR to your PATH"
    fi
}

# Main installation flow
main() {
    detect_os
    check_dependencies
    
    # Ask installation method
    echo -e "\nInstallation method:"
    echo "1) Install from source (recommended)"
    echo "2) Quick install (direct download)"
    
    read -p "Choose [1-2]: " choice
    
    case $choice in
        1)
            install_from_source
            ;;
        2)
            install_direct
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
    
    post_install
}

# Run installer
main