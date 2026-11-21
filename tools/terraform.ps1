<#
.SYNOPSIS
  Installs Terraform via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing Terraform..." -ForegroundColor Cyan

if (Get-Command terraform -ErrorAction SilentlyContinue) {
    Write-Host "✅ Terraform is already installed." -ForegroundColor Green
    terraform --version
    exit 0
}

Install-WingetPackage -Id 'Hashicorp.Terraform' -Name 'Terraform'

Write-Host "✅ Terraform installed successfully." -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'terraform' to be recognized on PATH."
