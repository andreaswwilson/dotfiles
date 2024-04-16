# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Start custom
setopt HIST_IGNORE_ALL_DUPS

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v
export NVM_DIR="$HOME/.nvm"
export JAVA_HOME=$(/usr/libexec/java_home -v 11) # Sets default java to 11
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export AURORA_DIR="$HOME/.config/aurora"
[[ -d "$AURORA_DIR" ]] || mkdir -p $AURORA_DIR
export SKE_ROOT_CA="$AURORA_DIR/SKEROOTCA.pem"
[[ -s "$SKE_ROOT_CA" ]] || security find-certificate -c SKEROOTCA -p > $SKE_ROOT_CA
chmod 755 $SKE_ROOT_CA
[[ -d "$HOME/bin" ]] || mkdir -p $HOME/bin
export PATH=$PATH:/usr/local/bin:$HOME/bin
export NODE_EXTRA_CA_CERTS=$SKE_ROOT_CA
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Aliases
alias vim="nvim"
alias v="vim"
alias sed="gsed"
alias awk="gawk"
alias cat="bat --style=grid,header"
alias ls="lsd"
alias l="ls -la"
alias la="ls -a"
alias lt="ls --tree"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
