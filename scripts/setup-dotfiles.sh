#!/usr/bin/env bash
# Kamaete Dotfiles Setup Script
# This script creates symlinks for dotfiles from the repository to the home directory
# It is idempotent and safe to run multiple times

set -e  # Exit on error

# Determine the repository root (the directory containing this script's parent)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Dotfiles to symlink
DOTFILES=(".zshrc" ".gitconfig" "nvimrc")

echo "========================================"
echo "  Kamaete Dotfiles Setup"
echo "========================================"
echo ""
echo "Repository location: $REPO_ROOT"
echo "Home directory: $HOME"
echo ""

# Function to symlink a dotfile
symlink_dotfile() {
    local file="$1"
    local src="$REPO_ROOT/dotfiles/$file"
    local dest="$HOME/$file"
    
    # Check if source file exists
    if [ ! -f "$src" ]; then
        echo "⚠️  Warning: Source file not found: $src"
        return 1
    fi
    
    # Check if destination is already a symlink
    if [ -L "$dest" ]; then
        # Check if it points to the correct location
        local current_target
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo "✓ $file already symlinked correctly. Skipping."
        else
            echo "⚠️  $dest is a symlink but points to: $current_target"
            echo "   Expected: $src"
            echo "   Skipping to avoid breaking existing setup."
        fi
    # Check if destination exists as a regular file
    elif [ -e "$dest" ]; then
        local backup_path
        backup_path="$dest.backup-$(date +%s)"
        mv "$dest" "$backup_path"
        ln -s "$src" "$dest"
        echo "✓ Backed up existing file to: $backup_path"
        echo "✓ Symlinked $file"
    # Destination doesn't exist, create symlink
    else
        ln -s "$src" "$dest"
        echo "✓ Symlinked $file"
    fi
}

# Process each dotfile
for file in "${DOTFILES[@]}"; do
    symlink_dotfile "$file"
done

echo ""
echo "========================================"
echo "  Dotfiles setup complete!"
echo "========================================"
echo ""
echo "Your dotfiles are now symlinked from the repository."
echo "Any changes you make to these files will be tracked in git."
echo ""
echo "To customize further, you can:"
echo "  - Edit files in: $REPO_ROOT/dotfiles/"
echo "  - Create local overrides (e.g., ~/.zshrc.local, ~/.nvimrc.local)"
echo ""
