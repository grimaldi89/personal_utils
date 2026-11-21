<#
.SYNOPSIS
  Installs Docker Desktop on Windows via winget.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "🐳 Installing Docker Desktop..." -ForegroundColor Cyan

if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "✅ Docker is already installed." -ForegroundColor Green
    docker --version
    exit 0
}

Install-WingetPackage -Id 'Docker.DockerDesktop' -Name 'Docker Desktop'

Write-Host "🎉 Docker Desktop installed!" -ForegroundColor Green
Write-Host "💡 Launch Docker Desktop from the Start menu at least once to finish setup (it needs WSL2 enabled)."
Write-Host "💡 Close and reopen PowerShell for 'docker' to be recognized on PATH."
