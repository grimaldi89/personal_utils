#!/bin/bash

set -e

echo "🔧 Installing Oh My Zsh..."

# Check if Oh My Zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "ℹ️ Oh My Zsh is already installed."
    echo "Location: $HOME/.oh-my-zsh"
    exit 0
fi

# Check if zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "❌ zsh is not installed. Please install zsh first."
    echo "Run: bash tools/zsh.sh"
    exit 1
fi

# Install Oh My Zsh using curl
echo "📦 Installing Oh My Zsh via curl..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Verify installation
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh installed successfully!"
    echo "Location: $HOME/.oh-my-zsh"
    echo ""
    echo "To start using zsh, run: zsh"
    echo "To set zsh as default shell, run: chsh -s $(which zsh)"
else
    echo "❌ Failed to install Oh My Zsh."
    exit 1
fi 