# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
plugins=(
  zsh-autosuggestions
  git
)

# User configuration
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

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


# Powerlevel10k
source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/usr/local/sbin:$PATH"
