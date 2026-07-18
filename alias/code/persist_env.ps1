<#
.SYNOPSIS
  Persists a user environment variable. Windows equivalent of
  alias/code/persist_env.sh.
.NOTES
  Windows has no rc file to append an "export" line to - persistent
  environment variables live in the registry. [Environment]::SetEnvironmentVariable
  with the 'User' scope is the direct equivalent.
#>

$ErrorActionPreference = 'Stop'

$VarName = Read-Host "🔑 Enter the variable name"
$VarValue = Read-Host "📦 Enter the value"

$existing = [Environment]::GetEnvironmentVariable($VarName, 'User')
if ($null -ne $existing) {
    Write-Host "⚠️ Variable '$VarName' already exists with value: $existing" -ForegroundColor Yellow
    $confirm = Read-Host "❓ Do you want to overwrite it? [y/N]"
    if ($confirm.ToLower() -notin @('y', 'yes')) {
        Write-Host "🚫 Cancelled. Variable was not modified." -ForegroundColor Yellow
        exit 0
    }
    Write-Host "🔁 Updating..."
}
else {
    Write-Host "✅ Adding new variable: $VarName"
}

[Environment]::SetEnvironmentVariable($VarName, $VarValue, 'User')
Set-Item -Path "Env:$VarName" -Value $VarValue

Write-Host "🎉 Variable '$VarName' is now available in this session and persisted for future ones." -ForegroundColor Green
Write-Host "💡 Other already-open terminals need to be restarted to see it."
