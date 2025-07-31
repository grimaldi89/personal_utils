#!/bin/bash
set -e

echo "🔧 Installing ripgrep..."

# Check if ripgrep is already installed
if command -v rg &> /dev/null; then
    echo "ℹ️ ripgrep is already installed."
    rg --version
    exit 0
fi

echo "📦 Installing ripgrep via apt..."

# Update package list
echo "🔄 Updating package list..."
sudo apt update

# Install ripgrep
echo "📥 Installing ripgrep..."
sudo apt install -y ripgrep

# Verify installation
if command -v rg &> /dev/null; then
    echo "✅ ripgrep installed successfully!"
    rg --version
    echo "💡 You can now use 'rg' command for fast text search"
    echo "📍 Command location: $(which rg)"
else
    echo "❌ Failed to install ripgrep."
    exit 1
fi 