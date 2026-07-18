<#
.SYNOPSIS
  Installs the OpenSSH Client optional Windows feature.
.NOTES
  Requires an elevated (Administrator) PowerShell session - installing a
  Windows optional feature isn't something a per-user winget install can do.
#>

$ErrorActionPreference = 'Stop'

Write-Host "🔧 Installing OpenSSH Client..." -ForegroundColor Cyan

if (Get-Command ssh -ErrorAction SilentlyContinue) {
    Write-Host "✅ OpenSSH Client is already installed." -ForegroundColor Green
    ssh -V
    exit 0
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "❌ This needs an elevated PowerShell session (Run as Administrator)." -ForegroundColor Red
    exit 1
}

$capability = Get-WindowsCapability -Online -Name 'OpenSSH.Client~~~~0.0.1.0'
if ($capability.State -eq 'Installed') {
    Write-Host "✅ OpenSSH Client is already installed." -ForegroundColor Green
    exit 0
}

Add-WindowsCapability -Online -Name 'OpenSSH.Client~~~~0.0.1.0'

Write-Host "🎉 OpenSSH Client installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for 'ssh' to be recognized on PATH."
