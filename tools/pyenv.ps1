<#
.SYNOPSIS
  Installs pyenv-win, a Python version manager for Windows (PowerShell port of pyenv).
.DESCRIPTION
  Windows equivalent of tools/pyenv.sh. Downloads and runs the official
  pyenv-win installer, which sets up the PYENV/PYENV_ROOT/PYENV_HOME
  environment variables and PATH entries for the current user via the
  Windows registry - there is no rc file to edit like on bash/zsh.
.LINK
  https://github.com/pyenv-win/pyenv-win
#>

$ErrorActionPreference = 'Stop'

Write-Host "🐍 Installing pyenv-win..." -ForegroundColor Cyan

if (Get-Command pyenv -ErrorAction SilentlyContinue) {
    Write-Host "✅ pyenv is already installed." -ForegroundColor Green
    pyenv --version
    exit 0
}

$pyenvRoot = Join-Path $HOME '.pyenv'
if (Test-Path $pyenvRoot) {
    Write-Host "✅ pyenv-win is already installed at $pyenvRoot, but 'pyenv' isn't on PATH in this session." -ForegroundColor Yellow
    Write-Host "💡 Close and reopen PowerShell, then run: pyenv --version"
    exit 0
}

Write-Host "⬇️ Downloading the official pyenv-win installer..."
$installerUrl = 'https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1'
$installerPath = Join-Path $env:TEMP 'install-pyenv-win.ps1'

Invoke-WebRequest -UseBasicParsing -Uri $installerUrl -OutFile $installerPath

try {
    # The installer only sets user-scoped environment variables/PATH, so it
    # doesn't need elevation - but it does need the execution policy for
    # this process relaxed enough to run a locally downloaded script.
    powershell -NoProfile -ExecutionPolicy Bypass -File $installerPath
}
finally {
    Remove-Item $installerPath -ErrorAction SilentlyContinue
}

Write-Host "🎉 pyenv-win installed successfully!" -ForegroundColor Green
Write-Host "💡 Close and reopen PowerShell for the new PATH/environment variables to take effect."
Write-Host "💡 Then install a Python version with: pyenv install 3.12.8; pyenv global 3.12.8"
