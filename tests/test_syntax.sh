#!/bin/bash
# Simple syntax check for all scripts
set -e

scripts=$(git ls-files '*.sh')
for script in $scripts; do
  bash -n "$script"
done
