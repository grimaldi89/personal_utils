#!/bin/bash

set -eo pipefail

echo "🐍 Installing pyenv..."

if command -v pyenv &> /dev/null || [ -d "$HOME/.pyenv" ]; then
  echo "✅ pyenv is already installed."
  echo "🔧 Location: $HOME/.pyenv"
else
  echo "📦 Installing pyenv build dependencies..."
  sudo apt-get update -y
  sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git

  echo "⬇️ Installing pyenv via the official installer..."
  curl -fsSL https://pyenv.run | bash
fi

# Detect current shell (same approach as alias/install_aliases.sh)
CURRENT_SHELL=$(basename "$SHELL")
if [ -z "$CURRENT_SHELL" ]; then
  CURRENT_SHELL=$(ps -p $$ -o comm=)
fi
if [[ "$CURRENT_SHELL" == "bash" ]]; then
  PARENT_SHELL=$(ps -o comm= -p $PPID)
  if [[ "$PARENT_SHELL" == "zsh" ]]; then
    CURRENT_SHELL="zsh"
  fi
fi

if [[ "$CURRENT_SHELL" == "zsh" ]]; then
  RC_FILE="$HOME/.zshrc"
else
  RC_FILE="$HOME/.bashrc"
fi

if [ ! -f "$RC_FILE" ]; then
  touch "$RC_FILE"
fi

echo "⚙️ Configuring pyenv in $RC_FILE..."

if ! grep -q "PYENV_ROOT" "$RC_FILE"; then
  {
    echo ''
    echo '# pyenv'
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    echo "eval \"\$(pyenv init - $CURRENT_SHELL)\""
  } >> "$RC_FILE"
  echo "✅ Added pyenv initialization to $RC_FILE"
else
  echo "ℹ️ pyenv initialization already present in $RC_FILE"
fi

echo "🎉 pyenv installed successfully!"
echo "💡 Restart your shell or run: source $RC_FILE"
echo "💡 Then install a Python version with: pyenv install 3.12.4 && pyenv global 3.12.4"
