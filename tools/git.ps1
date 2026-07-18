<#
.SYNOPSIS
  Installs Git for Windows via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing Git..." -ForegroundColor Cyan

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "✅ Git is already installed." -ForegroundColor Green
    git --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id Git.Git --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "🎉 Git installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'git' to be recognized on PATH."
