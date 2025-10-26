# Copilot Instructions for Kamaete

## Project Overview

**Kamaete** (構えて - "to prepare" or "get ready" in Japanese) is a macOS developer machine bootstrapping and dotfiles management system. The primary goal is to provide an **automated, idempotent setup system** for quickly configuring a new macOS machine with all essential tools, applications, and personalized configurations for development work.

### Primary Use Case
Enable rapid onboarding of new machines or recovery from system reinstalls with a single command, ensuring a development environment is configured consistently and efficiently every time.

## Key Components

### 1. Application Management (Issue #14)
**Location:** `Brewfile` (planned) and `scripts/setup-apps.sh` (planned)

**Purpose:** Install and manage all necessary applications using Homebrew.

**Includes:**
- **Developer Tools:** git, docker, gh CLI, node, python, go
- **GUI Applications:** Visual Studio Code, Ghostty (terminal), Rectangle (window management), Raycast (launcher)
- **Productivity Tools:** Slack, Discord, Zoom
- **Utilities:** 1Password, Bartender

**Implementation Pattern:**
```bash
# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Idempotent installation via Brewfile
if [ -f "Brewfile" ]; then
    echo "Installing applications from Brewfile..."
    brew bundle --file=Brewfile
fi
```

### 2. Dotfiles Management (Issues #15, #19)
**Location:** `dotfiles/` directory and `scripts/setup-dotfiles.sh`

**Purpose:** Version-control configuration files and symlink them to the home directory with backup mechanism.

**Current Implementation:**
- **Dotfiles Included:** `.zshrc`, `.zsh_aliases`, `.gitconfig`
- **Features:** 
  - Automated symlink creation
  - Automatic backup of existing files (timestamped: `file.backup-YYYYMMDD_HHMMSS`)
  - Idempotent: checks if symlinks already exist and are correct
  - Safe: never overwrites without backup

**Key Code Pattern from `scripts/setup-dotfiles.sh`:**
```bash
symlink_dotfile() {
    local dotfile_name="$1"
    local src="$REPO_ROOT/dotfiles/$dotfile_name"
    local dest="$HOME/$dotfile_name"
    
    # Check if source file exists
    if [ ! -f "$src" ]; then
        echo "⚠️  Warning: Source file not found: $src"
        return 1
    fi
    
    # Idempotent: Check if destination is already a correct symlink
    if [ -L "$dest" ]; then
        current_target="$(readlink "$dest")"
        if [ "$current_target" = "$src" ]; then
            echo "✓ $dotfile_name already symlinked correctly. Skipping."
            return 0
        fi
    fi
    
    # Backup existing file before symlinking
    if [ -e "$dest" ]; then
        backup_path="$dest.backup-$(date +%Y%m%d_%H%M%S)"
        mv "$dest" "$backup_path"
        echo "✓ Backed up existing file to: $backup_path"
    fi
    
    ln -s "$src" "$dest"
    echo "✓ Symlinked $dotfile_name"
}
```

### 3. Directory Structure (Issue #17)
**Location:** `scripts/setup-directories.sh` (planned)

**Purpose:** Ensure standard development directory structure exists.

**Expected Structure:**
```
~/Development/
  ├── personal/
  ├── work/
  └── opensource/
```

**Implementation Pattern:**
```bash
# Idempotent directory creation
DIRS=(
    "$HOME/Development"
    "$HOME/Development/personal"
    "$HOME/Development/work"
    "$HOME/Development/opensource"
)

for dir in "${DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "✓ Created directory: $dir"
    else
        echo "✓ Directory already exists: $dir"
    fi
done
```

### 4. Single Entry Point (Issue #18)
**Location:** `install.sh` (planned)

**Purpose:** Unified entry point that orchestrates all setup steps with clear feedback and error handling.

**Expected Structure:**
```bash
#!/usr/bin/env bash
set -e  # Exit on error

echo "Starting Kamaete setup..."

# Run each component
./scripts/setup-apps.sh
./scripts/setup-dotfiles.sh
./scripts/setup-directories.sh

echo "✓ Kamaete setup complete!"
```

## Design Principles

When contributing to Kamaete, **always** follow these core principles:

