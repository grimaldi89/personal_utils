#!/bin/bash

set -e

echo "🔧 Checking and adding aliases to ~/.bashrc..."

ALIASES_FILE="$(dirname "$0")/aliases.sh"

if [ ! -f "$ALIASES_FILE" ]; then
  echo "❌ File $ALIASES_FILE not found!"
  exit 1
fi

while IFS= read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    continue
  fi

  if [[ "$line" =~ alias[[:space:]]+([a-zA-Z0-9_]+)=\'([^\']+)\' ]]; then
    ALIAS_NAME="${BASH_REMATCH[1]}"
    ALIAS_COMMAND="${BASH_REMATCH[2]}"
    
    # Check if alias exists in .bashrc
    if grep -q "^alias $ALIAS_NAME=" ~/.bashrc; then
      EXISTING_LINE=$(grep "^alias $ALIAS_NAME=" ~/.bashrc)
      EXISTING_COMMAND=$(echo "$EXISTING_LINE" | sed -E "s/alias $ALIAS_NAME='(.*)'/\1/")
      
      if [[ "$EXISTING_COMMAND" == "$ALIAS_COMMAND" ]]; then
        echo "ℹ️ Alias '$ALIAS_NAME' already exists with the same command. Skipping."
        continue
      else
        echo "⚠️ Alias '$ALIAS_NAME' exists with a different command:"
        echo "   Current:  alias $ALIAS_NAME='$EXISTING_COMMAND'"
        echo "   New:      alias $ALIAS_NAME='$ALIAS_COMMAND'"
        read -p "❓ Do you want to overwrite it? [y/N]: " CONFIRM < /dev/tty
        CONFIRM=${CONFIRM,,}  # to lowercase
        if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
          sed -i "s|^alias $ALIAS_NAME=.*|alias $ALIAS_NAME='$ALIAS_COMMAND'|" ~/.bashrc
          echo "✅ Alias '$ALIAS_NAME' updated."
        else
          echo "🚫 Skipped update for alias '$ALIAS_NAME'."
        fi
      fi
    else
      echo "$line" >> ~/.bashrc
      echo "✅ Alias '$ALIAS_NAME' added."
    fi

    # If the alias points to a file, ensure it's executable
    if [[ "$ALIAS_COMMAND" =~ ^(\./|/|~) ]]; then
      FILE_PATH="${ALIAS_COMMAND/#\~/$HOME}"
      if [ -f "$FILE_PATH" ]; then
        chmod +x "$FILE_PATH"
        echo "🔐 Made executable: $FILE_PATH"
      fi
    fi
  fi
done < "$ALIASES_FILE"

# Reload ~/.bashrc
source ~/.bashrc
echo "🎉 ~/.bashrc successfully updated!"
