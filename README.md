# kamae CLI POC

Bootstrap a new machine with an interactive CLI tool for selecting and installing applications.

## Overview

`kamae` is a command-line tool that presents an interactive, categorized list of applications for installation on a new machine. It uses a YAML-based manifest to organize applications into recommended and optional categories, with subcategories like development, utility, and productivity tools.

## Features

- **Interactive Selection**: Navigate through applications using arrow keys or vim-style navigation (j/k)
- **Pre-selected Recommendations**: Recommended applications are automatically selected
- **Categorized Organization**: Applications grouped by type (development, utility, productivity)
- **Visual Feedback**: Clear indication of selected/unselected items with checkmarks
- **Installation Preview**: Shows what would be installed (stub implementation)

## Setup

### Prerequisites
- Go 1.20+ installed on your system
- Terminal with support for interactive applications

### Dependencies
The project uses the following Go modules:
- `github.com/charmbracelet/bubbletea` - Terminal UI framework
- `gopkg.in/yaml.v3` - YAML parsing

Dependencies are automatically installed when building the project.

## Build

Clone the repository and build the CLI:

```bash
git clone https://github.com/angelocordon/kamaete.git
cd kamaete
make setup  # Download dependencies and setup development environment
make build  # Build the binary
```

The binary will be created at `./bin/kamae`.

### Development Commands

The project includes a Makefile to streamline common development tasks:

- `make setup` - Download Go modules and prepare development environment
- `make build` - Compile the kamae binary
- `make test` - Run all Go tests
- `make lint` - Run linters (go vet + fmt check, or golangci-lint if installed)
- `make format` - Format Go source files with gofmt
- `make clean` - Remove build artifacts
- `make help` - Show all available targets

Alternatively, you can build directly with Go:

```bash
go build -o bin/kamae ./cmd/kamae
```

## Usage

Run the interactive application selector:

```bash
bin/kamae init
```

### Navigation
- **↑/↓ or j/k**: Move cursor up/down
- **Space**: Toggle selection of current item  
- **Enter**: Proceed with installation (stub)
- **q or Ctrl+C**: Quit

### Example Output

```
kamae - Bootstrap Application Installer

RECOMMENDED APPLICATIONS

  Development:
    > [✓] Homebrew (recommended)
      [✓] VSCode (recommended)  
      [✓] GitHub CLI (recommended)
      [✓] Docker (recommended)
      [✓] Ghostty (recommended)

  Utility:
      [✓] Rectangle (recommended)
      [✓] Amphetamine (recommended)
      [✓] Bartender (recommended)
      [✓] Raycast (recommended)

OPTIONAL APPLICATIONS

  Productivity:
      [ ] Spotify (optional)
      [ ] Discord (optional)
      [ ] Zoom (optional)

Navigation: ↑/↓ or j/k to move, space to toggle, enter to install, q to quit
Selected: 14 applications
```

## Application Manifest

Applications are defined in `modules/manifest.yaml` using the following structure:

```yaml
recommended:
  development:
    - name: Homebrew
      id: homebrew
      install: brew
    - name: VSCode  
      id: vscode
      install: brew_cask
      
optional:
  productivity:
    - name: Spotify
      id: spotify
      install: brew_cask
```

### Supported Installation Methods
- `brew`: Homebrew packages
- `brew_cask`: Homebrew casks  
- `mas`: Mac App Store (requires `mas_id` field)

## Project Structure

```
kamaete/
├── cmd/kamae/main.go         # CLI entrypoint
├── internal/
│   ├── manifest.go           # Manifest loading logic
│   └── ui.go                 # Interactive UI implementation
├── modules/manifest.yaml      # Application manifest
├── bin/                      # Build output directory
├── go.mod                    # Go module definition
└── README.md                 # This file
```

## Current Status

This is a proof-of-concept implementation that focuses on the interactive selection workflow. Key features:

✅ Interactive terminal UI with bubbletea  
✅ YAML-based application manifest  
✅ Categorized application organization  
✅ Pre-selection of recommended apps  
✅ Stub installation logging  

## Next Steps

- Implement actual installation commands
- Add support for remote manifest fetching  
- Add configuration file for user preferences
- Implement additional subcommands (update, status)
- Add installation progress tracking
