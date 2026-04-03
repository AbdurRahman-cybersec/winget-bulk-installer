<#
.SYNOPSIS
    Update all WinGet-managed applications in one command.

.DESCRIPTION
    Runs "winget upgrade --all" to update every installed application
    that has a newer version available. Ideal for Task Scheduler automation.

.PARAMETER LogPath
    Optional path to a log file.

.EXAMPLE
    .\scripts\Update-Apps.ps1
#>

[CmdletBinding()]
param(
    [string]$LogPath
)

$ErrorActionPreference = "Continue"
$scriptRoot = Split-Path -Parent $PSScriptRoot

if (-not $LogPath) {
    $logDir = Join-Path $scriptRoot "logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $LogPath = Join-Path $logDir "update-log_$timestamp.txt"
}

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   WinGet Bulk Updater                            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Checking for updates..." -ForegroundColor Cyan

winget upgrade --all `
    --silent `
    --accept-package-agreements `
    --accept-source-agreements `
    --disable-interactivity `
    --include-unknown 2>&1 | Tee-Object -FilePath $LogPath

Write-Host ""
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] ✅ Update sweep complete!" -ForegroundColor Green
Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Log saved to: $LogPath" -ForegroundColor DarkGray
