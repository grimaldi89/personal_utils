<#
.SYNOPSIS
  Installs Docker Desktop on Windows via winget.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🐳 Installing Docker Desktop..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "✅ Docker is already installed." -ForegroundColor Green
    docker --version
    exit 0
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

winget install --id Docker.DockerDesktop --source winget --accept-source-agreements --accept-package-agreements -e

Write-Host "🎉 Docker Desktop installed!" -ForegroundColor Green
Write-Host "💡 Launch Docker Desktop from the Start menu at least once to finish setup (it needs WSL2 enabled)."
Write-Host "💡 Close and reopen PowerShell for 'docker' to be recognized on PATH."
