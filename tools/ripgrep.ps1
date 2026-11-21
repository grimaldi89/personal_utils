<#
.SYNOPSIS
  Installs ripgrep via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing ripgrep..." -ForegroundColor Cyan

if (Get-Command rg -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ ripgrep is already installed." -ForegroundColor Yellow
    rg --version
    exit 0
}

Install-WingetPackage -Id 'BurntSushi.ripgrep.MSVC' -Name 'ripgrep'

Write-Host "✅ ripgrep installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'rg' to be recognized on PATH."
