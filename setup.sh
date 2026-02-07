#!/bin/bash

ERRORS=()

try_run() {
  local label="$1"
  shift
  echo "=> $label"
  if ! "$@"; then
    echo "  FAILED: $label"
    ERRORS+=("$label")
  fi
}

# Update package lists
try_run "Update apt package lists" sudo apt update

# Install essentials
try_run "Install git, curl, unzip" sudo apt install -y git curl unzip

# Install zsh if not present
if ! command -v zsh &> /dev/null; then
  try_run "Install zsh" sudo apt install -y zsh
fi

# Set zsh as default shell
try_run "Set zsh as default shell" chsh -s "$(which zsh)"

# Install Oh My Zsh (unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  try_run "Install Oh My Zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  try_run "Install powerlevel10k" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  try_run "Install zsh-syntax-highlighting" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  try_run "Install zsh-autosuggestions" git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  try_run "Install zsh-completions" git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

# Install GitHub CLI
if ! command -v gh &> /dev/null; then
  try_run "Install GitHub CLI" sudo apt install -y gh
fi

# Install Go
if ! command -v go &> /dev/null; then
  try_run "Install Go" sudo apt install -y golang-go
fi

# Install Node.js via nvm (apt version is outdated)
if ! command -v node &> /dev/null; then
  export NVM_DIR="$HOME/.nvm"
  if [ ! -d "$NVM_DIR" ]; then
    try_run "Install nvm" bash -c "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
  fi
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  try_run "Install Node.js LTS via nvm" nvm install --lts
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
  try_run "Install Claude Code" bash -c "curl -fsSL https://claude.ai/install.sh | bash"
fi

# Install OpenAI Codex
if ! command -v codex &> /dev/null; then
  try_run "Install OpenAI Codex" npm i -g @openai/codex
fi

# Write .zshrc
echo "=> Writing ~/.zshrc..."
cat > ~/.zshrc << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
source $ZSH/oh-my-zsh.sh

cd ~

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

alias cc="claude --dangerously-skip-permissions"
alias explorer='/mnt/c/Windows/explorer.exe'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
EOF

# Summary
echo ""
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo "Completed with ${#ERRORS[@]} error(s):"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
  echo ""
fi
echo "Done! Run 'p10k configure' to set up your prompt theme."
echo "Restart your terminal or run 'zsh' to start using the new config."
echo ""
echo "IMPORTANT: Make sure /etc/wsl.conf contains the following:"
echo ""
echo "  [interop]"
echo "  appendWindowsPath=false"
echo ""
echo "Run 'sudo nano /etc/wsl.conf' to edit it."
echo ""
echo "Don't forget to authenticate GitHub CLI: gh auth login"
