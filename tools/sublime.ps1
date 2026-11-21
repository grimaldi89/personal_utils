<#
.SYNOPSIS
  Installs Sublime Text via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "📝 Installing Sublime Text..." -ForegroundColor Cyan

if (Get-Command subl -ErrorAction SilentlyContinue) {
    Write-Host "✅ Sublime Text is already installed." -ForegroundColor Green
    exit 0
}

Install-WingetPackage -Id 'SublimeHQ.SublimeText.4' -Name 'Sublime Text'

Write-Host "✅ Sublime Text installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'subl' to be recognized on PATH."
