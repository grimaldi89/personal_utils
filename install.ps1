<#
.SYNOPSIS
  Interactive menu to install this repo's Windows tools. Equivalent of
  install.sh, adapted for PowerShell/winget instead of apt.
#>

$ErrorActionPreference = 'Stop'

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "❌ winget is not available. Install 'App Installer' from the Microsoft Store, then re-run this script." -ForegroundColor Red
    exit 1
}

$RepoDir = Split-Path -Parent $PSCommandPath
$SearchDirs = @('tools', 'airbyte', 'alias')
$Scripts = @()

foreach ($dir in $SearchDirs) {
    $path = Join-Path $RepoDir $dir
    if (Test-Path $path) {
        # aliases.ps1 is a library meant to be dot-sourced, not run directly - skip it.
        $Scripts += Get-ChildItem -Path $path -Filter '*.ps1' -Recurse -File |
            Where-Object { $_.Name -ne 'aliases.ps1' } |
            ForEach-Object { $_.FullName.Substring($RepoDir.Length + 1) }
    }
}

if ($Scripts.Count -eq 0) {
    Write-Host "❌ No .ps1 scripts found in expected folders." -ForegroundColor Red
    exit 1
}

Write-Host "`n📂 Select scripts to run:" -ForegroundColor Cyan
$ScriptMap = @{}
for ($i = 0; $i -lt $Scripts.Count; $i++) {
    $index = $i + 1
    $name = [IO.Path]::GetFileNameWithoutExtension($Scripts[$i]) -replace '_', ' '
    $name = (Get-Culture).TextInfo.ToTitleCase($name)
    Write-Host ("  [{0}] Install {1} ({2})" -f $index, $name, $Scripts[$i])
    $ScriptMap[$index] = $Scripts[$i]
}

$selection = Read-Host "`n➡️  Enter numbers separated by space (e.g. 1 4 5)"
$indices = $selection -split '\s+' | Where-Object { $_ -ne '' }

if (-not $indices) {
    Write-Host "❌ No selection made." -ForegroundColor Red
    exit 1
}

foreach ($idx in $indices) {
    $parsed = 0
    if (-not [int]::TryParse($idx, [ref]$parsed) -or -not $ScriptMap.ContainsKey($parsed)) {
        Write-Host "❌ Invalid selection: $idx" -ForegroundColor Red
        continue
    }
    $relPath = $ScriptMap[$parsed]
    $fullPath = Join-Path $RepoDir $relPath
    Write-Host "🚀 Running: $relPath" -ForegroundColor Cyan
    & $fullPath
    Write-Host "✅ Done: $relPath" -ForegroundColor Green
    Write-Host "------------------------"
}

Write-Host "🎉 All selected scripts completed." -ForegroundColor Green
