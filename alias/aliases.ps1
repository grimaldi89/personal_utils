<#
.SYNOPSIS
  PowerShell profile functions - Windows equivalent of alias/alias.txt.
.NOTES
  Not meant to be run directly - alias/install_aliases.ps1 dot-sources
  this into $PROFILE. Functions take precedence over PowerShell's
  built-in aliases (ls -> Get-ChildItem, cat -> Get-Content), so
  redefining them here overrides those the same way alias/alias.txt's
  `alias ls=...`/`alias cat=...` override the Unix builtins.

  cat and grep forward pipeline input explicitly: a plain
  `function grep { rg @args }` would silently drop it, so
  `git log | grep fix` would search the current directory instead.
#>

$script:PersonalUtilsDir = Split-Path -Parent $PSScriptRoot

function utils { & (Join-Path $script:PersonalUtilsDir 'install.ps1') @args }

# `m <tool> [<tool> ...]` - the Windows stand-in for `make <target>`.
# With no arguments it lists what can be installed (like `make help`).
function m {
    $installer = Join-Path $script:PersonalUtilsDir 'install.ps1'
    if ($args.Count -eq 0) { & $installer -List }
    else { & $installer @args }
}

function new_venv { & (Join-Path $script:PersonalUtilsDir 'alias\code\python_venv.ps1') @args }
function persist_env { & (Join-Path $script:PersonalUtilsDir 'alias\code\persist_env.ps1') @args }

# Windows stand-in for the bashrc/zshrc aliases. A function can't re-load
# the profile into the calling session (dot-sourcing here would only affect
# this function's own scope), so it tells you how instead.
function profile {
    if (Get-Command subl -ErrorAction SilentlyContinue) { subl $PROFILE }
    else { notepad $PROFILE }
    Write-Host "💡 After saving, reload it with: . `$PROFILE"
}

function sublime { subl @args }
function ls { eza -la --icons @args }

function cat {
    if ($MyInvocation.ExpectingInput) { $input | bat @args }
    else { bat @args }
}

function grep {
    if ($MyInvocation.ExpectingInput) { $input | rg @args }
    else { rg @args }
}
