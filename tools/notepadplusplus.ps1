<#
.SYNOPSIS
  Installs Notepad++ via winget.
.NOTES
  Windows counterpart of tools/gedit.sh: Gedit has no maintained Windows
  build, and Notepad++ fills the same "simple text editor" role.
#>

$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\lib\winget.ps1')

Write-Host "📝 Installing Notepad++..." -ForegroundColor Cyan

$candidates = @($env:ProgramFiles, ${env:ProgramFiles(x86)}) |
    Where-Object { $_ } |
    ForEach-Object { Join-Path $_ 'Notepad++\notepad++.exe' }
if ($candidates | Where-Object { Test-Path $_ }) {
    Write-Host "✅ Notepad++ is already installed." -ForegroundColor Green
    exit 0
}

Install-WingetPackage -Id 'Notepad++.Notepad++' -Name 'Notepad++'

Write-Host "✅ Notepad++ installed successfully!" -ForegroundColor Green
