#!/usr/bin/env zsh
# -*- coding: utf-8 -*-

####################################
# 1) FAST EARLY ENV (keep this lean)
####################################

export DOTFILES_PATH="$HOME/code/github/austinogilvie/dotfiles"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='code --wait'
export TERM="xterm-256color"

# Locale
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"

# Fast PATH baseline (no brew calls here)
export PATH="/opt/homebrew/bin:$PATH"

####################################
# 2) OH-MY-ZSH CONFIG (must be before sourcing OMZ)
####################################

ZSH_THEME="robbyrussell"
plugins=(git z jsontools isodate)

# Completion UI (OMZ reads/uses these after load too, fine here)
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

####################################
# 3) SOURCE OH-MY-ZSH
####################################

source "$ZSH/oh-my-zsh.sh"

####################################
# 4) POST-OMZ OVERRIDES (win over plugins/themes)
####################################

# Ensure our ls() wrapper isn't shadowed by oh-my-zsh aliases
# see ~/.zshfunctions/ls
unalias ls 2>/dev/null

####################################
# 5) FUNCTIONS / FPAT H / PERSONAL ALIASES (your stuff should win)
####################################

fpath=("$HOME/.zshfunctions" "$HOME/.zsh/completions" $fpath)

autoload -Uz \
  cwd github last_cmd_status mkd o c zmv \
  url_clean url_humanize \
  ls lt lh lsd lsn \
  wifi_qr_code ebookify cleanup ccat g_ignore \
  watch_dirs setup_workspace_excludes tree \
  copy_and_clear_line remove_spaces

# Your aliases (keep after OMZ so they override common-aliases/etc.)
[ -f "$HOME/.aliases.zsh" ] && source "$HOME/.aliases.zsh"

####################################
# 6) COMPLETION INIT (single, consistent compinit)
####################################

autoload -U compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ -f "${ZSH_COMPDUMP}.zwc" ]]; then
  compinit -C
else
  compinit
  [[ -f "$ZSH_COMPDUMP" ]] && zcompile "$ZSH_COMPDUMP"
fi

####################################
# 7) KEYBINDINGS + SHELL OPTIONS (interactive niceties)
####################################

# Keybindings
zle -N copy_and_clear_line
bindkey "^X^Y" copy_and_clear_line
bindkey "^U" backward-kill-line
bindkey "^T" transpose-words
bindkey "^R" history-incremental-search-backward
bindkey "^[." insert-last-word
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey "^G" send-break
bindkey "^X^E" vi-editing-mode
bindkey "^W" backward-kill-word
bindkey "^X^V" expand-history
bindkey "^Q" push-line-or-edit

# Options
setopt correct

####################################
# HISTORY SETTINGS
####################################

export SAVEHIST=500000
export HISTSIZE=500000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HIST_STAMPS="yyyy-mm-dd"

setopt EXTENDED_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE    # do not record any line starting with a space

####################################
# PATH & TOOLING (slower / bulkier stuff later)
####################################

# Avoid repeated `brew --prefix` calls
if (( $+commands[brew] )); then
  _BREW_PREFIX="$(brew --prefix)"
fi

export PATH="$HOME/Library/Python/3.11/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
export JUPYTER_PATH="/opt/homebrew/share/jupyter:${JUPYTER_PATH:-}"


if [[ -n "$_BREW_PREFIX" ]]; then
  export PATH="${_BREW_PREFIX}/opt/ruby/bin:$PATH"
  export PATH="${_BREW_PREFIX}/lib/ruby/gems/3.2.0/bin:$PATH"
fi

export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.cargo/bin:$PATH"

export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
export CLAUDE_INSTALL_METHOD=homebrew
export YDATA_PROFILING_NO_ANALYTICS=True

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

####################################
# PERSONAL / SECRETS / ONE-OFFS
####################################

[ -f "$HOME/.config/zsh/set_pycache_prefix.zsh" ] && source "$HOME/.config/zsh/set_pycache_prefix.zsh"
[ -f "$HOME/.env_private" ] && source "$HOME/.env_private"
[ -f "$HOME/.api_keys" ] && source "$HOME/.api_keys"

if [[ -x "$HOME/.greetoftheday" ]]; then
  "$HOME/.greetoftheday"
fi

####################################
# SYNTAX HIGHLIGHTING (must be last)
####################################

if [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
export PATH="$PATH:$(go env GOPATH)/bin"
export WINGMAN_SKIP_HOOKS=1
export ANTHROPIC_MODEL=opus
