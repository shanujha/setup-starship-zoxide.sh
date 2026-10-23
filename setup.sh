#!/usr/bin/env bash

set -e

echo "==> Updating system"
sudo apt update && sudo apt upgrade -y

echo "==> Installing dependencies"
sudo apt install -y curl wget git unzip aptitude zoxide

echo "==> Installing Starship"

TMP_SCRIPT="/tmp/starship-install.sh"

curl -fsSL https://starship.rs/install.sh -o "$TMP_SCRIPT"

chmod +x "$TMP_SCRIPT"

sudo "$TMP_SCRIPT" -y

echo "==> Creating config directory"
mkdir -p ~/.config

echo "==> Setting Starship preset: Pure Prompt"

starship preset pure-preset -o ~/.config/starship.toml

BASHRC="$HOME/.bashrc"

echo "==> Configuring bashrc"

# Starship
if ! grep -q 'starship init bash' "$BASHRC"; then
    echo '' >> "$BASHRC"
    echo '# Starship' >> "$BASHRC"
    echo 'eval "$(starship init bash)"' >> "$BASHRC"
fi

# zoxide
if ! grep -q 'zoxide init bash' "$BASHRC"; then
    echo '' >> "$BASHRC"
    echo '# zoxide' >> "$BASHRC"
    echo 'eval "$(zoxide init bash)"' >> "$BASHRC"
fi

echo "==> Reloading bashrc"

source "$BASHRC"

echo
echo "Setup complete."
echo "Restart terminal if prompt does not refresh immediately."
