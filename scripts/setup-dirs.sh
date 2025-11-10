#!/usr/bin/env bash
#
# setup-dirs.sh - Ensure standard development directories exist
#
# This script creates the necessary directory structure for development work.
# It is idempotent and safe to run multiple times.
#
# Features:
# - Creates ~/Development directory if it doesn't exist
# - Idempotent: Safe to run multiple times
# - Provides clear feedback on actions taken
#
# Usage:
#   ./scripts/setup-dirs.sh

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Kamaete: Directory Setup ===${NC}"
echo ""

# Create ~/Development directory
DEVELOPMENT_DIR="$HOME/Development"

if [ -d "$DEVELOPMENT_DIR" ]; then
    echo -e "${GREEN}✓ $DEVELOPMENT_DIR already exists${NC}"
else
    mkdir -p "$DEVELOPMENT_DIR"
    echo -e "${GREEN}✓ Created $DEVELOPMENT_DIR${NC}"
fi

echo ""
echo -e "${GREEN}=== Directory Setup Complete ===${NC}"
