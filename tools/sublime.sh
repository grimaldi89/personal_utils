#!/bin/bash
set -e

echo "🔧 Installing Sublime Text..."

# Check if Sublime Text is already installed
if command -v subl &> /dev/null; then
    echo "ℹ️ Sublime Text is already installed."
    subl --version
    
    # Check if it's installed via snap
    if [[ "$(which subl)" == "/snap/bin/subl" ]]; then
        echo "⚠️  Sublime Text is installed via Snap."
        echo "📋 Options:"
        echo "  1) Keep Snap version (exit)"
        echo "  2) Remove Snap version and install via apt"
        read -p "➡️  Enter your choice [1]: " REMOVE_CHOICE
        
        if [[ "$REMOVE_CHOICE" == "2" ]]; then
            echo "🗑️  Removing Snap version..."
            sudo snap remove sublime-text
            echo "✅ Snap version removed."
        else
            echo "✅ Keeping Snap version."
            exit 0
        fi
    else
        echo "✅ Sublime Text is installed via apt."
        exit 0
    fi
fi

echo "📦 Installing Sublime Text via apt..."

# Install apt-transport-https
echo "🔧 Installing apt-transport-https..."
sudo apt-get install -y apt-transport-https

# Add Sublime Text repository
echo "🔑 Adding Sublime Text repository..."

# Select channel
echo "📋 Select the channel to use:"
echo "  1) Stable (recommended)"
echo "  2) Dev"
read -p "➡️  Enter your choice [1]: " CHANNEL_CHOICE

# Set channel based on choice
if [[ "$CHANNEL_CHOICE" == "2" ]]; then
    CHANNEL="dev"
    echo "🎯 Selected: Dev channel"
else
    CHANNEL="stable"
    echo "🎯 Selected: Stable channel"
fi

# Add repository to sources
echo "📝 Adding repository to sources..."
echo "deb https://download.sublimetext.com/ apt/$CHANNEL/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Update package list
echo "🔄 Updating package list..."
sudo apt-get update

# Install Sublime Text
echo "📥 Installing Sublime Text..."
sudo apt-get install -y sublime-text

# Verify installation
if command -v subl &> /dev/null; then
    echo "✅ Sublime Text installed successfully!"
    subl --version
    echo "💡 You can now use 'subl' command to open Sublime Text"
    echo "📋 Channel used: $CHANNEL"
    echo "📦 Installation method: apt"
    echo "📍 Command location: $(which subl)"
else
    echo "❌ Failed to install Sublime Text."
    exit 1
fi 