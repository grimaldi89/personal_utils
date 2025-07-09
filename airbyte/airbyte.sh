#!/bin/bash

set -e

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "🐳 Docker not found. Running docker.sh..."

  if [ -f "./docker.sh" ]; then
    chmod +x ./docker.sh
    ./docker.sh
  else
    echo "❌ docker.sh not found in the current directory!"
    exit 1
  fi
else
  echo "✅ Docker is already installed."
fi

# Install Airbyte
echo "📦 Installing Airbyte..."
curl -LsfS https://get.airbyte.com | bash -

# Install Airbyte locally using abctl
echo "⚙️ Running Airbyte local install with abctl..."
abctl local install 

# Set up credentials
echo "🔐 Setting up credentials..."
abctl local credentials

echo "🎉 Airbyte successfully installed!"
