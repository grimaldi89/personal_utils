#!/bin/bash

set -e

echo "🔧 Checking and adding aliases to ~/.bash_aliases..."

ALIASES_FILE="$(dirname "$0")/alias.txt"

if [ ! -f "$ALIASES_FILE" ]; then
  echo "❌ File $ALIASES_FILE not found!"
  exit 1
fi

# Create .bash_aliases if it doesn't exist
if [ ! -f ~/.bash_aliases ]; then
  touch ~/.bash_aliases
  echo "📝 Created ~/.bash_aliases"
fi

# Ensure .bash_aliases is sourced in .bashrc
if ! grep -q "\.bash_aliases" ~/.bashrc; then
  echo "" >> ~/.bashrc
  echo "# Source aliases" >> ~/.bashrc
  echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
  echo "    . ~/.bash_aliases" >> ~/.bashrc
  echo "fi" >> ~/.bashrc
  echo "✅ Added .bash_aliases sourcing to ~/.bashrc"
fi

# Ensure the aliases file ends with a newline to handle the last line properly
if [ -s "$ALIASES_FILE" ]; then
  # Check if the file doesn't end with a newline
  if [ "$(tail -c1 "$ALIASES_FILE" 2>/dev/null | wc -l)" -eq 0 ]; then
    echo "" >> "$ALIASES_FILE"
  fi
fi

# Arrays to store aliases that need confirmation
declare -a ALIASES_TO_MOVE=()
declare -a ALIASES_TO_UPDATE=()
declare -a ALIASES_TO_OVERWRITE=()

# Function to check if alias is already in array
alias_in_array() {
  local alias_name="$1"
  local array_name="$2"
  local -n array_ref="$array_name"
  
  for item in "${array_ref[@]}"; do
    IFS='|' read -r name _ <<< "$item"
    if [[ "$name" == "$alias_name" ]]; then
      return 0  # Found
    fi
  done
  return 1  # Not found
}

while IFS= read -r line; do
  # Skip empty lines and comments
  if [[ -z "$line" || "$line" =~ ^# ]]; then
    continue
  fi

  if [[ "$line" =~ alias[[:space:]]+([a-zA-Z0-9_]+)=\'([^\']+)\' ]]; then
    ALIAS_NAME="${BASH_REMATCH[1]}"
    ALIAS_COMMAND="${BASH_REMATCH[2]}"
    
    # Check if alias exists in .bash_aliases
    if grep -q "^alias $ALIAS_NAME=" ~/.bash_aliases; then
      EXISTING_LINE=$(grep "^alias $ALIAS_NAME=" ~/.bash_aliases)
      EXISTING_COMMAND=$(echo "$EXISTING_LINE" | sed -E "s/alias $ALIAS_NAME='(.*)'/\1/")
      
      if [[ "$EXISTING_COMMAND" == "$ALIAS_COMMAND" ]]; then
        echo "ℹ️ Alias '$ALIAS_NAME' already exists in .bash_aliases with the same command. Skipping."
        continue
      else
        echo "⚠️ Alias '$ALIAS_NAME' exists in .bash_aliases with a different command:"
        echo "   Current:  alias $ALIAS_NAME='$EXISTING_COMMAND'"
        echo "   New:      alias $ALIAS_NAME='$ALIAS_COMMAND'"
        if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_OVERWRITE"; then
          ALIASES_TO_OVERWRITE+=("$ALIAS_NAME|$ALIAS_COMMAND")
        fi
      fi
    else
      # Check if alias exists in .bashrc
      if grep -q "^alias $ALIAS_NAME=" ~/.bashrc; then
        EXISTING_LINE=$(grep "^alias $ALIAS_NAME=" ~/.bashrc)
        EXISTING_COMMAND=$(echo "$EXISTING_LINE" | sed -E "s/alias $ALIAS_NAME='(.*)'/\1/")
        
        if [[ "$EXISTING_COMMAND" == "$ALIAS_COMMAND" ]]; then
          echo "⚠️ Alias '$ALIAS_NAME' exists in .bashrc with the same command."
          if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_MOVE"; then
            ALIASES_TO_MOVE+=("$ALIAS_NAME|$ALIAS_COMMAND")
          fi
        else
          echo "⚠️ Alias '$ALIAS_NAME' exists in .bashrc with a different command:"
          echo "   Current:  alias $ALIAS_NAME='$EXISTING_COMMAND'"
          echo "   New:      alias $ALIAS_NAME='$ALIAS_COMMAND'"
          if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_UPDATE"; then
            ALIASES_TO_UPDATE+=("$ALIAS_NAME|$ALIAS_COMMAND")
          fi
        fi
      else
        # Alias doesn't exist anywhere, add it to .bash_aliases
        echo "$line" >> ~/.bash_aliases
        echo "✅ Alias '$ALIAS_NAME' added to .bash_aliases."
      fi
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

# Handle aliases that need confirmation
for alias_info in "${ALIASES_TO_MOVE[@]}"; do
  IFS='|' read -r ALIAS_NAME ALIAS_COMMAND <<< "$alias_info"
  echo "⚠️ Alias '$ALIAS_NAME' exists in .bashrc with the same command."
  read -p "❓ Do you want to move it to .bash_aliases? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    # Remove from .bashrc and add to .bash_aliases
    sed -i "/^alias $ALIAS_NAME=/d" ~/.bashrc
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> ~/.bash_aliases
    echo "✅ Alias '$ALIAS_NAME' moved from .bashrc to .bash_aliases."
  else
    echo "🚫 Skipped moving alias '$ALIAS_NAME'."
  fi
done

for alias_info in "${ALIASES_TO_UPDATE[@]}"; do
  IFS='|' read -r ALIAS_NAME ALIAS_COMMAND <<< "$alias_info"
  echo "⚠️ Alias '$ALIAS_NAME' exists in .bashrc with a different command."
  read -p "❓ Do you want to replace it in .bashrc and add to .bash_aliases? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    # Replace in .bashrc and add to .bash_aliases
    sed -i "s|^alias $ALIAS_NAME=.*|alias $ALIAS_NAME='$ALIAS_COMMAND'|" ~/.bashrc
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> ~/.bash_aliases
    echo "✅ Alias '$ALIAS_NAME' updated in .bashrc and added to .bash_aliases."
  else
    echo "🚫 Skipped update for alias '$ALIAS_NAME'."
  fi
done

for alias_info in "${ALIASES_TO_OVERWRITE[@]}"; do
  IFS='|' read -r ALIAS_NAME ALIAS_COMMAND <<< "$alias_info"
  echo "⚠️ Alias '$ALIAS_NAME' exists in .bash_aliases with a different command."
  read -p "❓ Do you want to overwrite it? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    sed -i "s|^alias $ALIAS_NAME=.*|alias $ALIAS_NAME='$ALIAS_COMMAND'|" ~/.bash_aliases
    echo "✅ Alias '$ALIAS_NAME' updated in .bash_aliases."
  else
    echo "🚫 Skipped update for alias '$ALIAS_NAME'."
  fi
done

# Reload .bash_aliases
source ~/.bash_aliases
source ~/.bashrc
echo "🎉 ~/.bash_aliases successfully updated!"
