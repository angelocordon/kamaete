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

### Quick Start (Recommended)

Run the following command to set up your machine:

```bash
curl -sSL https://raw.githubusercontent.com/angelocordon/kamaete/main/install.sh | bash
```

**How it works:**
1. Creates `~/Development` directory
2. Installs Xcode Command Line Tools (includes git)
3. Clones the Kamaete repository to `~/Development/kamaete`
4. Executes `setup-homebrew.sh` from the cloned repo (with TTY access)
5. Runs all setup scripts to configure your environment

This approach **solves the non-interactive TTY issue** with Homebrew installation. By cloning the repository first and then executing `setup-homebrew.sh` as a local script, Homebrew gets proper TTY access for sudo prompts, even when the bootstrap script is run via `curl | bash`.

> **Security Note:** For security-conscious users, we recommend the manual installation method below to review the code first.

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
┌─────────────────────────────────────────────────┐
│      install.sh (Main Entry Point)              │
│                                                 │
│  1. Create ~/Development directory              │
│  2. Install Xcode Command Line Tools (git)      │
│  3. Clone kamaete repository                    │
│  4. Execute setup-homebrew.sh (local, has TTY) │
│  5. Run all setup scripts                       │
└────────────────────┬────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌──────────────┐          ┌──────────────┐
│  Apps Setup  │          │ Dotfiles Mgmt│
│              │          │              │
│ - Brewfile   │          │ - .zshrc     │
│ - CLI tools  │          │ - .gitconfig │
│ - GUI apps   │          │ - nvimrc     │
└──────────────┘          │ - Symlinks   │
                          │ - Backups    │
                          └──────────────┘
        │                         │
        └────────────┬────────────┘
                     ▼
        ┌──────────────────────┐
        │  Directory Setup     │
        │                      │
        │  ~/Development       │
        └──────────────────────┘
```

### Component Interaction

1. **install.sh**: Main orchestration script that coordinates all setup operations
2. **setup-homebrew.sh**: Dedicated Homebrew installation script (executed locally with TTY)
3. **Application Management**: Installs developer tools and productivity apps via Homebrew
4. **Dotfiles Management**: Version-controls and symlinks configuration files
5. **Directory Structure**: Ensures standard development folders exist

### Why This Architecture?

**The Problem:** Homebrew installation fails in non-interactive mode when stdin is not a TTY. This commonly occurs when running scripts via `curl | bash`.

**The Solution:** Clone the repository first, then execute `setup-homebrew.sh` as a local script.

**How it works:**
- When you run `curl ... | bash`, stdin is consumed by the piped curl output
- Homebrew's installation requires sudo access and needs TTY for interactive prompts
- By cloning the repository first, then executing `setup-homebrew.sh` as a local script, Homebrew gets proper TTY access
- This allows interactive prompts to work correctly, even though the initial bootstrap was piped
- After Homebrew is installed, `install.sh` continues to run all other setup scripts

## 📦 Included Scripts and Dotfiles

### Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Main orchestration script (Xcode CLT, git, clone repo, Homebrew, all setup scripts) |
| `scripts/setup-homebrew.sh` | Dedicated Homebrew installation script (executed locally with TTY access) |
| `scripts/setup-apps.sh` | Installs applications using Homebrew and Brewfile |
| `scripts/setup-dotfiles.sh` | Creates symlinks for dotfiles with backup mechanism |
| `scripts/setup-git.sh` | Configures git with user details and default branch (main) |
| `scripts/setup-dirs.sh` | Creates standard development directory structure (~/Development) |
| `scripts/setup-vscode.sh` | Installs and configures VSCode |

### Dotfiles

| File | Description |
|------|-------------|
| `.zshrc` | Zsh shell configuration with aliases and environment settings |
| `.gitconfig` | Git configuration with user settings and aliases |
| `nvimrc` | Neovim/Vim editor configuration |
| `vscode-user-settings.json` | Visual Studio Code user settings |

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
