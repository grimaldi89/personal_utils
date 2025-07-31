#!/bin/bash

set -e

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
if [ -z "$CURRENT_SHELL" ]; then
    CURRENT_SHELL=$(ps -p $$ -o comm=)
fi

# Check if we're in a zsh environment but running bash
if [[ "$CURRENT_SHELL" == "bash" ]]; then
    # Check parent shell
    PARENT_SHELL=$(ps -o comm= -p $PPID)
    
    if [[ "$PARENT_SHELL" == "zsh" ]]; then
        CURRENT_SHELL="zsh"
    fi
    
    # Also check if we're in a zsh terminal (check for zsh in process tree)
    if command -v pgrep >/dev/null 2>&1; then
        if pgrep -f "zsh" >/dev/null 2>&1; then
            # Check if we're in a zsh session by looking at the terminal
            if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ "$TERM_PROGRAM" == "cursor" ]]; then
                # In VS Code/Cursor, check if the parent process is zsh
                GRANDPARENT_SHELL=$(ps -o comm= -p $(ps -o ppid= -p $PPID))
                if [[ "$GRANDPARENT_SHELL" == "zsh" ]]; then
                    CURRENT_SHELL="zsh"
                fi
            fi
        fi
    fi
fi

echo "🔧 Detected shell: $CURRENT_SHELL"

# Set appropriate files based on shell
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    ALIASES_FILE="$(dirname "$0")/alias.txt"
    ALIASES_TARGET="$HOME/.zshrc"
    ALIASES_SECTION="# Personal aliases"
    echo "🎯 Using zsh configuration..."
else
    ALIASES_FILE="$(dirname "$0")/alias.txt"
    ALIASES_TARGET="$HOME/.bash_aliases"
    ALIASES_SECTION="# Personal aliases"
    echo "🎯 Using bash configuration..."
fi

echo "🔧 Checking and adding aliases to $ALIASES_TARGET..."

if [ ! -f "$ALIASES_FILE" ]; then
  echo "❌ File $ALIASES_FILE not found!"
  exit 1
fi

# Create target file if it doesn't exist
if [ ! -f "$ALIASES_TARGET" ]; then
  touch "$ALIASES_TARGET"
  echo "📝 Created $ALIASES_TARGET"
fi

