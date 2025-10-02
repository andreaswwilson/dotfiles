# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/andreas.wilson/.zshrc'

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
antigen apply

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export EDITOR=nvim
export VISUAL=$EDITOR

# Alias
alias vim="nvim"
alias v="nvim"
alias ls="lsd"
alias l="ls -la"
alias lt="ls --tree"
alias cat="bat --style=grid,header"

#Eval
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)" #curl -sS https://starship.rs/install.sh | sh
