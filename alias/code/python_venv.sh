#!/bin/bash

set -e

# 1. Ask for the venv name if not passed as argument
if [ -z "$1" ]; then
  read -p "📛 Enter a name for the virtual environment: " VENV_NAME
else
  VENV_NAME="$1"
fi

# 2. Ensure Python 3 is installed
echo "🐍 Checking for Python 3..."
if ! command -v python3 &> /dev/null; then
  echo "❌ Python 3 is not installed. Please install it first."
  exit 1
fi
echo "✅ Python 3 is available: $(python3 --version)"

# 3. Make sure python3-venv is installed
echo "🔄 Ensuring python3-venv is installed or up to date..."

sudo apt-get install -y python3-venv

# 4. Create the virtual environment
echo "📁 Creating virtual environment: $VENV_NAME"
python3 -m venv "$VENV_NAME"

echo "✅ Virtual environment '$VENV_NAME' created successfully!"
echo "💡 To activate it, run: source $VENV_NAME/bin/activate"
