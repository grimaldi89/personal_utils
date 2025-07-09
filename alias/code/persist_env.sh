#!/bin/bash

set -e

# 1. Prompt for variable name and value
read -p "🔑 Enter the variable name: " VAR_NAME
read -p "📦 Enter the value: " VAR_VALUE

# 2. Formatted export line
EXPORT_LINE="export $VAR_NAME=\"$VAR_VALUE\""

# 3. If the variable already exists, show current value and ask for confirmation
if grep -q "^export $VAR_NAME=" ~/.bashrc; then
  CURRENT_VALUE=$(grep "^export $VAR_NAME=" ~/.bashrc | sed -E 's/^export '"$VAR_NAME"'="?([^"]*)"?$/\1/')
  echo "⚠️ Variable '$VAR_NAME' already exists with value: $CURRENT_VALUE"
  read -p "❓ Do you want to overwrite it? [y/N]: " CONFIRM
  CONFIRM=${CONFIRM,,}  # convert to lowercase
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "yes" ]]; then
    echo "🚫 Cancelled. Variable was not modified."
    exit 0
  fi
  echo "🔁 Updating..."
  sed -i "s|^export $VAR_NAME=.*|$EXPORT_LINE|" ~/.bashrc
else
  echo "✅ Adding new variable: $VAR_NAME"
  echo "$EXPORT_LINE" >> ~/.bashrc
fi

# 4. Apply immediately to the current session
export "$VAR_NAME=$VAR_VALUE"
echo "🎉 Variable '$VAR_NAME' is now available and persistent."
