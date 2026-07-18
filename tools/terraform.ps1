<#
.SYNOPSIS
  Installs Terraform via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing Terraform..." -ForegroundColor Cyan

if (Get-Command terraform -ErrorAction SilentlyContinue) {
    Write-Host "✅ Terraform is already installed." -ForegroundColor Green
    terraform --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id Hashicorp.Terraform --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "✅ Terraform installed successfully." -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'terraform' to be recognized on PATH."
