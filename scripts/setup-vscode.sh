#!/usr/bin/env bash
# VSCode Setup Script for Kamaete
# Installs VSCode and copies settings
#
# Prerequisites: Homebrew must be installed

set -e  # Exit on error

# Determine script directory and repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# VSCode settings path on macOS
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"

# Source files
DOTFILES_VSCODE_SETTINGS="$REPO_ROOT/dotfiles/vscode-user-settings.json"

echo "========================================"
echo "  Kamaete VSCode Setup"
echo "========================================"
echo ""


echo "Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    echo "Installing VSCode via Homebrew..."
    brew install --cask visual-studio-code
    echo "✓ VSCode installed successfully"
else
    echo "✓ VSCode is already installed"
fi

echo ""
echo "Copying VSCode settings..."

# Check if source file exists
if [ ! -f "$DOTFILES_VSCODE_SETTINGS" ]; then
    echo "❌ Error: VSCode settings source file not found: $DOTFILES_VSCODE_SETTINGS"
    exit 1
fi

# Backup existing settings file if it exists
if [ -e "$VSCODE_SETTINGS" ]; then
    echo "⚠ Existing VSCode settings found at: $VSCODE_SETTINGS"
    read -p "Would you like to create a backup? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_path="$VSCODE_SETTINGS.backup-$(date +%Y%m%d_%H%M%S)"
        mv "$VSCODE_SETTINGS" "$backup_path"
        echo "✓ Backed up existing settings to: $backup_path"
    else
        echo "Skipping backup..."
    fi
fi

# Copy settings file
cp "$DOTFILES_VSCODE_SETTINGS" "$VSCODE_SETTINGS"
echo "✓ Copied VSCode settings"

echo ""
echo "Installing VSCode extensions..."

# List of extensions to install
EXTENSIONS=(
    "dbaeumer.vscode-eslint"
    "docker.docker"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "formulahendry.auto-rename-tag"
    "github.copilot"
    "github.copilot-chat"
    "mikestead.dotenv"
    "snazzytheme.snazzy-vscode"
    "sysoev.vscode-open-in-github"
    "unifiedjs.vscode-mdx"
    "vscodevim.vim"
    "wix.vscode-import-cost"
)

for extension in "${EXTENSIONS[@]}"; do
    code --install-extension "$extension"
done

echo ""
echo "========================================"
echo "  VSCode setup complete!"
echo "========================================"
echo ""
echo "Settings location: $VSCODE_SETTINGS"
echo "Extensions installed: ${#EXTENSIONS[@]}"
echo ""
