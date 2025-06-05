#!/bin/bash

# Test wrapper that modifies search directories for testing

# Get the test directory from environment or argument
TEST_DIR="${TEST_DIR:-$1}"

if [ -z "$TEST_DIR" ]; then
    echo "Error: TEST_DIR not set"
    exit 1
fi

# Create a modified version of the script for testing
cp "$(dirname "$0")/../ghostcleaner.sh" "$TEST_DIR/ghostcleaner-test.sh"

# Replace the search directories with test directory only
sed -i.bak 's|SEARCH_DIRS=("$HOME/Desktop" "$HOME/Downloads" "$HOME")|SEARCH_DIRS=("'"$TEST_DIR"'")|g' "$TEST_DIR/ghostcleaner-test.sh"

# Also modify the clean_versioned_projects calls
sed -i.bak 's|clean_versioned_projects "$HOME/Desktop"|clean_versioned_projects "'"$TEST_DIR"'"|g' "$TEST_DIR/ghostcleaner-test.sh"
sed -i.bak 's|clean_versioned_projects "$HOME/Downloads"|# Skipped for testing|g' "$TEST_DIR/ghostcleaner-test.sh"
sed -i.bak 's|clean_versioned_projects "$HOME"|# Skipped for testing|g' "$TEST_DIR/ghostcleaner-test.sh"

# Run the modified script with all arguments
"$TEST_DIR/ghostcleaner-test.sh" "${@:2}"