### 1. Idempotency
**Scripts must be safe to run multiple times without side effects.**

**Pattern to Follow:**
```bash
# ✅ GOOD: Check before creating/installing
if [ ! -f "$HOME/.zshrc" ]; then
    ln -s "$REPO_ROOT/dotfiles/.zshrc" "$HOME/.zshrc"
fi

# ❌ BAD: Unconditional operations
ln -s "$REPO_ROOT/dotfiles/.zshrc" "$HOME/.zshrc"  # Fails on second run
```

**Examples:**
- Check if a symlink exists before creating it
- Check if a directory exists before creating it
- Check if a package is installed before installing it
- Verify symlink target matches expected source

### 2. Automation
**Minimize user intervention. Scripts should run without prompting for input.**

**Pattern to Follow:**
```bash
# ✅ GOOD: Automatic detection and handling
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# ❌ BAD: Prompting user
read -p "Do you want to install Homebrew? (y/n) " answer
```

### 3. Modularity
**Separate scripts for each concern. Keep functions focused and single-purpose.**

**Structure:**
- `install.sh` - Main orchestrator
- `scripts/setup-apps.sh` - Application installation
- `scripts/setup-dotfiles.sh` - Dotfiles symlinking
- `scripts/setup-directories.sh` - Directory structure

**Each script should:**
- Be independently executable
- Have clear, descriptive output
- Handle its own error cases
- Follow the same idempotency patterns

### 4. Safety (Backups)
**Always back up existing configurations before making changes.**

**Pattern to Follow:**
```bash
# ✅ GOOD: Backup before overwriting
if [ -e "$dest" ]; then
    backup_path="$dest.backup-$(date +%Y%m%d_%H%M%S)"
    mv "$dest" "$backup_path"
    echo "✓ Backed up existing file to: $backup_path"
fi

# ❌ BAD: Direct overwrite
rm "$dest"  # Data loss!
ln -s "$src" "$dest"
```

**Backup naming convention:** `original-filename.backup-YYYYMMDD_HHMMSS`

### 5. Error Handling
**Scripts should fail gracefully with informative messages.**

**Pattern to Follow:**
```bash
# Set error handling at the top of each script
set -e  # Exit on error

# Check preconditions
if [ ! -f "$REQUIRED_FILE" ]; then
    echo "❌ Error: Required file not found: $REQUIRED_FILE"
    exit 1
fi

# Informative error messages
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed. Please install it first."
    exit 1
fi
```

### 6. Clear Output and Feedback
**Provide users with clear, visual feedback on what's happening.**

**Pattern to Follow:**
```bash
echo "========================================"
echo "  Kamaete Dotfiles Setup"
echo "========================================"
echo ""

# Use visual indicators
echo "✓ Symlinked .zshrc"
echo "⚠️  Warning: File already exists"
echo "❌ Error: Source file not found"

# Summary at the end
echo ""
echo "========================================"
echo "  Setup complete!"
echo "========================================"
```

### 7. Documentation
**All code changes should be documented.**

**Requirements:**
- Update README.md when adding new components
- Add comments to complex bash logic
- Document any new environment variables or dependencies
- Keep the architecture diagram in README.md up-to-date

## Code Style Guidelines

### Bash Scripting Standards

```bash
#!/usr/bin/env bash
# Script purpose and description
# Include any prerequisites or dependencies

set -e  # Exit on error

# Use meaningful variable names (UPPERCASE for globals, lowercase for locals)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Function names: use lowercase with underscores
function_name() {
    local param1="$1"
    local param2="$2"
    
    # Function logic here
}

# Array definitions
DOTFILES=(".zshrc" ".zsh_aliases" ".gitconfig")

# Iterate arrays
for dotfile in "${DOTFILES[@]}"; do
    echo "Processing: $dotfile"
done
```

### File Organization

```
kamaete/
├── .github/
│   └── copilot-instructions.md    # This file
├── dotfiles/                       # Version-controlled configuration files
│   ├── .zshrc
│   ├── .zsh_aliases
│   └── .gitconfig
├── scripts/                        # Modular setup scripts
│   ├── setup-apps.sh
│   ├── setup-dotfiles.sh
│   └── setup-directories.sh
├── install.sh                      # Main entry point
├── Brewfile                        # Homebrew package definitions
└── README.md                       # User-facing documentation
```

