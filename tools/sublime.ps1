<#
.SYNOPSIS
  Installs Sublime Text via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "📝 Installing Sublime Text..." -ForegroundColor Cyan

if (Get-Command subl -ErrorAction SilentlyContinue) {
    Write-Host "✅ Sublime Text is already installed." -ForegroundColor Green
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id SublimeHQ.SublimeText.4 --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "✅ Sublime Text installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'subl' to be recognized on PATH."
