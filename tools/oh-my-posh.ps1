<#
.SYNOPSIS
  Installs Oh My Posh (prompt theme engine) via winget.
.NOTES
  Windows counterpart of tools/oh-my-zsh.sh. Run
  tools/powershell-customization.ps1 afterwards to enable the theme.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🔧 Installing Oh My Posh..." -ForegroundColor Cyan

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "ℹ️ Oh My Posh is already installed." -ForegroundColor Yellow
    oh-my-posh version
    exit 0
}

Install-WingetPackage -Id 'JanDeDobbeleer.OhMyPosh' -Name 'Oh My Posh'

Write-Host "✅ Oh My Posh installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell, then run tools\powershell-customization.ps1 to enable the theme."
Write-Host "💡 Themes use icons from a Nerd Font - install one with: oh-my-posh font install meslo"
