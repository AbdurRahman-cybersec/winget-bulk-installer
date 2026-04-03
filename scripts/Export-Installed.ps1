<#
.SYNOPSIS
    Export currently installed WinGet packages to a text file.

.DESCRIPTION
    Generates a packages.txt file from your currently installed apps,
    making it easy to replicate your setup on another machine.

.PARAMETER OutputPath
    Path to save the exported package list. Defaults to "my-packages.txt"
    in the repository root.

.EXAMPLE
    .\scripts\Export-Installed.ps1
    .\scripts\Export-Installed.ps1 -OutputPath "C:\Backup\my-apps.txt"
#>

[CmdletBinding()]
param(
    [string]$OutputPath
)

$scriptRoot = Split-Path -Parent $PSScriptRoot

if (-not $OutputPath) {
    $OutputPath = Join-Path $scriptRoot "my-packages.txt"
}

Write-Host ""
Write-Host "Exporting installed packages..." -ForegroundColor Cyan

# Use winget export (JSON) and parse, or list and extract IDs
$installed = winget list --accept-source-agreements 2>$null |
    Select-Object -Skip 2 |
    Where-Object { $_ -match "\S" }

# Extract package IDs (second-to-last column in winget list output)
$header = "# Exported installed packages - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$header | Out-File -FilePath $OutputPath -Encoding UTF8

# Use winget export for a cleaner approach
$jsonExport = Join-Path $scriptRoot "temp-export.json"
winget export -o $jsonExport --accept-source-agreements 2>$null

if (Test-Path $jsonExport) {
    $data = Get-Content $jsonExport -Raw | ConvertFrom-Json
    $packageIds = $data.Sources.Packages | ForEach-Object { $_.PackageIdentifier }

    foreach ($id in ($packageIds | Sort-Object)) {
        $id | Out-File -Append -FilePath $OutputPath -Encoding UTF8
    }

    Remove-Item $jsonExport -Force
    Write-Host "✅ Exported $($packageIds.Count) packages to: $OutputPath" -ForegroundColor Green
} else {
    Write-Host "⚠ WinGet export failed. Try running as Administrator." -ForegroundColor Yellow
}

Write-Host ""
