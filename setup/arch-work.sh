#!/usr/bin/env bash
set -euo pipefail
sudo pacman -Syu --noconfirm
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

if ! command -v google-chrome-stable &>/dev/null; then
  paru -S --noconfirm --skipreview google-chrome
fi
if ! command -v 1password &>/dev/null; then
  paru -S --noconfirm --skipreview 1password
fi

if ! command -v slack-desktop &>/dev/null; then
  paru -S --noconfirm --skipreview slack-desktop
fi

git config --global user.email "andreas.wilson@vimsa.com"
git config --global user.name "Andreas Wågø Wilson"
