<#
.SYNOPSIS
  Installs eza (a modern replacement for `ls`) via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing eza..." -ForegroundColor Cyan

if (Get-Command eza -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ eza is already installed." -ForegroundColor Yellow
    eza --version
    exit 0
}

Install-WingetPackage -Id 'eza-community.eza' -Name 'eza'

Write-Host "✅ eza installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'eza' to be recognized on PATH."
