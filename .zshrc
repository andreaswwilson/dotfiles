# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/andreas.wilson/.zshrc'

fpath+=(~/.local/share/zsh/site-functions)
autoload -Uz compinit
compinit
# End of lines added by compinstall
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Plugins
source ~/antigen.zsh
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle ohmyzsh/ohmyzsh plugins/git
antigen bundle ohmyzsh/ohmyzsh plugins/aws
antigen apply

# Export
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export EDITOR=nvim
export VISUAL=$EDITOR

# Paths
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH
export PATH="$PATH:$HOME/.local/bin"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Alias
alias vim="nvim"
alias v="nvim"
alias ls="lsd"
alias l="ls -la"
alias lt="ls --tree"
alias cat="bat --style=header-filename"
alias k="kubectl"
alias c="cloudctl"

#Eval
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(direnv hook zsh)"
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(/usr/bin/starship init zsh)"
  }
if [[ "$USER" == "andreaswilson" ]]; then
  eval "$(op completion zsh)"
  compdef _op op
fi

# Defer until after zsh-vi-mode resets zle widgets.
# Use `command -v` not `$commands[kubectl]` — zvm_exec_commands shadows $commands with a local var.
zvm_after_init_commands+=(
  'source ~/.zsh/completions/_k3d'
  'command -v kubectl > /dev/null && source <(kubectl completion zsh) && compdef k=kubectl'
)

# opencode
export PATH=/home/andreas.wilson/.opencode/bin:$PATH

# confluence — wraps ~/.local/bin/confluence with 1Password-injected PAT
confluence() { op run --env-file="$HOME/.config/confluence/env" -- "$HOME/.local/bin/confluence" "$@"; }

