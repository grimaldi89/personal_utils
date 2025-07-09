#!/bin/bash

set -e

echo "📦 Scanning for installable scripts..."

BASE_DIR="$(dirname "$0")"
SEARCH_DIRS=("tools" "gcloud" "airbyte" "alias")
SCRIPTS=()

# Encontra todos os .sh dentro dos diretórios definidos
for dir in "${SEARCH_DIRS[@]}"; do
  while IFS= read -r -d '' file; do
    SCRIPTS+=("${file#$BASE_DIR/}")  # Remove ./ do início
  done < <(find "$BASE_DIR/$dir" -type f -name "*.sh" -print0)
done

# Validação
if [ ${#SCRIPTS[@]} -eq 0 ]; then
  echo "❌ No .sh scripts found in expected folders."
  exit 1
fi

# Exibe menu dinâmico
declare -A SCRIPT_MAP
echo ""
echo "📂 Select scripts to run:"
i=1
for script in "${SCRIPTS[@]}"; do
  # Nome amigável baseado no nome do script
  script_name=$(basename "$script" .sh | sed -E 's/_/ /g' | sed -E 's/\b(.)/\u\1/g')
  folder_name=$(dirname "$script")
  
  # Ajusta o título
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

# Recebe seleção do usuário
read -p $'\n➡️  Enter numbers separated by space (e.g. 1 4 5): ' -a SELECTION < /dev/tty

echo ""
# Executa scripts selecionados
for idx in "${SELECTION[@]}"; do
  path="${SCRIPT_MAP[$idx]}"
  if [[ -f "$path" ]]; then
    echo "🚀 Running: $path"
    chmod +x "$path"
    "$path"
    echo "✅ Done: $path"
    echo "------------------------"
  else
    echo "❌ Script not found: $path"
  fi
done

echo "🎉 All selected scripts completed."
