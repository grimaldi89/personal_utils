#!/bin/bash

set -e

echo "🚀 Installing Cursor..."

# Check if Cursor is already installed
if command -v cursor >/dev/null 2>&1; then
    echo "✅ Cursor is already installed!"
    echo "🔧 You can run it with: cursor"
    exit 0
fi

# Check if snap is available
if ! command -v snap >/dev/null 2>&1; then
    echo "❌ Snap is not installed on this system"
    echo "💡 Please install snap first or use alternative methods:"
    echo "   1. Install snap: sudo apt install snapd"
    echo "   2. Flatpak: flatpak install flathub com.cursor.Cursor"
    echo "   3. Manual: Download from https://cursor.com"
    exit 1
fi

echo "📦 Installing Cursor via Snap..."
echo "💡 This is the easiest and most reliable method"

# Install Cursor via snap
sudo snap install cursor

# Verify installation
if command -v cursor >/dev/null 2>&1; then
    echo "✅ Cursor installed successfully!"
    echo "🔧 You can run it with: cursor"
    echo "🎯 Cursor is now available in your applications menu"
else
    echo "❌ Installation failed. Please try manually:"
    echo "   sudo snap install cursor"
    exit 1
fi
