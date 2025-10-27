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
#   curl -sSL https://raw.githubusercontent.com/angelocordon/kamaete/main/install.sh | bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Trap errors to provide helpful context about what failed and why it matters
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

trap 'error_handler ${LINENO}' ERR

# Print welcome banner
echo ""
echo -e "${BLUE}${BOLD}========================================${NC}"
echo -e "${BLUE}${BOLD}   Kamaete (構えて) - Get Ready!${NC}"
echo -e "${BLUE}${BOLD}========================================${NC}"
echo ""
echo -e "${GREEN}Automated macOS development environment setup${NC}"
echo ""

# Step 1: Ensure ~/Development directory exists for organized project storage
DEV_DIR="${HOME}/Development"
if [ ! -d "${DEV_DIR}" ]; then
    echo -e "${YELLOW}Creating ~/Development directory for project organization...${NC}"
    mkdir -p "${DEV_DIR}"
    echo -e "${GREEN}✓ Created ${DEV_DIR}${NC}"
else
    echo -e "${GREEN}✓ ${DEV_DIR} already exists${NC}"
fi
cd "${DEV_DIR}"
echo ""

# Step 2: Install Xcode Command Line Tools (required for git and other dev tools)
echo -e "${BLUE}${BOLD}Checking Xcode Command Line Tools...${NC}"
if ! xcode-select -p &> /dev/null; then
    echo -e "${YELLOW}Xcode Command Line Tools not found. Installing...${NC}"
    echo -e "${YELLOW}Note: This will open a dialog. Please follow the prompts to install.${NC}"
    xcode-select --install
    
    # Wait for installation to complete
    echo -e "${YELLOW}Waiting for Xcode Command Line Tools installation to complete...${NC}"
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo -e "${GREEN}✓ Xcode Command Line Tools installed${NC}"
else
    echo -e "${GREEN}✓ Xcode Command Line Tools already installed${NC}"
fi
echo ""

# Step 3: Install Homebrew (package manager needed for all other tools)
echo -e "${BLUE}${BOLD}Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session (Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo -e "${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi
echo ""

# Step 4: Ensure git is available (needed to clone the kamaete repository)
echo -e "${BLUE}${BOLD}Checking git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git not found. Installing via Homebrew...${NC}"
    brew install git
    echo -e "${GREEN}✓ Git installed${NC}"
    
    # Configure git with basic settings (required for cloning operations)
    echo -e "${YELLOW}Configuring git...${NC}"
    git config --global user.name "Angelo Cordon"
    git config --global user.email "angelocordon@gmail.com"
    echo -e "${GREEN}✓ Git configured${NC}"
else
    echo -e "${GREEN}✓ Git already installed${NC}"
fi
echo ""

# Step 5: Clone or update kamaete repository in ~/Development
KAMAETE_DIR="${DEV_DIR}/kamaete"
echo -e "${BLUE}${BOLD}Checking kamaete repository...${NC}"
if [ -d "${KAMAETE_DIR}" ]; then
    echo -e "${YELLOW}Found existing kamaete directory. Updating...${NC}"
    cd "${KAMAETE_DIR}"
    git pull origin main
    echo -e "${GREEN}✓ Repository updated${NC}"
else
    echo -e "${YELLOW}Cloning kamaete repository...${NC}"
    git clone https://github.com/angelocordon/kamaete.git "${KAMAETE_DIR}"
    cd "${KAMAETE_DIR}"
    echo -e "${GREEN}✓ Repository cloned${NC}"
fi
echo ""

REPO_ROOT="${KAMAETE_DIR}"
echo -e "${YELLOW}Repository location:${NC} ${REPO_ROOT}"
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

# Step 6: Run all setup scripts in sequence
run_setup_script "${REPO_ROOT}/scripts/setup_apps.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_dotfiles.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_git.sh"
run_setup_script "${REPO_ROOT}/scripts/setup_dirs.sh"

# Success banner
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
    # Note: This works when running locally, but not when piped from curl
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
