#!/bin/bash

set -e

echo "🔧 Installing eza..."

# Check if eza is already installed
if command -v eza &> /dev/null; then
    echo "ℹ️ eza is already installed."
    eza --version
    exit 0
fi

# Install eza using apt
echo "📦 Installing eza via apt..."
sudo apt update
sudo apt install -y eza

# Verify installation
if command -v eza &> /dev/null; then
    echo "✅ eza installed successfully!"
    eza --version
else
    echo "❌ Failed to install eza."
    exit 1
fi 