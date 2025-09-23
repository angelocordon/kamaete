# kamaete - Machine Bootstrap Tool

Kamaete (Japanese: "prepare" or "get ready") is a machine bootstrap and configuration tool for setting up development environments from scratch.

**ALWAYS reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Repository Status

The repository is designed to grow over time as bootstrap configurations and automation scripts are added.

## Working Effectively

### Repository Setup

- Clone the repository: `git clone https://github.com/angelocordon/kamaete.git`
- Navigate to directory: `cd kamaete`
- Check current status: `git --no-pager status`

### Current Repository Structure

```
kamaete/
├── .git/                 # Git metadata
├── .github/              # GitHub configuration (including this file)
│   └── copilot-instructions.md
└── README.md             # Basic project description
```

### Environment Capabilities

The development environment provides these validated tools:

- **Git**: v2.51.0 - For version control operations
- **Package Management**: apt v2.8.3 - For system package installation
- **Python**: v3.12.3 with pip3 - For Python-based automation
- **Node.js**: v20.19.5 - For JavaScript/TypeScript tooling
- **Ansible**: v2.18.8 - For configuration management and automation
- **Docker**: v28.0.4 - For containerization
- **Make**: v4.3 - For build automation
- **Shell Tools**: bash v5.2.21, curl v8.5.0, wget v1.21.4

### Basic Operations (Validated Commands)

- Check repository status: `git --no-pager status`
- View repository structure: `ls -la`
- Check available tools: `which git ansible-playbook docker python3 node`
- View tool versions: `git --version && python3 --version && node --version`

## Build and Test Instructions

### Building the Go CLI Application

The repository contains a Go CLI application located in `./cmd/kamae`. To build the application, ensure you have Go installed (version 1.20 or higher recommended).

- Build the CLI: `go build -o bin/kamae ./cmd/kamae`
- Run the CLI: `./bin/kamae [command]`

### Dependencies

- **Go toolchain**: Required to build and run the application. Install from https://golang.org/dl/
- Additional dependencies are managed via Go modules (`go.mod` and `go.sum`).

### Testing

- Run tests: `go test ./...`
## Validation and Testing

### Current Validation (Minimal Repository)

- Verify git operations work: `git --no-pager log --oneline -5`
- Confirm directory structure: `find . -type f ! -path './.git/*'`

### Go CLI Validation (If Implemented)

If the Go CLI tool (`bin/kamae`) exists, validate it with the following commands:

- Ensure the CLI is executable: `ls -l bin/kamae`
- Check the CLI version/help: `bin/kamae --help`
- Test initialization: `bin/kamae init`
- (If applicable) Run the build process: `go build -o bin/kamae ./cmd/kamae`
- (If applicable) Run CLI tests: `go test ./...`

If the CLI is not yet implemented, skip these steps. Update this section as soon as Go CLI functionality is added.
### Future Validation Scenarios

When functionality is added, ALWAYS test these scenarios after making changes:

- **Full Bootstrap Test**: Run the complete machine setup on a clean system
- **Incremental Updates**: Test applying configuration changes to existing setups
- **Configuration Application**: Ensure dotfiles, shell configs, and tool settings apply properly
- **Rollback Capability**: Test reverting changes if bootstrap fails partway through

### Manual Testing Requirements

After implementing bootstrap functionality:

1. **Test on clean environment**: Always validate bootstrap scripts work from scratch
2. **Verify idempotency**: Run bootstrap multiple times to ensure no errors on repeat runs
3. **Test configuration application**: Ensure shell, editor, and development environment configs are applied
4. **Document any manual steps**: Note any steps that cannot be automated as a comment in the PR.

## Development Patterns

### Common Bootstrap Repository Patterns

Based on the environment and tooling available, expect these patterns to emerge:

- **Ansible Playbooks**: `playbooks/` directory for system configuration
- **Shell Scripts**: `scripts/` directory for custom setup tasks
- **Configuration Files**: `configs/` or `dotfiles/` for application settings
- **Package Lists**: `packages.txt`, `requirements.txt`, `package.json` for dependencies
- **Docker Configs**: `Dockerfile`, `docker-compose.yml` for containerized setups

### File Organization Recommendations

```
kamaete/
├── ansible/              # Ansible playbooks and roles
├── scripts/              # Custom bootstrap scripts
├── configs/              # Configuration files and dotfiles
├── packages/             # Package lists and dependency files
├── docker/               # Container definitions
├── docs/                 # Documentation
└── tests/                # Validation tests
```

### Adding New Functionality

When adding bootstrap capabilities:

1. **Add shell scripts**: For custom logic that Ansible cannot handle
2. **Include validation**: Always add tests to verify new functionality works
3. **Document timing**: Measure and document how long new operations take
4. **Test thoroughly**: Run complete bootstrap scenarios before committing

## Common Tasks

### Repository Maintenance

```bash
# Check repository status
git --no-pager status

# View recent changes
git --no-pager log --oneline -10

# Update from remote
git pull origin main
```

### Environment Verification

```bash
# Verify all tools are available
which git ansible-playbook docker python3 node npm curl wget make

# Check tool versions
git --version && ansible-playbook --version && docker --version
```

### Future Build Commands (When Added)

```bash
# Expected Ansible usage
ansible-playbook -i inventory bootstrap.yml  # NEVER CANCEL: 15-45 minutes

# Expected Python setup
pip3 install -r requirements.txt            # Usually 2-5 minutes

# Expected Node.js build
npm install && npm run build                 # Usually 3-10 minutes
```

## Critical Reminders

- **NEVER CANCEL** system bootstrap operations - they may take 45+ minutes
- **ALWAYS** test bootstrap scripts on clean environments before committing
- **SET TIMEOUTS** of 60+ minutes for any system-level automation commands
- **DOCUMENT** any manual steps required for complete setup
- **TEST IDEMPOTENCY** - ensure scripts can run multiple times safely

## Repository Evolution

This repository will likely evolve to include:

1. **Ansible playbooks** for automated system configuration
2. **Shell scripts** for custom setup tasks
3. **Configuration files** for development tools and environments
4. **Package lists** defining required software installations
5. **Testing framework** to validate bootstrap processes
6. **Documentation** explaining setup procedures and troubleshooting

When these components are added, update these instructions with specific build, test, and validation procedures.
