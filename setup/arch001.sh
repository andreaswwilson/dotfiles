#!/usr/bin/env bash
set -euo pipefail

# Get absolute path to dotfiles root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ask for sudo once and keep alive
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Install required packages
sudo pacman -Syu --noconfirm --needed \
  firefox git neovim stow go ghostty wl-clipboard \
  waybar rofi-wayland github-cli zsh fzf \
  zoxide atuin starship lsd luarocks lazygit

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

# Stow only the .config folder
stow -d "$DOTFILES_DIR" -t "$HOME/.config" .config

# Symlink top-level dotfiles manually
for file in "$DOTFILES_DIR"/.*; do
  name="$(basename "$file")"
  [[ "$name" == "." || "$name" == ".." || "$name" == ".config" ]] && continue
  [[ -f "$file" ]] && ln -sf "$file" "$HOME/$name"
done
# Change shell only if not already zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# Remove kitty if installed
if pacman -Q kitty &>/dev/null; then
  sudo pacman -Rns --noconfirm kitty
fi
