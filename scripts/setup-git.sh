#!/usr/bin/env bash
#
# setup-git.sh - Configure git with dotfiles and user customization
#
# This script:
# - Ensures git is installed (installs via Homebrew if needed)
# - Copies dotfiles/.gitconfig to ~/.gitconfig (with backup option)
# - Prompts user to customize their git identity
#
# Prerequisites:
#   - Homebrew should be installed (run setup-apps.sh first)
#
# Usage:
#   ./scripts/setup-git.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
DOTFILES_GITCONFIG="$REPO_ROOT/dotfiles/.gitconfig"
TARGET_GITCONFIG="$HOME/.gitconfig"

echo -e "${GREEN}=== Kamaete: Git Configuration Setup ===${NC}"
echo ""

# Check if git is installed, install via Homebrew if needed
echo -e "${YELLOW}Checking for git...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}✗ Git is not installed${NC}"
    echo -e "${BLUE}Installing git via Homebrew...${NC}"
    brew install git
    echo -e "${GREEN}✓ Git installed successfully${NC}"
else
    echo -e "${GREEN}✓ Git is already installed${NC}"
fi

echo ""

# Copy dotfiles/.gitconfig to ~/.gitconfig
echo -e "${YELLOW}Setting up git configuration...${NC}"

if [ ! -f "$DOTFILES_GITCONFIG" ]; then
    echo -e "${RED}✗ Could not find dotfiles/.gitconfig at: $DOTFILES_GITCONFIG${NC}"
    exit 1
fi

if [ -f "$TARGET_GITCONFIG" ]; then
    echo -e "${YELLOW}⚠ Existing .gitconfig found at ~/.gitconfig${NC}"
    read -p "Would you like to create a backup? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_FILE="$TARGET_GITCONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$TARGET_GITCONFIG" "$BACKUP_FILE"
        echo -e "${GREEN}✓ Backup created at: $BACKUP_FILE${NC}"
    else
        echo -e "${YELLOW}Skipping backup...${NC}"
    fi
fi

cp "$DOTFILES_GITCONFIG" "$TARGET_GITCONFIG"
echo -e "${GREEN}✓ Copied dotfiles/.gitconfig to ~/.gitconfig${NC}"

echo ""

# Prompt for user customization
echo -e "${BLUE}=== Git User Configuration ===${NC}"
echo ""

# Get current values from the newly copied config
CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

# Prompt for name
echo -e "${BLUE}Enter your git author name${NC} ${YELLOW}(press Enter to use default: $CURRENT_NAME)${NC}"
read -p "> " NEW_NAME

if [ -n "$NEW_NAME" ]; then
    git config --global user.name "$NEW_NAME"
    echo -e "${GREEN}✓ Set user.name to: $NEW_NAME${NC}"
else
    echo -e "${GREEN}✓ Using default name: $CURRENT_NAME${NC}"
fi

echo ""

# Prompt for email
echo -e "${BLUE}Enter your git author email${NC} ${YELLOW}(press Enter to use default: $CURRENT_EMAIL)${NC}"
read -p "> " NEW_EMAIL

if [ -n "$NEW_EMAIL" ]; then
    git config --global user.email "$NEW_EMAIL"
    echo -e "${GREEN}✓ Set user.email to: $NEW_EMAIL${NC}"
else
    echo -e "${GREEN}✓ Using default email: $CURRENT_EMAIL${NC}"
fi

echo ""
echo -e "${GREEN}=== Git Configuration Complete ===${NC}"
