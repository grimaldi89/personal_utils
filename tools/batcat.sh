#!/bin/bash

set -e

echo "🔧 Installing bat..."

# Check if bat is already installed
if command -v batcat &> /dev/null; then
    echo "ℹ️ bat is already installed."
    batcat --version
    exit 0
fi

# Install bat using apt
echo "📦 Installing bat via apt..."
sudo apt update
sudo apt install -y bat

# Verify installation
if command -v batcat &> /dev/null; then
    echo "✅ bat installed successfully!"
    batcat --version
else
    echo "❌ Failed to install bat."
    exit 1
fi 