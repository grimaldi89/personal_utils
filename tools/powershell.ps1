<#
.SYNOPSIS
  Installs PowerShell 7 via winget.
.NOTES
  Windows counterpart of tools/zsh.sh: Zsh doesn't exist natively on
  Windows, and the "newer, nicer shell" there is PowerShell 7 (`pwsh`),
  which installs side by side with the built-in Windows PowerShell 5.1.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing PowerShell 7..." -ForegroundColor Cyan

if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ PowerShell 7 is already installed." -ForegroundColor Yellow
    pwsh --version
    exit 0
}

Install-WingetPackage -Id 'Microsoft.PowerShell' -Name 'PowerShell 7'

Write-Host "✅ PowerShell 7 installed successfully!" -ForegroundColor Green
Write-Host "💡 Open a new terminal and run: pwsh"
Write-Host "💡 pwsh has its own `$PROFILE - re-run alias\install_aliases.ps1 and tools\powershell-customization.ps1 from inside it."
