#!/bin/bash

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOCKER_SCRIPT="$SCRIPT_DIR/../tools/docker.sh"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
  echo "🐳 Docker not found. Running docker.sh..."

  if [ -f "$DOCKER_SCRIPT" ]; then
    chmod +x "$DOCKER_SCRIPT"
    "$DOCKER_SCRIPT"
  else
    echo "❌ docker.sh not found at $DOCKER_SCRIPT!"
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
