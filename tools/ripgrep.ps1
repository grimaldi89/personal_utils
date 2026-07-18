<#
.SYNOPSIS
  Installs ripgrep via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing ripgrep..." -ForegroundColor Cyan

if (Get-Command rg -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ ripgrep is already installed." -ForegroundColor Yellow
    rg --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id BurntSushi.ripgrep.MSVC --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "✅ ripgrep installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'rg' to be recognized on PATH."
