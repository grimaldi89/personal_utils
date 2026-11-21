<#
.SYNOPSIS
  Installs the Google Cloud CLI on Windows via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔎 Checking if gcloud CLI is already installed..." -ForegroundColor Cyan

if (Get-Command gcloud -ErrorAction SilentlyContinue) {
    Write-Host "✅ gcloud is already installed." -ForegroundColor Green
    gcloud --version
    exit 0
}

Write-Host "🚀 Installing Google Cloud CLI..." -ForegroundColor Cyan
Install-WingetPackage -Id 'Google.CloudSDK' -Name 'Google Cloud CLI'

Write-Host "🎉 Google Cloud CLI installed!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell, then run: gcloud init"
