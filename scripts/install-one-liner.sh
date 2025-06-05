#!/bin/sh
# One-liner installation script for Ghostcleaner
# Usage: curl -sSL https://raw.githubusercontent.com/yourusername/ghostcleaner/main/scripts/install-one-liner.sh | bash

set -e

echo "Installing Ghostcleaner..."

# Detect OS and architecture
OS="$(uname -s)"
ARCH="$(uname -m)"

# Install location
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
SCRIPT_URL="https://raw.githubusercontent.com/yourusername/ghostcleaner/main/ghostcleaner.sh"

# Download and install
if command -v curl >/dev/null 2>&1; then
    curl -sSL "$SCRIPT_URL" -o /tmp/ghostcleaner
elif command -v wget >/dev/null 2>&1; then
    wget -qO /tmp/ghostcleaner "$SCRIPT_URL"
else
    echo "Error: curl or wget required"
    exit 1
fi

# Make executable
chmod +x /tmp/ghostcleaner

# Install (with sudo if needed)
if [ -w "$INSTALL_DIR" ]; then
    mv /tmp/ghostcleaner "$INSTALL_DIR/ghostcleaner"
else
    sudo mv /tmp/ghostcleaner "$INSTALL_DIR/ghostcleaner"
fi

echo "✓ Ghostcleaner installed successfully!"
echo "Run 'ghostcleaner --help' to get started"