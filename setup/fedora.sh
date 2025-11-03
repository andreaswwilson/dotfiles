#!/usr/bin/env bash
set -euo pipefail

# sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# sudo dnf install -y fedora-workstation-repositories
# sudo dnf config-manager setopt google-chrome.enabled=1

sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf copr enable atim/starship -y
sudo dnf copr enable scottames/ghostty -y
sudo dnf copr enable dejan/lazygit -y

sudo dnf install -y git gh neovim google-chrome-stable stow 1password 1password-cli zsh go lsd fd ripgrep \
  fzf atuin zoxide starship pass ghostty bat lazygit

# Change shell only if not already zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(which zsh)"
fi
# sudo dnf upgrade --refresh

EMAIL="andreas.wilson@visma.com"
NAME="Andreas Wågø Wilson"
if ! gpg --list-keys "${EMAIL}" &>/dev/null; then
  gh auth login -s write:gpg_key

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

if ! gh auth status -t 2>&1 | grep -q "write:gpg_key"; then
  echo "Refreshing GitHub auth to add 'write:gpg_key' scope..."
  gh auth refresh -s write:gpg_key
fi
LOCAL_KEY_FINGERPRINT=$(gpg --list-keys --with-colons "${EMAIL}" | grep '^fpr' | head -n 1 | cut -d: -f10)

if [ -z "${LOCAL_KEY_FINGERPRINT}" ]; then
  echo "Error: Could not find fingerprint for local key with email ${EMAIL}." >&2
  exit 1
fi
git config --global user.email "$EMAIL"
git config --global push.autoSetupRemote true
git config --global user.name "$NAME"
git config --global user.signingkey "${LOCAL_KEY_FINGERPRINT}"
git config --global commit.gpgsign true

LOCAL_PUBLIC_KEY=$(gpg --armor --export "${LOCAL_KEY_FINGERPRINT}")
is_local_key_present=false

while read -r key_json; do
  GITHUB_PUBLIC_KEY=$(echo "$key_json" | jq -r '.raw_key')

  if [ "${GITHUB_PUBLIC_KEY}" == "${LOCAL_PUBLIC_KEY}" ]; then
    is_local_key_present=true
    break # Key found, no need to check the rest
  fi
done < <(gh api user/gpg_keys | jq -c '.[]')

if [ "$is_local_key_present" = false ]; then
  echo "Local key not found on GitHub. Adding it..."
  echo "${LOCAL_PUBLIC_KEY}" | gh gpg-key add - --title "Local Key (Added by script)"
  echo "Local key added successfully."
fi

# Check if the directory exists
if [[ ! -d "$HOME/.password-store" ]]; then
  pass init $EMAIL
fi

# Nerd font
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
FONT_DIR="$HOME/.local/share/fonts"
CHECK_FILE="$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf"
TMP_FILE="/tmp/JetBrainsMono.zip"
for cmd in wget unzip fc-cache fc-list swaymsg rg; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Required command '$cmd' is not installed." >&2
    echo "Please install it and try again." >&2
    exit 1
  fi
done

if [ ! -f "$CHECK_FILE" ]; then
  echo "Font file '$CHECK_FILE' not found. Proceeding with installation..."

  echo "Downloading font from $FONT_URL..."
  wget -q --show-progress -O "$TMP_FILE" "$FONT_URL"

  echo "Ensuring font directory exists: $FONT_DIR"
  mkdir -p "$FONT_DIR"

  echo "Installing font..."
  unzip -q -o "$TMP_FILE" -d "$FONT_DIR"

  echo "Cleaning up temporary file..."
  rm "$TMP_FILE"

  echo "Updating font cache (this may take a moment)..."
  fc-cache -fv >/dev/null

  echo "------------------------------------------------"
  echo "✅ JetBrainsMono Nerd Font installed successfully!"

  echo "Reloading Sway config..."
  swaymsg reload
fi
[ ! -d "~/.tmux/plugins/tpm" ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
