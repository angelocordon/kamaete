#!/usr/bin/env bash
#
# install.sh - Bootstrap script for Kamaete setup
#
# This script handles the initial bootstrapping phase:
# 1. Creates ~/Development directory
# 2. Installs Xcode Command Line Tools (includes git)
# 3. Clones the Kamaete repository
# 4. Executes setup_main.sh from the cloned repo (which handles Homebrew installation)
#
# This approach solves the non-interactive TTY issue with Homebrew installation
# when running via curl | bash, as the local script execution has proper TTY access.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/angelocordon/kamaete/main/install.sh | bash
#
# Or for manual installation:
#   git clone https://github.com/angelocordon/kamaete.git
#   cd kamaete
#   ./scripts/setup_main.sh

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

# Step 3: Verify git is available (installed with Xcode Command Line Tools)
echo -e "${BLUE}${BOLD}Checking git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git is not available. Xcode Command Line Tools may not be properly installed.${NC}"
    echo -e "${YELLOW}Please run: xcode-select --install${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Git is available${NC}"
echo ""

# Step 4: Clone or update kamaete repository in ~/Development
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

# Step 5: Execute setup_main.sh from the cloned repository
# This script will handle Homebrew installation and all subsequent setup
# Running it from the cloned repo ensures proper TTY access for interactive prompts
echo -e "${BLUE}${BOLD}Executing main setup from cloned repository...${NC}"
echo -e "${YELLOW}This will install Homebrew and set up all applications.${NC}"
echo ""

SETUP_MAIN="${REPO_ROOT}/scripts/setup_main.sh"
if [ ! -f "${SETUP_MAIN}" ]; then
    echo -e "${RED}✗ setup_main.sh not found at ${SETUP_MAIN}${NC}"
    echo -e "${YELLOW}Your repository may be out of date. Try: cd ${REPO_ROOT} && git pull${NC}"
    exit 1
fi

# Execute the main setup script
if bash "${SETUP_MAIN}"; then
    echo ""
    echo -e "${GREEN}${BOLD}========================================${NC}"
    echo -e "${GREEN}${BOLD}   ✓ Bootstrap Complete!${NC}"
    echo -e "${GREEN}${BOLD}========================================${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}${BOLD}✗ Setup failed${NC}"
    echo -e "${YELLOW}You can try running the setup manually:${NC}"
    echo "  cd ${REPO_ROOT}"
    echo "  ./scripts/setup_main.sh"
    echo ""
    exit 1
fi

