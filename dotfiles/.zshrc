# Kamaete - Zsh Configuration
# This file is managed by Kamaete dotfiles system

# Environment Variables
export EDITOR=nvim
export VISUAL=nvim

# Path Configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/bin:$PATH"

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# Load aliases
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# Load additional configurations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Prompt customization (simple but informative)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{yellow}${vcs_info_msg_0_}%f$ '
