#!/bin/bash

set -e

# Ensure we're on a Debian-based system
if ! command -v apt-get >/dev/null; then
  echo "❌ This installer currently supports apt-based systems only." >&2
  exit 1
fi

BASE_DIR="$(dirname "$0")"
SEARCH_DIRS=("tools" "gcloud" "airbyte" "alias")
SCRIPTS=()

# Locate all scripts
for dir in "${SEARCH_DIRS[@]}"; do
  while IFS= read -r -d '' file; do
    SCRIPTS+=("${file#$BASE_DIR/}")
  done < <(find "$BASE_DIR/$dir" -type f -name "*.sh" -print0)
 done

if [ ${#SCRIPTS[@]} -eq 0 ]; then
  echo "❌ No .sh scripts found in expected folders." >&2
  exit 1
fi

# Display menu
declare -A SCRIPT_MAP
printf '\n📂 Select scripts to run:\n'
i=1
for script in "${SCRIPTS[@]}"; do
  script_name=$(basename "$script" .sh | sed -E 's/_/ /g' | sed -E 's/\b(.)/\u\1/g')
  case "$script_name" in
    "Python Venv") display="Create $script_name ($script)";;
    "Persist Env") display="Persist Environment Variable ($script)";;
    "Install Aliases") display="Install Aliases ($script)";;
    *) display="Install $script_name ($script)";;
  esac
  printf "  [%d] %s\n" "$i" "$display"
  SCRIPT_MAP[$i]="$script"
  ((i++))
 done

read -rp $'\n➡️  Enter numbers separated by space (e.g. 1 4 5): ' -a SELECTION < /dev/tty

# Perform updates once
echo "🔄 Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -f -y

# Run selected scripts
for idx in "${SELECTION[@]}"; do
  rel_path="${SCRIPT_MAP[$idx]}"
  path="$BASE_DIR/$rel_path"
  if [[ -f "$path" ]]; then
    echo "🚀 Running: $rel_path"
    chmod +x "$path"
    "$path"
    echo "✅ Done: $rel_path"
    echo "------------------------"
  else
    echo "❌ Script not found: $rel_path" >&2
  fi
 done

echo "🎉 All selected scripts completed."
