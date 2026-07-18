<#
.SYNOPSIS
  Installs the Google Cloud CLI on Windows via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔎 Checking if gcloud CLI is already installed..." -ForegroundColor Cyan

if (Get-Command gcloud -ErrorAction SilentlyContinue) {
    Write-Host "✅ gcloud is already installed." -ForegroundColor Green
    gcloud --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Installing Google Cloud CLI..." -ForegroundColor Cyan
winget install --id Google.CloudSDK --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "🎉 Google Cloud CLI installed!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell, then run: gcloud init"
