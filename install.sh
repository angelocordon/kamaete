#!/usr/bin/env bash
#
# install.sh - Main entry point for Kamaete setup
#
# This script orchestrates the complete machine setup process by running
# all setup scripts in the correct order. It's designed to be:
# - Idempotent: Safe to run multiple times
# - Automated: Minimal user intervention required
# - Clear: Provides helpful output and error messages
#
# Usage:
#   ./install.sh
# 
# Or remotely:
#   curl -sSL https://raw.githubusercontent.com/angelocordon/kamaete/main/install.sh | bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"

# Error handler function
error_handler() {
    local line_no=$1
    echo ""
    echo -e "${RED}${BOLD}✗ Error occurred in install.sh at line ${line_no}${NC}"
    echo -e "${RED}Installation failed. Please check the error message above.${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting tips:${NC}"
    echo "  - Check your internet connection"
    echo "  - Ensure you have sufficient disk space"
    echo "  - Try running the failed script individually from scripts/"
    echo "  - Check the GitHub repository for known issues"
    echo ""
    exit 1
}

# Set up error trap
trap 'error_handler ${LINENO}' ERR

# Print welcome banner
echo ""
echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "${BLUE}${BOLD}   Kamaete (構えて) - Get Ready!${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"
echo ""
echo -e "${GREEN}This script will set up your macOS development environment${NC}"
echo -e "${GREEN}All operations are idempotent and safe to run multiple times${NC}"
echo ""
echo -e "${YELLOW}Repository location:${NC} ${REPO_ROOT}"
echo ""

# Verify we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo -e "${RED}✗ This script is designed for macOS only${NC}"
    echo -e "${YELLOW}Detected OS: $(uname)${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Running on macOS${NC}"
echo ""

# Function to run a setup script with nice output
run_setup_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    echo -e "${BLUE}${BOLD}▶ Running: ${script_name}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if bash "$script_path"; then
        echo -e "${GREEN}✓ ${script_name} completed successfully${NC}"
    else
        echo -e "${RED}✗ ${script_name} failed${NC}"
        return 1
    fi
    
    echo ""
}

# Step 1: Application Setup (includes Homebrew installation)
run_setup_script "${REPO_ROOT}/scripts/setup_apps.sh"

# Step 2: Dotfiles Setup
run_setup_script "${REPO_ROOT}/scripts/setup-dotfiles.sh"

# Step 3: Git Configuration
run_setup_script "${REPO_ROOT}/scripts/setup_git.sh"

# Step 4: Directory Structure
run_setup_script "${REPO_ROOT}/scripts/setup_dirs.sh"

# Success banner
echo ""
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}   ✓ Kamaete Setup Complete!${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo ""
echo -e "${GREEN}Your macOS development environment is now ready!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart your terminal to load new configurations"
echo "  2. Review installed applications in Applications folder"
echo "  3. Customize dotfiles in: ${REPO_ROOT}/dotfiles/"
echo ""
echo -e "${BLUE}Happy coding! 🚀${NC}"
echo ""