# For bash: Ensure .bash_aliases is sourced in .bashrc
if [[ "$CURRENT_SHELL" == "bash" ]]; then
  if ! grep -q "\.bash_aliases" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Source aliases" >> ~/.bashrc
    echo "if [ -f ~/.bash_aliases ]; then" >> ~/.bashrc
    echo "    . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
    echo "✅ Added .bash_aliases sourcing to ~/.bashrc"
  fi
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
    
    # Check if alias exists in target file
    if grep -q "^alias $ALIAS_NAME=" "$ALIASES_TARGET"; then
      EXISTING_LINE=$(grep "^alias $ALIAS_NAME=" "$ALIASES_TARGET")
      EXISTING_COMMAND=$(echo "$EXISTING_LINE" | sed -E "s/alias $ALIAS_NAME='(.*)'/\1/")
      
      if [[ "$EXISTING_COMMAND" == "$ALIAS_COMMAND" ]]; then
        echo "ℹ️ Alias '$ALIAS_NAME' already exists in $ALIASES_TARGET with the same command. Skipping."
        continue
      else
        echo "⚠️ Alias '$ALIAS_NAME' exists in $ALIASES_TARGET with a different command:"
        echo "   Current:  alias $ALIAS_NAME='$EXISTING_COMMAND'"
        echo "   New:      alias $ALIAS_NAME='$ALIAS_COMMAND'"
        if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_OVERWRITE"; then
          ALIASES_TO_OVERWRITE+=("$ALIAS_NAME|$ALIAS_COMMAND")
        fi
      fi
    else
      # Check if alias exists in .bashrc (for bash) or .zshrc (for zsh)
      RC_FILE="$HOME/.${CURRENT_SHELL}rc"
      if [ -f "$RC_FILE" ] && grep -q "^alias $ALIAS_NAME=" "$RC_FILE"; then
        EXISTING_LINE=$(grep "^alias $ALIAS_NAME=" "$RC_FILE")
        EXISTING_COMMAND=$(echo "$EXISTING_LINE" | sed -E "s/alias $ALIAS_NAME='(.*)'/\1/")
        
        if [[ "$EXISTING_COMMAND" == "$ALIAS_COMMAND" ]]; then
          echo "⚠️ Alias '$ALIAS_NAME' exists in $RC_FILE with the same command."
          if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_MOVE"; then
            ALIASES_TO_MOVE+=("$ALIAS_NAME|$ALIAS_COMMAND")
          fi
        else
          echo "⚠️ Alias '$ALIAS_NAME' exists in $RC_FILE with a different command:"
          echo "   Current:  alias $ALIAS_NAME='$EXISTING_COMMAND'"
          echo "   New:      alias $ALIAS_NAME='$ALIAS_COMMAND'"
          if ! alias_in_array "$ALIAS_NAME" "ALIASES_TO_UPDATE"; then
            ALIASES_TO_UPDATE+=("$ALIAS_NAME|$ALIAS_COMMAND")
          fi
        fi
      else
        # Alias doesn't exist anywhere, add it to target file
        echo "$line" >> "$ALIASES_TARGET"
        echo "✅ Alias '$ALIAS_NAME' added to $ALIASES_TARGET."
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
  RC_FILE="$HOME/.${CURRENT_SHELL}rc"
  echo "⚠️ Alias '$ALIAS_NAME' exists in $RC_FILE with the same command."
  read -p "❓ Do you want to move it to $ALIASES_TARGET? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    # Remove from rc file and add to target file
    sed -i "/^alias $ALIAS_NAME=/d" "$RC_FILE"
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> "$ALIASES_TARGET"
    echo "✅ Alias '$ALIAS_NAME' moved from $RC_FILE to $ALIASES_TARGET."
  else
    echo "🚫 Skipped moving alias '$ALIAS_NAME'."
  fi
done

for alias_info in "${ALIASES_TO_UPDATE[@]}"; do
  IFS='|' read -r ALIAS_NAME ALIAS_COMMAND <<< "$alias_info"
  RC_FILE="$HOME/.${CURRENT_SHELL}rc"
  echo "⚠️ Alias '$ALIAS_NAME' exists in $RC_FILE with a different command."
  read -p "❓ Do you want to replace it in $RC_FILE and add to $ALIASES_TARGET? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    # Replace in rc file and add to target file
    sed -i "s|^alias $ALIAS_NAME=.*|alias $ALIAS_NAME='$ALIAS_COMMAND'|" "$RC_FILE"
    echo "alias $ALIAS_NAME='$ALIAS_COMMAND'" >> "$ALIASES_TARGET"
    echo "✅ Alias '$ALIAS_NAME' updated in $RC_FILE and added to $ALIASES_TARGET."
  else
    echo "🚫 Skipped update for alias '$ALIAS_NAME'."
  fi
done

for alias_info in "${ALIASES_TO_OVERWRITE[@]}"; do
  IFS='|' read -r ALIAS_NAME ALIAS_COMMAND <<< "$alias_info"
  echo "⚠️ Alias '$ALIAS_NAME' exists in $ALIASES_TARGET with a different command."
  read -p "❓ Do you want to overwrite it? [y/N]: " CONFIRM < /dev/tty
  CONFIRM=${CONFIRM,,}  # to lowercase
  if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    sed -i "s|^alias $ALIAS_NAME=.*|alias $ALIAS_NAME='$ALIAS_COMMAND'|" "$ALIASES_TARGET"
    echo "✅ Alias '$ALIAS_NAME' updated in $ALIASES_TARGET."
  else
    echo "🚫 Skipped update for alias '$ALIAS_NAME'."
  fi
done

# Reload configuration based on shell
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
  # Don't source zshrc from bash, just inform the user
  echo "🎉 $ALIASES_TARGET successfully updated!"
  echo "💡 To apply changes, run: source ~/.zshrc"
else
  source ~/.bash_aliases
  echo "🎉 $ALIASES_TARGET successfully updated!"
fi
