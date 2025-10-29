#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo pacman -S --noconfirm --needed \
  firefox git neovim stow go ghostty wl-clipboard hyprlock pamixer \
  waybar rofi-wayland github-cli zsh fzf thunar pavucontrol ttf-jetbrains-mono-nerd \
  zoxide atuin starship lsd luarocks lazygit dunst otf-font-awesome npm brightnessctl \
  blueman bat base-devel opentofu tmux jq pre-commit spotify-launcher hyprpaper hypridle \
  less

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
git config --global push.autoSetupRemote true
