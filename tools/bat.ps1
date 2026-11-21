<#
.SYNOPSIS
  Installs bat (a modern replacement for `cat`) via winget.
.NOTES
  Windows equivalent of tools/batcat.sh. The command is named `bat` here,
  not `batcat` - the `batcat` name only exists on Debian/Ubuntu, where it
  was renamed to avoid clashing with an unrelated package called `bat`.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing bat..." -ForegroundColor Cyan

if (Get-Command bat -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ bat is already installed." -ForegroundColor Yellow
    bat --version
    exit 0
}

Install-WingetPackage -Id 'sharkdp.bat' -Name 'bat'

Write-Host "✅ bat installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'bat' to be recognized on PATH."
