# Kamaete (構えて)

> _"To prepare" or "get ready" in Japanese_

Kamaete is a system to easily bootstrap a new laptop for my everyday productivity and dotfiles management system. It provides an automated, idempotent setup that can quickly configure a new macOS machine with all of my essential tools, applications, and personalized configurations for development work.

## 🎯 Project Overview

**Goal:** Reproducible developer machine setup for macOS

Kamaete enables rapid onboarding of new machines or recovery from system reinstalls with a single command. Whether I'm setting up a new MacBook or rebuilding after a clean install, Kamaete ensures my development environment is configured consistently and efficiently.

**Key Benefits:**
- **Automated:** Minimal user intervention required
- **Idempotent:** Safe to run multiple times without side effects
- **Modular:** Separate scripts for each concern
- **Safe:** Backs up existing configurations before making changes
- **Well-documented:** Clear instructions and architecture

## 🚀 Usage

### Quick Start

Run the following command to set up your machine:

```bash
curl -sSL https://raw.githubusercontent.com/angelocordon/kamaete/main/install.sh | bash
```

> **Security Note:** Piping to bash runs the script immediately. For security-conscious users, we recommend the manual installation method below to review the code first.

### Manual Installation

If you prefer to review the code before running (recommended for first-time use):

```bash
git clone https://github.com/angelocordon/kamaete.git
cd kamaete
./install.sh
```

The installation is idempotent, so you can run it multiple times safely. Each run will:
- Install or update applications via Homebrew
- Symlink dotfiles to your home directory (backing up existing files)
- Create standard development directory structure
- Provide clear feedback on each step

## 🏗️ Architecture

### High-Level Overview

```
┌─────────────────────────────────────────┐
│           install.sh (Entry Point)      │
│                                         │
│  Orchestrates all setup steps with     │
│  error handling and user feedback      │
└─────────────────┬───────────────────────┘
                  │
        ┌─────────┴─────────┐
        │                   │
        ▼                   ▼
┌──────────────┐    ┌──────────────┐
│  Apps Setup  │    │ Dotfiles Mgmt│
│              │    │              │
│ - Brewfile   │    │ - .zshrc     │
│ - CLI tools  │    │ - .gitconfig │
│ - GUI apps   │    │ - nvimrc     │
└──────────────┘    │ - Symlinks   │
                    │ - Backups    │
                    └──────────────┘
        │                   │
        └─────────┬─────────┘
                  ▼
        ┌──────────────────┐
        │  Directory Setup │
        │                  │
        │  ~/Development   │
        └──────────────────┘
```

### Component Interaction

1. **install.sh**: Main entry point that coordinates all setup operations
2. **Application Management**: Installs developer tools and productivity apps via Homebrew
3. **Dotfiles Management**: Version-controls and symlinks configuration files
4. **Directory Structure**: Ensures standard development folders exist

## 📦 Included Scripts and Dotfiles

### Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Main installation script that orchestrates all setup steps |
| `scripts/setup-apps.sh` | Installs applications using Homebrew and Brewfile |
| `scripts/setup-dotfiles.sh` | Creates symlinks for dotfiles with backup mechanism |
| `scripts/setup-directories.sh` | Creates standard development directory structure |

### Dotfiles

| File | Description |
|------|-------------|
| `.zshrc` | Zsh shell configuration with aliases and environment settings |
| `.gitconfig` | Git configuration with user settings and aliases |
| `nvimrc` | Neovim/Vim editor configuration |

### Applications Included

**Developer Tools:**
- git, gh (GitHub CLI)
- Docker Desktop (containerization platform)

**Productivity Apps:**
- Visual Studio Code (code editor)
- Ghostty (modern terminal emulator)
- Rectangle (window management)
- Raycast (productivity launcher)
- Bartender (menu bar organization)
- Amphetamine (keep your Mac awake)
- Notion Calendar (calendar management)

**Communication:**
- Slack, Discord, Zoom

**Utilities:**
- 1Password (password management)
- Google Chrome (web browser)
- Spotify (music streaming)

## 🔧 How to Extend the System

### Adding Applications

1. **Edit the Brewfile:**
   ```bash
   # Add to Brewfile
   brew "your-cli-tool"
   cask "your-gui-app"
   ```

2. **Common categories:**
   - `brew "package"` - Command-line tools
   - `cask "application"` - GUI applications
   - `mas "app-name", id: 123456` - Mac App Store apps

3. **Test your changes:**
   ```bash
   brew bundle --file=Brewfile
   ```

### Adding Dotfiles

1. **Add your dotfile to the repository:**
   ```bash
   cp ~/.your-config dotfiles/.your-config
   git add dotfiles/.your-config
   ```

2. **Update `scripts/setup-dotfiles.sh`:**
   Add your file to the list of dotfiles to symlink:
   ```bash
   DOTFILES=(".zshrc" ".gitconfig" "nvimrc" ".your-config")
   ```

3. **The script will automatically:**
   - Back up any existing file
   - Create a symlink from your home directory to the repo

### Adding Custom Scripts

1. **Create your script in the `scripts/` directory:**
   ```bash
   touch scripts/setup-custom.sh
   chmod +x scripts/setup-custom.sh
   ```

2. **Follow the existing pattern:**
   - Make it idempotent (safe to run multiple times)
   - Provide clear output messages
   - Handle errors gracefully

3. **Call it from `install.sh`:**
   ```bash
   echo "Running custom setup..."
   ./scripts/setup-custom.sh
   ```

### Best Practices for Extensions

- **Test locally first:** Run scripts manually before adding to `install.sh`
- **Make it idempotent:** Check if something exists before creating/installing
- **Provide feedback:** Use `echo` statements to inform users of progress
- **Handle errors:** Check command exit codes and fail gracefully
- **Document changes:** Update this README with any new components

## 🤝 Contributing

This is a personal dotfiles repository, but feel free to fork it and adapt it to your needs. If you find bugs or have suggestions, please open an issue.

## 📄 License

MIT License - Feel free to use this as a starting point for your own setup!

---

**Note:** This system is designed for macOS. Some scripts may require macOS-specific tools like Homebrew.
