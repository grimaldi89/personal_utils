#!/bin/bash

set -e

echo "🔧 Installing zsh..."

# Check if zsh is already installed
if command -v zsh &> /dev/null; then
    echo "ℹ️ zsh is already installed."
    zsh --version
    exit 0
fi

# Install zsh using apt
echo "📦 Installing zsh via apt..."
sudo apt update
sudo apt install -y zsh

# Verify installation
if command -v zsh &> /dev/null; then
    echo "✅ zsh installed successfully!"
    zsh --version
else
    echo "❌ Failed to install zsh."
    exit 1
fi 