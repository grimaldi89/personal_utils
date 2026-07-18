#!/bin/bash
# Functional tests for alias/code/persist_env.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tests/lib.sh
source "$SCRIPT_DIR/lib.sh"

echo "--- test_persist_env.sh ---"

PERSIST_ENV="$REPO_DIR/alias/code/persist_env.sh"

# --- bash: variable should land in .bashrc, not .zshrc ---
SANDBOX="$(mktemp -d)"
mkdir -p "$SANDBOX/home"
trap 'rm -rf "$SANDBOX"' EXIT

if ! run_as_bash "$SANDBOX/home" "$PERSIST_ENV" \
    <<< $'MY_VAR\nhello' > "$SANDBOX/run.log" 2>&1; then
  cat "$SANDBOX/run.log"
  fail "persist_env.sh exited non-zero under bash"
fi

assert_file_contains "$SANDBOX/home/.bashrc" 'export MY_VAR="hello"' \
  "bash: persists the variable to .bashrc"
assert_file_not_contains "$SANDBOX/home/.zshrc" 'MY_VAR' \
  "bash: does not touch .zshrc"

rm -rf "$SANDBOX"

# --- zsh: variable should land in .zshrc, not .bashrc ---
SANDBOX="$(mktemp -d)"
mkdir -p "$SANDBOX/home"
trap 'rm -rf "$SANDBOX"' EXIT

if ! run_as_zsh "$SANDBOX/home" "$PERSIST_ENV" \
    <<< $'MY_VAR\nhello' > "$SANDBOX/run.log" 2>&1; then
  cat "$SANDBOX/run.log"
  fail "persist_env.sh exited non-zero under zsh"
fi

assert_file_contains "$SANDBOX/home/.zshrc" 'export MY_VAR="hello"' \
  "zsh: persists the variable to .zshrc"
assert_file_not_contains "$SANDBOX/home/.bashrc" 'MY_VAR' \
  "zsh: does not touch .bashrc"

# --- declining the overwrite prompt leaves the existing value untouched ---
if ! run_as_zsh "$SANDBOX/home" "$PERSIST_ENV" \
    <<< $'MY_VAR\nworld\nn' > "$SANDBOX/run2.log" 2>&1; then
  cat "$SANDBOX/run2.log"
  fail "persist_env.sh exited non-zero when declining an overwrite"
fi

assert_file_contains "$SANDBOX/home/.zshrc" 'export MY_VAR="hello"' \
  "zsh: declining overwrite keeps the original value"
assert_file_not_contains "$SANDBOX/home/.zshrc" 'export MY_VAR="world"' \
  "zsh: declining overwrite does not write the new value"

echo "All persist_env.sh tests passed."
