#!/usr/bin/env bash
set -euo pipefail

NAME="Andreas Wågø Wilson"
EMAIL="andreas.wilson@visma.com"

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

paru -Syu --noconfirm

# Packages to install with paru
packages=(
  google-chrome
  1password
  slack-desktop
  tflint-bin
)

for pkg in "${packages[@]}"; do
  if ! pacman -Q "$pkg" &>/dev/null; then
    paru -S --noconfirm --skipreview "$pkg"
  fi
done

sudo pacman -S docker --noconfirm --needed
echo "Checking Docker group membership for $USER..."
if ! groups "$USER" | grep -q '\bdocker\b'; then
  sudo usermod -aG docker "$USER"
fi
if ! systemctl is-enabled --quiet docker.socket; then
  sudo systemctl enable docker.socket
fi
git config --global user.email "$EMAIL"
git config --global user.name "$NAME"

# --- Configuration for GPG---
# runs ONLY if the key DOES NOT exist.
if ! gpg --list-keys "${EMAIL}" &>/dev/null; then

  echo "Key for '${EMAIL}' not found. Generating new key..."

  # 2. Create the Key
  gpg --batch --gen-key <<EOF
%echo Generating a new GPG key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: ${NAME}
Name-Email: ${EMAIL}
Expire-Date: 0
%no-protection
%commit
%echo Done
EOF
fi
if ! command -v pass &>/dev/null; then
  echo "'pass' (password-store) is not installed. Please install it first."
  exit 1
fi
#!/bin/bash

# Check if the directory exists
if [[ ! -d "$HOME/.password-store" ]]; then
  pass init $EMAIL
fi
