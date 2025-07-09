#!/bin/bash

set -e

echo "🔄 Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "📝 Installing gedit text editor..."
sudo apt install -y gedit

echo "✅ gedit installed successfully!"
