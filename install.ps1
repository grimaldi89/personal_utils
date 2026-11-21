<#
.SYNOPSIS
  Installs this repo's Windows tools. Equivalent of install.sh (interactive
  menu) and of the makefile's per-tool targets, adapted for PowerShell/winget.
.EXAMPLE
  .\install.ps1
  Shows the interactive menu.
.EXAMPLE
  .\install.ps1 git docker terraform
  Installs the named tools without a menu - the Windows version of
  `make git docker terraform`.
.EXAMPLE
  .\install.ps1 -List
  Lists the names that can be passed on the command line.
.EXAMPLE
  .\make install
  make.cmd forwards to this script, so the Linux commands work as typed
  (prefixed with .\ in PowerShell): .\make install, .\make git, .\make help.
#>
param(
    [switch]$List,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Tools
)

$ErrorActionPreference = 'Stop'

$RepoDir = Split-Path -Parent $PSCommandPath
$SearchDirs = @('tools', 'airbyte', 'alias')

# Names from the Linux makefile that are spelled differently on Windows or
# map to a Windows counterpart, so `install.ps1 <make target>` just works.
$NameAliases = @{
    'aliases'           = 'install_aliases'
    'batcat'            = 'bat'
    'open_ssh_client'   = 'openssh_client'
    'zsh'               = 'powershell'
    'oh-my-zsh'         = 'oh-my-posh'
    'zsh-customization' = 'powershell-customization'
    'gedit'             = 'notepadplusplus'
    'new_venv'          = 'python_venv'
}

$Scripts = @()
foreach ($dir in $SearchDirs) {
    $path = Join-Path $RepoDir $dir
    if (Test-Path $path) {
        # aliases.ps1 is a library meant to be dot-sourced, not run directly - skip it.
        $Scripts += Get-ChildItem -Path $path -Filter '*.ps1' -Recurse -File |
            Where-Object { $_.Name -ne 'aliases.ps1' } |
            Sort-Object FullName |
            ForEach-Object { $_.FullName.Substring($RepoDir.Length + 1) }
    }
}

if ($Scripts.Count -eq 0) {
    Write-Host "❌ No .ps1 scripts found in expected folders." -ForegroundColor Red
    exit 1
}

function Get-ScriptKey {
    param([string]$RelPath)
    [IO.Path]::GetFileNameWithoutExtension($RelPath).ToLower()
}

function Get-ScriptLabel {
    param([string]$RelPath)
    $name = (Get-ScriptKey $RelPath) -replace '[_-]', ' '
    $name = (Get-Culture).TextInfo.ToTitleCase($name)
    switch ($name) {
        'Python Venv' { "Create $name ($RelPath)" }
        'Persist Env' { "Persist Environment Variable ($RelPath)" }
        'Install Aliases' { "Install Aliases ($RelPath)" }
        'Powershell Customization' { "Customize PowerShell ($RelPath)" }
        'Notepadplusplus' { "Install Notepad++ ($RelPath)" }
        default { "Install $name ($RelPath)" }
    }
}

function Invoke-UtilScript {
    param([string]$RelPath)
    $fullPath = Join-Path $RepoDir $RelPath
    Write-Host "🚀 Running: $RelPath" -ForegroundColor Cyan
    # Scripts report failure with `exit 1`, which surfaces here as
    # $LASTEXITCODE. Reset it first so a stale value from an earlier
    # command isn't mistaken for this script failing.
    $global:LASTEXITCODE = 0
    $ok = $true
    try {
        # Out-Host keeps the script's output on screen instead of letting it
        # leak into this function's return value.
        & $fullPath | Out-Host
        if ($LASTEXITCODE -ne 0) { $ok = $false }
    }
    catch {
        Write-Host "❌ $($_.Exception.Message)" -ForegroundColor Red
        $ok = $false
    }
    if ($ok) {
        Write-Host "✅ Done: $RelPath" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Failed: $RelPath" -ForegroundColor Red
    }
    Write-Host "------------------------"
    return $ok
}

# `make`-style targets, so make.cmd can forward its arguments unchanged:
# `help` lists the tools and a lone `install` opens the menu.
if ($Tools -contains 'help') { $List = $true }
if ($Tools -and $Tools.Count -eq 1 -and $Tools[0] -eq 'install') { $Tools = @() }

if ($List) {
    Write-Host "Available tools (run: .\install.ps1 <name> [<name> ...]):"
    foreach ($script in $Scripts) {
        Write-Host ("  {0,-26} {1}" -f (Get-ScriptKey $script), $script)
    }
    exit 0
}

$ToRun = @()

if ($Tools) {
    # Non-interactive: install.ps1 git docker ...
    $byKey = @{}
    foreach ($script in $Scripts) { $byKey[(Get-ScriptKey $script)] = $script }

    $unknown = @()
    foreach ($tool in $Tools) {
        $key = $tool.ToLower()
        if ($NameAliases.ContainsKey($key)) { $key = $NameAliases[$key] }
        if ($byKey.ContainsKey($key)) { $ToRun += $byKey[$key] }
        else { $unknown += $tool }
    }
    if ($unknown.Count -gt 0) {
        Write-Host "❌ Unknown tool(s): $($unknown -join ', ')" -ForegroundColor Red
        Write-Host "💡 Run '.\install.ps1 -List' to see the available names."
        exit 1
    }
}
else {
    Write-Host "`n📂 Select scripts to run:" -ForegroundColor Cyan
    $ScriptMap = @{}
    for ($i = 0; $i -lt $Scripts.Count; $i++) {
        $index = $i + 1
        Write-Host ("  [{0}] {1}" -f $index, (Get-ScriptLabel $Scripts[$i]))
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
        $ToRun += $ScriptMap[$parsed]
    }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ winget is not available - most installers need it. Install 'App Installer' from the Microsoft Store." -ForegroundColor Yellow
}

$failed = @()
foreach ($script in $ToRun) {
    if (-not (Invoke-UtilScript $script)) { $failed += $script }
}

if ($failed.Count -gt 0) {
    Write-Host "⚠️ Finished with failures: $($failed -join ', ')" -ForegroundColor Yellow
    exit 1
}

Write-Host "🎉 All selected scripts completed." -ForegroundColor Green
