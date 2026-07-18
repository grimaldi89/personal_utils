<#
.SYNOPSIS
  Wires alias/aliases.ps1 into your PowerShell $PROFILE. Windows
  equivalent of alias/install_aliases.sh.
#>

$ErrorActionPreference = 'Stop'

$AliasesFile = Join-Path $PSScriptRoot 'aliases.ps1'

if (-not (Test-Path $AliasesFile)) {
    Write-Host "❌ File $AliasesFile not found!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host "📝 Created $PROFILE"
}

$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($profileContent -and $profileContent.Contains($AliasesFile)) {
    Write-Host "ℹ️ Aliases already wired into $PROFILE. Skipping." -ForegroundColor Yellow
}
else {
    Add-Content -Path $PROFILE -Value "`n# Personal aliases`n. `"$AliasesFile`""
    Write-Host "✅ Added aliases to $PROFILE" -ForegroundColor Green
}

Write-Host "🎉 $PROFILE successfully updated!" -ForegroundColor Green
Write-Host "💡 To apply changes, run: . `$PROFILE"
