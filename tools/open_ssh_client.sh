#!/bin/bash

set -e

echo "🔐 Installing OpenSSH client..."

sudo apt-get update
sudo apt-get install -y openssh-client

echo "✅ OpenSSH client installed successfully."
