<#
.SYNOPSIS
  Shared winget helper for the tools/*.ps1 installers.
.NOTES
  Not meant to be run directly - each installer dot-sources it. It lives
  outside tools/, airbyte/ and alias/ so install.ps1's menu doesn't list it.

  winget is a native command, so a failed install doesn't throw - without
  checking $LASTEXITCODE a script would print its success message even
  when nothing was installed.
#>

# 0x8A15002B (APPINSTALLER_CLI_ERROR_UPDATE_NOT_APPLICABLE): the package is
# already installed and there is no newer version - not a failure.
$script:WingetAlreadyInstalled = -1978335189

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id,
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$FailureHint
    )

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
        if ($FailureHint) { Write-Host "💡 $FailureHint" -ForegroundColor Yellow }
        exit 1
    }

    winget install --id $Id --source winget --accept-source-agreements --accept-package-agreements -e
    $code = $LASTEXITCODE

    if ($code -eq $script:WingetAlreadyInstalled) {
        Write-Host "ℹ️ $Name is already installed and up to date." -ForegroundColor Yellow
        $global:LASTEXITCODE = 0
        return
    }

    if ($code -ne 0) {
        Write-Host "❌ winget failed to install $Name (package id '$Id', exit code $code)." -ForegroundColor Red
        Write-Host "💡 Check the id with: winget search `"$Name`"" -ForegroundColor Yellow
        if ($FailureHint) { Write-Host "💡 $FailureHint" -ForegroundColor Yellow }
        exit 1
    }
}
