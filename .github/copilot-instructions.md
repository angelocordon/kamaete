# kamaete - Machine Bootstrap Tool

Kamaete (Japanese: "prepare" or "get ready") is a machine bootstrap and configuration tool for setting up development environments from scratch.

**ALWAYS reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Repository Status
This is currently a minimal repository containing only a README.md file. The repository is designed to grow over time as bootstrap configurations and automation scripts are added.

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

### Current State (No Build Required)
Since this is currently a minimal repository with only documentation:
- **No build process exists yet** - The repository contains only README.md
- **No test suite exists yet** - Tests will be added as functionality grows
- **No dependencies to install** - Future versions may include package.json, requirements.txt, etc.

### Expected Future Build Patterns
When bootstrap scripts and automation are added, expect these patterns:
- **Ansible Playbooks**: `ansible-playbook -i inventory playbook.yml` - NEVER CANCEL: May take 15-45 minutes depending on system setup
- **Python Scripts**: `python3 setup.py` or `pip3 install -r requirements.txt` - Usually 2-5 minutes
- **Node.js Tools**: `npm install && npm run build` - Usually 3-10 minutes  
- **Docker Builds**: `docker build -t kamaete .` - NEVER CANCEL: May take 10-30 minutes for system images

### Timeout Guidelines for Future Commands
- **CRITICAL**: Set timeouts of 60+ minutes for system bootstrap operations
- **Package installations**: 10+ minutes timeout
- **Configuration application**: 30+ minutes timeout  
- **Container builds**: 45+ minutes timeout
- **NEVER CANCEL** long-running system setup commands - they are normal for machine bootstrap

## Validation and Testing

### Current Validation (Minimal Repository)
- Verify git operations work: `git --no-pager log --oneline -5`
- Confirm directory structure: `find . -type f ! -path './.git/*'`
- Test environment tools: `ansible-playbook --version && docker --version`

### Future Validation Scenarios  
When functionality is added, ALWAYS test these scenarios after making changes:
- **Full Bootstrap Test**: Run the complete machine setup on a clean system
- **Incremental Updates**: Test applying configuration changes to existing setups
- **Tool Installation**: Verify all required development tools install correctly
- **Configuration Application**: Ensure dotfiles, shell configs, and tool settings apply properly
- **Rollback Capability**: Test reverting changes if bootstrap fails partway through

### Manual Testing Requirements
After implementing bootstrap functionality:
1. **Test on clean environment**: Always validate bootstrap scripts work from scratch
2. **Verify idempotency**: Run bootstrap multiple times to ensure no errors on repeat runs
3. **Check all tool installations**: Manually verify each installed tool works correctly
4. **Test configuration application**: Ensure shell, editor, and development environment configs are applied
5. **Document any manual steps**: Note any steps that cannot be automated

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
1. **Start with Ansible**: Use `ansible-playbook` for system-level changes
2. **Add shell scripts**: For custom logic that Ansible cannot handle
3. **Include validation**: Always add tests to verify new functionality works
4. **Document timing**: Measure and document how long new operations take
5. **Test thoroughly**: Run complete bootstrap scenarios before committing

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
- **VALIDATE** that all installed tools work correctly after bootstrap
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