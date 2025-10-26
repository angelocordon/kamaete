#!/usr/bin/env bash
#
# setup_apps.sh - Install essential applications via Homebrew and Brewfile
#
# This script ensures Homebrew is installed and then runs brew bundle
# to install all applications defined in the Brewfile.
#
# Features:
# - Idempotent: Safe to run multiple times
# - Installs Homebrew if not present
# - Uses Brewfile for declarative package management
#
# Usage:
#   ./scripts/setup_apps.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BREWFILE="${REPO_ROOT}/Brewfile"

echo -e "${GREEN}=== Kamaete: Application Setup ===${NC}"
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
    
    # Install Homebrew
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        echo -e "${GREEN}✓ Homebrew installed successfully${NC}"
        
        # Add Homebrew to PATH for the current session
        # (Different paths for Intel vs Apple Silicon Macs)
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo -e "${RED}✗ Failed to install Homebrew${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Homebrew is already installed${NC}"
fi

# Verify Brewfile exists
if [[ ! -f "${BREWFILE}" ]]; then
    echo -e "${RED}✗ Brewfile not found at ${BREWFILE}${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Installing applications from Brewfile...${NC}"
echo "Brewfile location: ${BREWFILE}"
echo ""

# Run brew bundle to install all packages from Brewfile
if brew bundle --file="${BREWFILE}"; then
    echo ""
    echo -e "${GREEN}✓ All applications installed successfully${NC}"
else
    echo ""
    echo -e "${RED}✗ Some applications failed to install${NC}"
    echo -e "${YELLOW}Note: Some failures may be expected (e.g., apps already installed)${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Application Setup Complete ===${NC}"
