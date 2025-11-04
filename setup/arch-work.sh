#!/usr/bin/env bash
set -euo pipefail

NAME="Andreas Wågø Wilson"
EMAIL="andreas.wilson@visma.com"

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

if ! pacman -Q twingate &>/dev/null; then
  curl https://binaries.twingate.com/client/linux/ARCH/x86_64/stable/twingate-amd64.pkg.tar.zst --output twingate.pkg.tar.zst
  pacman -U --noconfirm twingate.pkg.tar.zst
  rm twingate.pgk.tar.zst
  sudo twingate setup
fi

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
git config --global user.name "$NAME"
git config --global user.signingkey "${LOCAL_KEY_FINGERPRINT}"
git config --global commit.gpgsign true

LOCAL_PUBLIC_KEY=$(gpg --armor --export "${LOCAL_KEY_FINGERPRINT}")
is_local_key_present=false

while read -r key_json; do
  GITHUB_KEY_ID=$(echo "$key_json" | jq -r '.id')
  GITHUB_PUBLIC_KEY=$(echo "$key_json" | jq -r '.raw_key')

  if [ "${GITHUB_PUBLIC_KEY}" == "${LOCAL_PUBLIC_KEY}" ]; then
    is_local_key_present=true
  else
    echo "Mismatch: Deleting old/unmatched key ID ${GITHUB_KEY_ID} from GitHub..."
    # Use --yes to skip the interactive confirmation prompt
    gh gpg-key delete "${GITHUB_KEY_ID}" --yes
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
