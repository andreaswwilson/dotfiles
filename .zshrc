eval $(/opt/homebrew/bin/brew shellenv)

export ZSH="$HOME/.oh-my-zsh"
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode auto      # update automatically without asking

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/config.json)"
eval "$(atuin init zsh)"
#
# Alias
alias vim="nvim"
alias v="nvim"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
