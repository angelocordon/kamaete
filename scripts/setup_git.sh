#!/usr/bin/env bash
#
# setup_git.sh - Configure git with user details and default branch
#
# This script configures git with the following settings:
# - user.name: Angelo Cordon
# - user.email: angelocordon@gmail.com
# - init.defaultBranch: main
#
# Features:
# - Idempotent: Safe to run multiple times
# - Checks if settings are already present before setting them
# - Uses global git configuration
#
# Usage:
#   ./scripts/setup_git.sh

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Kamaete: Git Configuration Setup ===${NC}"
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}✗ Git is not installed${NC}"
    echo -e "${YELLOW}Please install git first (it should be installed via setup_apps.sh)${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Git is installed${NC}"
echo ""

# Configure user.name
echo -e "${YELLOW}Configuring git user.name...${NC}"
if git config --global user.name 2>/dev/null | grep -q "Angelo Cordon"; then
    echo -e "${GREEN}✓ user.name is already set to 'Angelo Cordon'${NC}"
else
    git config --global user.name "Angelo Cordon"
    echo -e "${GREEN}✓ Set user.name to 'Angelo Cordon'${NC}"
fi

# Configure user.email
echo -e "${YELLOW}Configuring git user.email...${NC}"
if git config --global user.email 2>/dev/null | grep -q "angelocordon@gmail.com"; then
    echo -e "${GREEN}✓ user.email is already set to 'angelocordon@gmail.com'${NC}"
else
    git config --global user.email "angelocordon@gmail.com"
    echo -e "${GREEN}✓ Set user.email to 'angelocordon@gmail.com'${NC}"
fi

# Configure init.defaultBranch
echo -e "${YELLOW}Configuring git init.defaultBranch...${NC}"
if git config --global init.defaultBranch 2>/dev/null | grep -q "main"; then
    echo -e "${GREEN}✓ init.defaultBranch is already set to 'main'${NC}"
else
    git config --global init.defaultBranch "main"
    echo -e "${GREEN}✓ Set init.defaultBranch to 'main'${NC}"
fi

echo ""
echo -e "${GREEN}=== Git Configuration Complete ===${NC}"
echo ""
echo "Current git configuration:"
echo -e "${YELLOW}  user.name:${NC} $(git config --global user.name 2>/dev/null || echo '(not set)')"
echo -e "${YELLOW}  user.email:${NC} $(git config --global user.email 2>/dev/null || echo '(not set)')"
echo -e "${YELLOW}  init.defaultBranch:${NC} $(git config --global init.defaultBranch 2>/dev/null || echo '(not set)')"
