#!/bin/bash

set -e  # Stop on error

TOOLS_DIR="./tools"

if [ ! -d "$TOOLS_DIR" ]; then
  echo "❌ Directory '$TOOLS_DIR' not found!"
  exit 1
fi

for script in "$TOOLS_DIR"/*.sh; do
  if [ -f "$script" ]; then
    echo "🚀 Executing: $script"
    chmod +x "$script"
    "$script"
    echo "✅ Finished: $script"
    echo "------------------------------"
  fi
done

echo "🎉 All scripts in $TOOLS_DIR have been executed!"
