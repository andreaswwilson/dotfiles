#!/usr/bin/env bash
set -euo pipefail

rm -rf ~/.config
# Install required packages
sudo pacman -Syu --noconfirm --needed \
  firefox git neovim stow go ghostty wl-clipboard hyprlock pamixer \
  waybar rofi-wayland github-cli zsh fzf thunar pavucontrol ttf-jetbrains-mono-nerd \
  zoxide atuin starship lsd luarocks lazygit dunst otf-font-awesome npm brightnessctl \
  blueman tmux bat

DOTFILES_ROOT="${HOME}/dotfiles"
DOT_PACKAGE_DIR="${DOTFILES_ROOT}/dot" # The directory containing your dotfiles
if [ -d "$DOT_PACKAGE_DIR" ]; then
  (
    echo "Stowing dotfiles from ${DOT_PACKAGE_DIR} into $HOME..."
    cd "$DOTFILES_ROOT"
    stow -t "$HOME" dot
  )
else
  echo "Error: Dotfiles package directory '${DOT_PACKAGE_DIR}' not found. Skipping stow." >&2
fi
# ----------------------------------------------------------------------

# Change shell only if not already zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi

# Remove kitty if installed
if pacman -Q kitty &>/dev/null; then
  echo "Removing kitty..."
  sudo pacman -Rns --noconfirm kitty
fi
