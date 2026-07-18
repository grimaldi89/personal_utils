<#
.SYNOPSIS
  Installs Airbyte locally on Windows via abctl, using Docker Desktop.
.NOTES
  Airbyte doesn't publish an official Windows installer the way
  get.airbyte.com does for Unix - this downloads the latest `abctl`
  Windows release directly from GitHub. The exact asset naming could not
  be verified in this environment (no Windows machine available to test
  against), so double-check the downloaded file if this script's asset
  matching ever falls out of date with the abctl release format.
#>

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$dockerScript = Join-Path $scriptDir '..\tools\docker.ps1'

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "🐳 Docker not found. Running docker.ps1..." -ForegroundColor Cyan
    if (Test-Path $dockerScript) {
        & $dockerScript
    }
    else {
        Write-Host "❌ docker.ps1 not found at $dockerScript" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✅ Docker is already installed." -ForegroundColor Green
}

Write-Host "📦 Installing Airbyte (abctl)..." -ForegroundColor Cyan

if (Get-Command abctl -ErrorAction SilentlyContinue) {
    Write-Host "✅ abctl is already installed." -ForegroundColor Green
}
else {
    $installDir = Join-Path $env:LOCALAPPDATA 'abctl\bin'
    New-Item -ItemType Directory -Force -Path $installDir | Out-Null

    Write-Host "⬇️ Fetching the latest abctl release for Windows..."
    $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/airbytehq/abctl/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -match 'windows' -and $_.name -match 'amd64' } | Select-Object -First 1

    if (-not $asset) {
        Write-Host "❌ Couldn't find a Windows amd64 asset in the latest abctl release." -ForegroundColor Red
        Write-Host "💡 Check https://github.com/airbytehq/abctl/releases and install it manually." -ForegroundColor Yellow
        exit 1
    }

    $zipPath = Join-Path $env:TEMP $asset.name
    Invoke-WebRequest -UseBasicParsing -Uri $asset.browser_download_url -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
    Remove-Item $zipPath -ErrorAction SilentlyContinue

    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    if ($userPath -notlike "*$installDir*") {
        [Environment]::SetEnvironmentVariable('Path', "$userPath;$installDir", 'User')
        $env:Path += ";$installDir"
    }
}

Write-Host "⚙️ Running Airbyte local install with abctl..." -ForegroundColor Cyan
abctl local install

Write-Host "🔐 Setting up credentials..." -ForegroundColor Cyan
abctl local credentials

Write-Host "🎉 Airbyte successfully installed!" -ForegroundColor Green
