<#
.SYNOPSIS
  Installs Cursor via winget.
.NOTES
  If the winget package id below has moved, run `winget search cursor` to
  find the current one and pass it with -PackageId.
#>
param(
    [string]$PackageId = 'Anysphere.Cursor'
)

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🚀 Installing Cursor..." -ForegroundColor Cyan

if (Get-Command cursor -ErrorAction SilentlyContinue) {
    Write-Host "✅ Cursor is already installed!" -ForegroundColor Green
    Write-Host "🔧 You can run it with: cursor"
    exit 0
}

Install-WingetPackage -Id $PackageId -Name 'Cursor' -FailureHint 'Or download it manually from: https://cursor.com'

Write-Host "🎉 Cursor installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'cursor' to be recognized on PATH."
