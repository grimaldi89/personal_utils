<#
.SYNOPSIS
  Customizes PowerShell with the Spaceship prompt theme, git integration
  and history-based autosuggestions.
.NOTES
  Windows counterpart of tools/zsh-customization.sh:

    Spaceship zsh theme      -> Oh My Posh's "spaceship" theme
    oh-my-zsh git plugin     -> posh-git (git tab completion)
    zsh-autosuggestions      -> PSReadLine history predictions
    zsh-syntax-highlighting  -> built into PSReadLine, nothing to install

  Unlike the zsh script, this doesn't replace your profile - it adds one
  clearly marked block to $PROFILE (after backing the file up) and
  re-running it replaces just that block.
#>

$ErrorActionPreference = 'Stop'

$BlockStart = '# >>> personal_utils powershell customization >>>'
$BlockEnd = '# <<< personal_utils powershell customization <<<'

Write-Host "🎨 Customizing PowerShell with the Spaceship theme and plugins..." -ForegroundColor Cyan

if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ 'oh-my-posh' isn't on PATH in this session." -ForegroundColor Yellow
    Write-Host "   If you haven't installed it, run tools\oh-my-posh.ps1. If you just did, this is expected -"
    Write-Host "   the theme will load once you reopen PowerShell."
}

Write-Host "🔌 Installing posh-git..."
if (Get-Module -ListAvailable -Name posh-git) {
    Write-Host "ℹ️ posh-git already installed."
}
else {
    try {
        Install-Module -Name posh-git -Scope CurrentUser -Force -ErrorAction Stop
        Write-Host "✅ posh-git installed."
    }
    catch {
        Write-Host "⚠️ Couldn't install posh-git: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "   Continuing without it - install it later with: Install-Module posh-git -Scope CurrentUser"
    }
}

# Single-quoted here-string: everything below is written to the profile
# verbatim and only evaluated when a new PowerShell session starts.
$Block = @'
# >>> personal_utils powershell customization >>>
# Managed by personal_utils (tools/powershell-customization.ps1).
# Re-running that script replaces this block; edits outside it are kept.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $ompTheme = 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/spaceship.omp.json'
    if ($env:POSH_THEMES_PATH) {
        $ompLocalTheme = Join-Path $env:POSH_THEMES_PATH 'spaceship.omp.json'
        if (Test-Path $ompLocalTheme) { $ompTheme = $ompLocalTheme }
    }
    oh-my-posh init pwsh --config $ompTheme | Invoke-Expression
}
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
}
try {
    # Needs PSReadLine 2.1+ (ships with PowerShell 7.1+). On Windows
    # PowerShell 5.1 upgrade it with:
    #   Install-Module PSReadLine -Scope CurrentUser -Force
    Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
}
catch { }
# <<< personal_utils powershell customization <<<
'@

Write-Host "⚙️ Configuring $PROFILE..."

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$content = ''
if (Test-Path $PROFILE) {
    $backup = "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item -Path $PROFILE -Destination $backup
    Write-Host "✅ Backup created: $backup"
    $existing = Get-Content -Path $PROFILE -Raw
    if ($existing) { $content = $existing }
}

$startIndex = $content.IndexOf($BlockStart)
$endIndex = $content.IndexOf($BlockEnd)
if ($startIndex -ge 0 -and $endIndex -gt $startIndex) {
    $content = $content.Substring(0, $startIndex) + $Block + $content.Substring($endIndex + $BlockEnd.Length)
    Write-Host "🔁 Replaced the existing customization block."
}
else {
    if ($content -and -not $content.EndsWith("`n")) { $content += "`r`n" }
    $content += "`r`n$Block`r`n"
}

Set-Content -Path $PROFILE -Value $content -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "🎉 Customization complete!" -ForegroundColor Green
Write-Host ""
Write-Host "To apply changes, run:  . `$PROFILE   (or restart your terminal)"
Write-Host ""
Write-Host "Features added:"
Write-Host "✅ Spaceship theme (Oh My Posh)"
Write-Host "✅ Git tab completion (posh-git)"
Write-Host "✅ Auto suggestions from history (PSReadLine 2.1+)"
Write-Host "✅ Syntax highlighting (built into PSReadLine)"
Write-Host ""
Write-Host "💡 If the prompt shows empty boxes instead of icons, install a Nerd Font"
Write-Host "   (oh-my-posh font install meslo) and select it in your terminal's settings."
