# Shared helpers for tests/test_*.sh functional tests.
# Meant to be sourced, not executed directly.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pass() {
  echo "✅ PASS: $1"
}

fail() {
  echo "❌ FAIL: $1" >&2
  exit 1
}

# Runs $2 (a script) with HOME=$1, as if launched from a genuine bash
# login shell, so scripts that inspect the parent process
# (ps -o comm= -p $PPID) see "bash" regardless of which shell is
# actually driving this test run.
run_as_bash() {
  local home="$1" script="$2"
  bash -c 'HOME="$1" SHELL=/bin/bash bash "$2"' _ "$home" "$script"
}

run_as_zsh() {
  local home="$1" script="$2"
  HOME="$home" SHELL=/bin/zsh bash "$script"
}

assert_file_contains() {
  local file="$1" pattern="$2" desc="$3"
  if [ ! -f "$file" ]; then
    fail "$desc (file not found: $file)"
  fi
  if ! grep -qF -- "$pattern" "$file"; then
    fail "$desc (expected to find '$pattern' in $file)"
  fi
  pass "$desc"
}

assert_file_not_contains() {
  local file="$1" pattern="$2" desc="$3"
  if [ -f "$file" ] && grep -qF -- "$pattern" "$file"; then
    fail "$desc (did not expect to find '$pattern' in $file)"
  fi
  pass "$desc"
}
