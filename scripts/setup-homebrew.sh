#!/usr/bin/env bash
#
# setup-homebrew.sh - Install Homebrew package manager
#
# This script is called by install.sh after the repository has been cloned.
# Running from the cloned repo ensures proper TTY access for interactive sudo prompts.
# This solves the non-interactive mode issue when install.sh is run via curl | bash.
#
# Usage:
#   ./scripts/setup-homebrew.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Trap errors to provide helpful context
error_handler() {
    local line_no=$1
    echo ""
    echo -e "${RED}${BOLD}✗ Error occurred in setup-homebrew.sh at line ${line_no}${NC}"
    echo -e "${RED}Homebrew installation failed. Please check the error message above.${NC}"
    echo ""
    exit 1
}

trap 'error_handler ${LINENO}' ERR

echo ""
echo -e "${BLUE}${BOLD}Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    echo -e "${YELLOW}Note: You may be prompted for your password to install Homebrew.${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session (Apple Silicon and Intel)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo -e "${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi
echo ""
