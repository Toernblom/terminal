#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Ensure fonts are installed
"$SCRIPT_DIR/install-fonts.sh"

echo "=> Deploying .zshrc..."
cp "$SCRIPT_DIR/.zshrc" ~/.zshrc

echo "=> Deploying .p10k.zsh..."
cp "$SCRIPT_DIR/.p10k.zsh" ~/.p10k.zsh

echo ""
echo "Done! Restart your terminal or run 'source ~/.zshrc' to apply."
