#!/bin/bash

set -e

echo "📦 Scanning for installable scripts..."

BASE_DIR="$(dirname "$0")"
SEARCH_DIRS=("tools" "gcloud" "airbyte" "alias")
SCRIPTS=()

# Find all .sh files within the defined directories
for dir in "${SEARCH_DIRS[@]}"; do
  while IFS= read -r -d '' file; do
    SCRIPTS+=("${file#$BASE_DIR/}")  # Remove ./ from the beginning
  done < <(find "$BASE_DIR/$dir" -type f -name "*.sh" -print0)
done

# Validation
if [ ${#SCRIPTS[@]} -eq 0 ]; then
  echo "❌ No .sh scripts found in expected folders."
  exit 1
fi

# Display dynamic menu
declare -A SCRIPT_MAP
echo ""
echo "📂 Select scripts to run:"
i=1
for script in "${SCRIPTS[@]}"; do
  # Friendly name based on the script name
  script_name=$(basename "$script" .sh | sed -E 's/_/ /g' | sed -E 's/\b(.)/\u\1/g')
  folder_name=$(dirname "$script")
  
  # Adjust the title
  if [[ "$script_name" == "Python Venv" ]]; then
    display="Create $script_name ($script)"
  elif [[ "$script_name" == "Persist Env" ]]; then
    display="Persist Environment Variable ($script)"
  elif [[ "$script_name" == "Install Aliases" ]]; then
    display="Install Aliases ($script)"
  else
    display="Install $script_name ($script)"
  fi

  echo "  [$i] $display"
  SCRIPT_MAP[$i]="$script"
  ((i++))
done

# Get user selection
read -p $'\n➡️  Enter numbers separated by space (e.g. 1 4 5): ' -a SELECTION < /dev/tty

echo ""
# Run selected scripts
for idx in "${SELECTION[@]}"; do
  rel_path="${SCRIPT_MAP[$idx]}"
  path="$BASE_DIR/$rel_path"
  if [[ -f "$path" ]]; then
    echo "🔄 Updating system before running: $path"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -f -y
    echo "🚀 Running: $rel_path"
    chmod +x "$path"
    "$path"
    echo "✅ Done: $rel_path"
    echo "------------------------"
  else
    echo "❌ Script not found: $rel_path"
  fi
done

echo "🎉 All selected scripts completed."