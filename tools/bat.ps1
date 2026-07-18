<#
.SYNOPSIS
  Installs bat (a modern replacement for `cat`) via winget.
.NOTES
  Windows equivalent of tools/batcat.sh. The command is named `bat` here,
  not `batcat` - the `batcat` name only exists on Debian/Ubuntu, where it
  was renamed to avoid clashing with an unrelated package called `bat`.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing bat..." -ForegroundColor Cyan

if (Get-Command bat -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ bat is already installed." -ForegroundColor Yellow
    bat --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id sharkdp.bat --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "✅ bat installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'bat' to be recognized on PATH."