## Common Patterns and Examples

### Checking Command Existence
```bash
if ! command -v <tool> &> /dev/null; then
    echo "Tool not found, installing..."
    # Installation logic
fi
```

### Determining Repository Root
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
```

### Creating Timestamped Backups
```bash
backup_path="$original_file.backup-$(date +%Y%m%d_%H%M%S)"
mv "$original_file" "$backup_path"
```

### Verifying Symlinks
```bash
if [ -L "$dest" ]; then
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$expected_source" ]; then
        echo "Already correctly symlinked"
    fi
fi
```

## Adding New Components

### Adding a New Dotfile
1. Add the file to `dotfiles/` directory
2. Update the `DOTFILES` array in `scripts/setup-dotfiles.sh`
3. Test the setup script to ensure idempotency
4. Update README.md documentation

### Adding a New Application
1. Add entry to `Brewfile`:
   - `brew "cli-tool"` for command-line tools
   - `cask "gui-app"` for GUI applications
   - `mas "app-name", id: 123456` for Mac App Store apps
2. Test with `brew bundle --file=Brewfile`
3. Update README.md with the new application

### Adding a New Setup Script
1. Create script in `scripts/` directory with `.sh` extension
2. Make it executable: `chmod +x scripts/new-script.sh`
3. Follow the established patterns:
   - Include `set -e` at the top
   - Make it idempotent
   - Provide clear output with visual indicators
   - Handle errors gracefully
4. Call from `install.sh` in the appropriate sequence
5. Update README.md documentation

## Testing Guidelines

### Manual Testing Checklist
- [ ] Run the script on a fresh clone of the repository
- [ ] Run the script a second time to verify idempotency
- [ ] Verify no errors or warnings are shown
- [ ] Check that backups are created when appropriate
- [ ] Verify symlinks point to correct locations
- [ ] Test with existing dotfiles present
- [ ] Test with missing source files (error handling)

### Testing Idempotency
```bash
# Should succeed
./install.sh

# Should also succeed without errors or duplicates
./install.sh
```

## Related Issues

This project was designed through the following implementation issues:
- **Issue #14:** Application Management via Brewfile
- **Issue #15:** Dotfiles Management System
- **Issue #17:** Directory Structure Creation
- **Issue #18:** Single Entry Point (install.sh)
- **Issue #19:** Dotfiles Symlink Implementation

Refer to these issues for detailed discussions and requirements for each component.

## Security Considerations

- **Never commit secrets** (API keys, passwords, tokens) to the repository
- Use `.gitignore` to exclude sensitive files
- The `.gitconfig` file should be customized by each user
- Consider using environment variables for sensitive configuration
- Review scripts before running with elevated privileges

## macOS-Specific Notes

This system is designed exclusively for macOS:
- Uses Homebrew as the primary package manager
- Assumes Zsh as the default shell (macOS default since Catalina)
- Some applications are macOS-only (Rectangle, Raycast, Bartender)
- Scripts may use macOS-specific commands

## Contributing Best Practices

1. **Make minimal, focused changes** - One concern per commit
2. **Test thoroughly** - Verify idempotency and error handling
3. **Follow existing patterns** - Match the style and structure of existing code
4. **Update documentation** - Keep README.md and these instructions current
5. **Use clear commit messages** - Describe what and why, not how
6. **Consider edge cases** - What happens if a file exists? If a tool isn't installed?

## Quick Reference Commands

```bash
# Clone and run setup
git clone https://github.com/angelocordon/kamaete.git
cd kamaete
./install.sh

# Add a new dotfile
cp ~/.myconfig dotfiles/.myconfig
# Edit scripts/setup-dotfiles.sh to add ".myconfig" to DOTFILES array

# Test dotfiles setup independently
./scripts/setup-dotfiles.sh

# Check current symlinks
ls -la ~ | grep "^l"

# View backup files
ls -la ~ | grep backup
```

---

**Remember:** The goal of Kamaete is to make setting up a new development machine as effortless as possible. Every contribution should move toward this goal while maintaining the principles of safety, automation, and idempotency.
