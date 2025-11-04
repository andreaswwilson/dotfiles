#!/usr/bin/env bash
set -euo pipefail

# Install required packages
sudo pacman -S --noconfirm --needed \
  firefox git neovim stow go ghostty wl-clipboard hyprlock pamixer \
  waybar rofi-wayland github-cli zsh fzf thunar pavucontrol ttf-jetbrains-mono-nerd \
  zoxide atuin starship lsd luarocks lazygit dunst otf-font-awesome npm brightnessctl \
  blueman bat base-devel opentofu tmux jq pre-commit spotify-launcher hyprpaper hypridle \
  less shellcheck actionlint obsidian docker

if ! groups "$USER" | grep -q '\bdocker\b'; then
  sudo usermod -aG docker "$USER"
fi
if ! systemctl is-enabled --quiet docker.socket; then
  sudo systemctl enable docker.socket
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
git config --global push.autoSetupRemote true

# Check if paru is already installed
if ! command -v paru &>/dev/null; then
  echo "Paru not found. Proceeding with installation."
  # Create a temporary directory for building paru
  BUILD_DIR=$(mktemp -d)
  echo "Using temporary directory: $BUILD_DIR"
  cd "$BUILD_DIR" || exit 1

  # Clone paru repository
  echo "Cloning paru repository..."
  git clone https://aur.archlinux.org/paru.git

  # Build and install paru
  echo "Building and installing paru..."
  cd paru || exit 1
  makepkg -si --noconfirm

  # Cleanup: Remove the temporary directory
  echo "Cleaning up temporary build files..."
  rm -rf "$BUILD_DIR"

  echo "Paru installation complete."
fi
