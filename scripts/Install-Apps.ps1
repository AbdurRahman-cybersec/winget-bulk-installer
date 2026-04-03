<#
.SYNOPSIS
    Bulk install or update applications using WinGet.

.DESCRIPTION
    Reads a list of WinGet package IDs from a text file and installs
    or upgrades each one silently. Supports logging, error handling,
    and summary reporting.

.PARAMETER PackageListPath
    Path to the text file containing WinGet package IDs (one per line).
    Defaults to "packages.txt" in the repository root.

.PARAMETER LogPath
    Path to the log file. Defaults to "logs/install-log_<timestamp>.txt"
    in the repository root.

.EXAMPLE
    .\scripts\Install-Apps.ps1
    .\scripts\Install-Apps.ps1 -PackageListPath "C:\my-packages.txt"
#>

[CmdletBinding()]
param(
    [string]$PackageListPath,
    [string]$LogPath
)

# ── Configuration ───────────────────────────────────────────────────
$ErrorActionPreference = "Continue"
$scriptRoot = Split-Path -Parent $PSScriptRoot  # repo root (parent of /scripts)

if (-not $PackageListPath) {
    $PackageListPath = Join-Path $scriptRoot "packages.txt"
}

if (-not $LogPath) {
    $logDir = Join-Path $scriptRoot "logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $LogPath = Join-Path $logDir "install-log_$timestamp.txt"
}

# ── Functions ───────────────────────────────────────────────────────
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $entry = "[$(Get-Date -Format 'HH:mm:ss')] $Message"
    Write-Host $entry -ForegroundColor $Color
    $entry | Out-File -Append -FilePath $LogPath -Encoding UTF8
}

function Test-WinGetInstalled {
    try {
        $ver = winget --version 2>$null
        if ($ver) {
            Write-Log "WinGet detected: $ver" "Green"
            return $true
        }
    } catch {}
    Write-Log "ERROR: WinGet is not installed. Install 'App Installer' from the Microsoft Store." "Red"
    return $false
}

# ── Pre-flight Checks ──────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   WinGet Bulk Installer & Updater               ║" -ForegroundColor Cyan
Write-Host "║   github.com/your-username/winget-bulk-installer ║" -ForegroundColor DarkCyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-WinGetInstalled)) { exit 1 }

if (-not (Test-Path $PackageListPath)) {
    Write-Log "ERROR: Package list not found at '$PackageListPath'" "Red"
    exit 1
}

# ── Read & Filter Package List ──────────────────────────────────────
$apps = Get-Content $PackageListPath |
    Where-Object { $_ -and $_.Trim() -ne "" -and -not $_.TrimStart().StartsWith("#") } |
    ForEach-Object { $_.Trim() }

if ($apps.Count -eq 0) {
    Write-Log "WARNING: No packages found in '$PackageListPath'" "Yellow"
    exit 0
}

Write-Log "Found $($apps.Count) package(s) to process" "Cyan"
Write-Log "Log file: $LogPath" "DarkGray"
Write-Host ""

# ── Install / Upgrade Loop ─────────────────────────────────────────
$success = 0
$failed  = 0
$skipped = 0
$failedApps = @()

foreach ($app in $apps) {
    Write-Log "▶ Processing: $app" "Cyan"

    try {
        $output = winget install --id=$app `
            --silent `
            --accept-package-agreements `
            --accept-source-agreements `
            --exact `
            --disable-interactivity `
            --upgrade 2>&1

        $outputStr = $output | Out-String

        if ($LASTEXITCODE -eq 0 -or $outputStr -match "No available upgrade" -or $outputStr -match "already installed") {
            if ($outputStr -match "No available upgrade" -or $outputStr -match "already installed") {
                Write-Log "  ⏭ Already up to date: $app" "DarkGray"
                $skipped++
            } else {
                Write-Log "  ✅ Success: $app" "Green"
                $success++
            }
        } else {
            Write-Log "  ❌ Failed: $app (exit code $LASTEXITCODE)" "Red"
            $failed++
            $failedApps += $app
        }
    } catch {
        Write-Log "  ❌ Exception: $app - $($_.Exception.Message)" "Red"
        $failed++
        $failedApps += $app
    }
}

# ── Summary ─────────────────────────────────────────────────────────
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Log "SUMMARY" "White"
Write-Log "  Total:     $($apps.Count)" "White"
Write-Log "  Installed: $success" "Green"
Write-Log "  Skipped:   $skipped (already up to date)" "DarkGray"
Write-Log "  Failed:    $failed" $(if ($failed -gt 0) { "Red" } else { "Green" })

if ($failedApps.Count -gt 0) {
    Write-Log "  Failed packages:" "Yellow"
    foreach ($f in $failedApps) {
        Write-Log "    - $f" "Yellow"
    }
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
Write-Log "Full log saved to: $LogPath" "DarkGray"
Write-Host ""
