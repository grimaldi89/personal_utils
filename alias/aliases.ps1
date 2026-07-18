<#
.SYNOPSIS
  PowerShell profile functions - Windows equivalent of alias/alias.txt.
.NOTES
  Not meant to be run directly - alias/install_aliases.ps1 dot-sources
  this into $PROFILE. Functions take precedence over PowerShell's
  built-in aliases (ls -> Get-ChildItem, cat -> Get-Content), so
  redefining them here overrides those the same way alias/alias.txt's
  `alias ls=...`/`alias cat=...` override the Unix builtins.
#>

$script:PersonalUtilsDir = Split-Path -Parent $PSScriptRoot

function utils { & (Join-Path $script:PersonalUtilsDir 'install.ps1') @args }
function new_venv { & (Join-Path $script:PersonalUtilsDir 'alias\code\python_venv.ps1') @args }
function persist_env { & (Join-Path $script:PersonalUtilsDir 'alias\code\persist_env.ps1') @args }
function profile { subl $PROFILE; . $PROFILE }
function ls { eza -la --icons @args }
function cat { bat @args }
function grep { rg @args }
