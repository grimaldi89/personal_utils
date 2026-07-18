<#
.SYNOPSIS
  Installs eza (a modern replacement for `ls`) via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing eza..." -ForegroundColor Cyan

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ eza is already installed." -ForegroundColor Yellow
    eza --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id eza-community.eza --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "✅ eza installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'eza' to be recognized on PATH."
