<#
.SYNOPSIS
  Installs Cursor via winget.
.NOTES
  The winget package id below (Anysphere.Cursor) could not be verified in
  this environment (no Windows/winget available to test against). If it
  has changed, run `winget search cursor` to find the current id and pass
  it with -PackageId.
#>
param(
    [string]$PackageId = 'Anysphere.Cursor'
)

$ErrorActionPreference = 'Stop'

Write-Host "🚀 Installing Cursor..." -ForegroundColor Cyan

if (Get-Command cursor -ErrorAction SilentlyContinue) {
    Write-Host "✅ Cursor is already installed!" -ForegroundColor Green
    Write-Host "🔧 You can run it with: cursor"
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, or download Cursor manually from https://cursor.com" -ForegroundColor Red
    exit 1
}

try {
    winget install --id $PackageId --source winget --accept-source-agreements --accept-package-agreements -e
}
catch {
    Write-Host "❌ winget install failed for id '$PackageId'." -ForegroundColor Red
    Write-Host "💡 Try: winget search cursor" -ForegroundColor Yellow
    Write-Host "💡 Or download it manually from: https://cursor.com" -ForegroundColor Yellow
    throw
}

Write-Host "🎉 Cursor installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'cursor' to be recognized on PATH."
