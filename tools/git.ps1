<#
.SYNOPSIS
  Installs Git for Windows via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing Git..." -ForegroundColor Cyan

if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "✅ Git is already installed." -ForegroundColor Green
    git --version
    exit 0
}

Install-WingetPackage -Id 'Git.Git' -Name 'Git'

Write-Host "🎉 Git installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'git' to be recognized on PATH."
