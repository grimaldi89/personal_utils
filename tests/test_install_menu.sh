#!/bin/bash
# Functional tests for install.sh's script discovery, plus static
# regression guards for the airbyte.sh path fix and the pipefail fixes.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tests/lib.sh
source "$SCRIPT_DIR/lib.sh"

echo "--- test_install_menu.sh ---"

MENU_LOG="$(mktemp)"
trap 'rm -f "$MENU_LOG"' EXIT

# install.sh reads its selection from /dev/tty, which isn't available in
# CI/sandboxes, so it's expected to exit non-zero after printing the menu.
# We only care that script discovery itself behaved correctly.
bash "$REPO_DIR/install.sh" < /dev/null > "$MENU_LOG" 2>&1 || true

assert_file_not_contains "$MENU_LOG" "gcloud': No such file or directory" \
  "install.sh no longer scans a nonexistent top-level gcloud/ dir"

assert_file_contains "$MENU_LOG" "tools/gcloud.sh" \
  "install.sh still discovers gcloud.sh from tools/"

assert_file_contains "$MENU_LOG" "airbyte/airbyte.sh" \
  "install.sh still discovers airbyte.sh"

# --- static regression guards ---

if grep -qF './docker.sh' "$REPO_DIR/airbyte/airbyte.sh"; then
  fail "airbyte.sh still references docker.sh by a cwd-relative path"
fi
pass "airbyte.sh no longer references docker.sh by a cwd-relative path"

DOCKER_SCRIPT="$REPO_DIR/tools/docker.sh"
if [ ! -f "$DOCKER_SCRIPT" ]; then
  fail "airbyte.sh's resolved docker.sh path ($DOCKER_SCRIPT) does not exist"
fi
pass "airbyte.sh's resolved docker.sh path exists"

for f in tools/gcloud.sh tools/terraform.sh airbyte/airbyte.sh; do
  if ! grep -q 'pipefail' "$REPO_DIR/$f"; then
    fail "$f is missing 'pipefail' despite piping curl into another command"
  fi
  pass "$f enables pipefail"
done

echo "All install.sh menu tests passed."
