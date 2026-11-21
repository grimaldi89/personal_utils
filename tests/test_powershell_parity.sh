#!/bin/bash
# Static checks for the Windows (.ps1) side that can run without PowerShell:
# every Linux script has a Windows counterpart, every .ps1 has the UTF-8 BOM
# Windows PowerShell 5.1 needs, and install.ps1's name aliases resolve.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tests/lib.sh
source "$SCRIPT_DIR/lib.sh"

echo "--- test_powershell_parity.sh ---"

cd "$REPO_DIR"

# Linux script -> Windows counterpart, where the name isn't simply the same.
declare -A COUNTERPART=(
  [tools/batcat.sh]=tools/bat.ps1
  [tools/open_ssh_client.sh]=tools/openssh_client.ps1
  [tools/zsh.sh]=tools/powershell.ps1
  [tools/oh-my-zsh.sh]=tools/oh-my-posh.ps1
  [tools/zsh-customization.sh]=tools/powershell-customization.ps1
  [tools/gedit.sh]=tools/notepadplusplus.ps1
)

while IFS= read -r sh; do
  ps1="${COUNTERPART[$sh]:-${sh%.sh}.ps1}"
  if [ ! -f "$ps1" ]; then
    fail "$sh has no Windows counterpart (expected $ps1)"
  fi
done < <(git ls-files -co --exclude-standard 'tools/*.sh' 'airbyte/*.sh' 'alias/*.sh' 'alias/code/*.sh' 'install.sh')
pass "every Linux script has a .ps1 counterpart"

while IFS= read -r ps1; do
  if [ "$(head -c3 "$ps1" | od -An -tx1 | tr -d ' \n')" != "efbbbf" ]; then
    fail "$ps1 is missing its UTF-8 BOM"
  fi
  if grep -q $'\r' "$ps1"; then
    fail "$ps1 has CRLF line endings (the repo uses LF)"
  fi
done < <(git ls-files -co --exclude-standard '*.ps1')
pass "every .ps1 file has a UTF-8 BOM and LF line endings"

# Each target of install.ps1's $NameAliases must be a real script.
while IFS= read -r target; do
  if ! git ls-files -co --exclude-standard '*.ps1' | grep -q "/$target\.ps1$"; then
    fail "install.ps1 maps a name to '$target', but no $target.ps1 exists"
  fi
done < <(sed -n "/^\$NameAliases = @{/,/^}/s/.*= *'\([^']*\)'.*/\1/p" install.ps1)
pass "install.ps1 name aliases all point at existing scripts"

# Installers that call the shared helper must dot-source it.
while IFS= read -r ps1; do
  if ! grep -qF 'lib\winget.ps1' "$ps1"; then
    fail "$ps1 calls Install-WingetPackage without dot-sourcing lib\\winget.ps1"
  fi
done < <(grep -lF 'Install-WingetPackage' tools/*.ps1 airbyte/*.ps1)
pass "installers using Install-WingetPackage dot-source lib/winget.ps1"

echo "All PowerShell parity tests passed."
