<#
.SYNOPSIS
  Creates a Python virtual environment. Windows equivalent of
  alias/code/python_venv.sh.
#>
param(
    [string]$VenvName
)

$ErrorActionPreference = 'Stop'

if (-not $VenvName) {
    $VenvName = Read-Host "📛 Enter a name for the virtual environment"
}

Write-Host "🐍 Checking for Python..." -ForegroundColor Cyan
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Python is not installed. Install it first (e.g. tools/pyenv.ps1, then 'pyenv install <version>')." -ForegroundColor Red
    exit 1
}
Write-Host "✅ Python is available: $(python --version)"

Write-Host "📁 Creating virtual environment: $VenvName"
python -m venv $VenvName

Write-Host "✅ Virtual environment '$VenvName' created successfully!" -ForegroundColor Green
Write-Host "💡 To activate it, run: $VenvName\Scripts\Activate.ps1"
