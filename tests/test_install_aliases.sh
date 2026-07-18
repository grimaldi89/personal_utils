#!/bin/bash
# Functional tests for alias/install_aliases.sh
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tests/lib.sh
source "$SCRIPT_DIR/lib.sh"

echo "--- test_install_aliases.sh ---"

SANDBOX="$(mktemp -d)"
mkdir -p "$SANDBOX/home"
trap 'rm -rf "$SANDBOX"' EXIT

if ! run_as_bash "$SANDBOX/home" "$REPO_DIR/alias/install_aliases.sh" \
    < /dev/null > "$SANDBOX/run1.log" 2>&1; then
  cat "$SANDBOX/run1.log"
  fail "install_aliases.sh exited non-zero on first run"
fi

ALIASES_FILE="$SANDBOX/home/.bash_aliases"

assert_file_contains "$ALIASES_FILE" "alias utils='bash $REPO_DIR/install.sh'" \
  "resolves __PERSONAL_UTILS_DIR__ to the actual repo path"

assert_file_not_contains "$ALIASES_FILE" "__PERSONAL_UTILS_DIR__" \
  "does not leave the raw placeholder in the installed aliases"

# Running it again should not duplicate any alias.
if ! run_as_bash "$SANDBOX/home" "$REPO_DIR/alias/install_aliases.sh" \
    < /dev/null > "$SANDBOX/run2.log" 2>&1; then
  cat "$SANDBOX/run2.log"
  fail "install_aliases.sh exited non-zero on second run"
fi

UTILS_COUNT=$(grep -c "^alias utils=" "$ALIASES_FILE")
if [ "$UTILS_COUNT" -ne 1 ]; then
  fail "running install_aliases.sh twice produced $UTILS_COUNT 'utils' aliases instead of 1"
fi
pass "running install_aliases.sh twice does not duplicate aliases"

echo "All install_aliases.sh tests passed."
