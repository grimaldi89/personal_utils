#!/bin/bash

set -e

# 1. Detect current shell (same approach as alias/install_aliases.sh)
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

echo "🔧 Detected shell: $CURRENT_SHELL (using $RC_FILE)"

# 2. Prompt for variable name and value
read -p "🔑 Enter the variable name: " VAR_NAME
read -p "📦 Enter the value: " VAR_VALUE

# 3. Formatted export line
EXPORT_LINE="export $VAR_NAME=\"$VAR_VALUE\""

# 4. If the variable already exists, show current value and ask for confirmation
if grep -q "^export $VAR_NAME=" "$RC_FILE"; then
  CURRENT_VALUE=$(grep "^export $VAR_NAME=" "$RC_FILE" | sed -E 's/^export '"$VAR_NAME"'="?([^"]*)"?$/\1/')
  echo "⚠️ Variable '$VAR_NAME' already exists with value: $CURRENT_VALUE"
  read -p "❓ Do you want to overwrite it? [y/N]: " CONFIRM
  CONFIRM=${CONFIRM,,}  # convert to lowercase
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "yes" ]]; then
    echo "🚫 Cancelled. Variable was not modified."
    exit 0
  fi
  echo "🔁 Updating..."
  sed -i "s|^export $VAR_NAME=.*|$EXPORT_LINE|" "$RC_FILE"
else
  echo "✅ Adding new variable: $VAR_NAME"
  echo "$EXPORT_LINE" >> "$RC_FILE"
fi

# 5. Apply immediately to the current session
export "$VAR_NAME=$VAR_VALUE"
echo "🎉 Variable '$VAR_NAME' is now available and persistent."

if [[ "$CURRENT_SHELL" == "zsh" ]]; then
  echo "💡 To apply changes in new shells, run: source ~/.zshrc"
else
  source "$RC_FILE"
fi
