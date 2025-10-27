#!/usr/bin/env bash
#
# setup_main.sh - Main setup script executed from cloned repository
#
# This script is called by install.sh after the repository has been cloned.
# It handles Homebrew installation and runs all subsequent setup scripts.
# Running from the cloned repo ensures proper TTY access for interactive prompts.
#
# Usage:
#   ./scripts/setup_main.sh

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
    echo -e "${RED}${BOLD}✗ Error occurred in setup_main.sh at line ${line_no}${NC}"
    echo -e "${RED}Setup failed. Please check the error message above.${NC}"
    echo ""
    exit 1
}

trap 'error_handler ${LINENO}' ERR

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo ""
echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "${BLUE}${BOLD}   Kamaete Main Setup${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"
echo ""

# Step 1: Install Homebrew (package manager needed for all other tools)
echo -e "${BLUE}${BOLD}Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    echo -e "${YELLOW}Note: You may be prompted for your password to install Homebrew.${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session (Apple Silicon)
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

# Helper function to run setup scripts with clear progress feedback
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

# Step 2: Run all setup scripts in sequence
run_setup_script "${REPO_ROOT}/scripts/setup_apps.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_dotfiles.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_git.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_dirs.sh"

# Success message
echo ""
echo -e "${GREEN}${BOLD}========================================${NC}"
echo -e "${GREEN}${BOLD}   ✓ Kamaete Setup Complete!${NC}"
echo -e "${GREEN}${BOLD}========================================${NC}"
echo ""
echo -e "${GREEN}Your macOS development environment is now ready!${NC}"
echo ""

# Reload shell configuration to apply changes immediately
ZSHRC_PATH="${HOME}/.zshrc"
if [ -f "${ZSHRC_PATH}" ]; then
    echo -e "${YELLOW}Reloading shell configuration...${NC}"
    # Source the zshrc to apply changes in current shell if possible
    if [ -t 0 ]; then
        source "${ZSHRC_PATH}" || true
        echo -e "${GREEN}✓ Shell configuration reloaded${NC}"
    else
        echo -e "${YELLOW}Note: Please restart your terminal or run: source ${ZSHRC_PATH}${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review installed applications in Applications folder"
echo "  2. Customize dotfiles in: ${REPO_ROOT}/dotfiles/"
echo ""
echo -e "${BLUE}Happy coding! 🚀${NC}"
echo ""
