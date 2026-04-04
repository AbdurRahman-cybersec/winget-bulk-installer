# Detailed Setup Guide

This guide walks you through everything you need to get WinGet Bulk Installer running on your system.

---

## Table of Contents

- [Step 1: Verify WinGet](#step-1-verify-winget)
- [Step 2: Check PowerShell Version](#step-2-check-powershell-version)
- [Step 3: Download This Repository](#step-3-download-this-repository)
- [Step 4: Configure Your Package List](#step-4-configure-your-package-list)
- [Step 5: Run the Installer](#step-5-run-the-installer)
- [Step 6: Verify Installation](#step-6-verify-installation)

---

## Step 1: Verify WinGet

WinGet (Windows Package Manager) comes pre-installed on Windows 10 (21H1+) and Windows 11.

### Check if WinGet is installed:

```powershell
winget --version
```

**Expected output:** A version number like `v1.6.10271` or newer.

### If WinGet is NOT installed:

1. Open the **Microsoft Store**
2. Search for **"App Installer"**
3. Click **Install** or **Update**
4. Restart your terminal and try `winget --version` again

> **Alternative:** Download the latest release directly from [GitHub - microsoft/winget-cli](https://github.com/microsoft/winget-cli/releases).

---

## Step 2: Check PowerShell Version

The scripts work with PowerShell 5.1 (built-in) but we recommend PowerShell 7+ for the best experience.

### Check your version:

```powershell
$PSVersionTable.PSVersion
```

### Install PowerShell 7+ (optional but recommended):

```powershell
winget install --id Microsoft.PowerShell --source winget
```

---

## Step 3: Download This Repository

### Option A: Git Clone (recommended)

```powershell
git clone https://github.com/your-username/winget-bulk-installer.git
cd winget-bulk-installer
```

### Option B: Download ZIP

1. Go to the [repository page](https://github.com/your-username/winget-bulk-installer)
2. Click the green **"Code"** button → **"Download ZIP"**
3. Extract the ZIP to a folder (e.g., `C:\Tools\winget-bulk-installer`)

### Option C: Place Scripts Manually

If you prefer a minimal setup, you only need two files:
- `packages.txt` — your app list
- `scripts/Install-Apps.ps1` — the installer script

Place them in any folder, e.g. `C:\Scripts\`.

---

## Step 4: Configure Your Package List

Edit `packages.txt` in the root of the repository. Add one WinGet package ID per line.

### Finding Package IDs

```powershell
# Search by name
winget search "chrome"

# Search with exact match
winget search --exact --id "Google.Chrome"

# Browse the full catalog
winget search ""
```

### Example `packages.txt`

```text
# Web Browsers
Google.Chrome
Mozilla.Firefox
Microsoft.Edge

# Developer Tools
Microsoft.VisualStudioCode
Git.Git
GitHub.GitHubDesktop
Docker.DockerDesktop
OpenJS.NodeJS.LTS

# Productivity
Microsoft.PowerToys
Notion.Notion
Obsidian.Obsidian

# Communication
Zoom.Zoom
SlackTechnologies.Slack
Discord.Discord

# Media
Spotify.Spotify
VideoLAN.VLC

# Utilities
7zip.7zip
Notepad++.Notepad++
```

### Format Rules

| Rule | Example |
|---|---|
| One package ID per line | `Google.Chrome` |
| Comments start with `#` | `# Browsers` |
| Blank lines are ignored | *(used for organization)* |
| IDs are case-sensitive | `Google.Chrome` ✅ `google.chrome` ❌ |

---

## Step 5: Run the Installer

### Open PowerShell as Administrator

1. Press `Win + X`
2. Click **"Terminal (Admin)"** or **"Windows PowerShell (Admin)"**

### Allow Script Execution (for current session only)

```powershell
Set-ExecutionPolicy Bypass -Scope Process
```

### Navigate to the Project Folder

```powershell
cd C:\path\to\winget-bulk-installer
```

### Run the Install Script

```powershell
.\scripts\Install-Apps.ps1
```

### What Happens Next

The script will:
1. Check that WinGet is installed
2. Read your `packages.txt` file
3. Process each app one-by-one:
   - **Install** if not present
   - **Upgrade** if a newer version exists
   - **Skip** if already up to date
4. Show a summary of results
5. Save a timestamped log to the `/logs` folder

---

## Step 6: Verify Installation

After the script completes, verify your apps were installed:

```powershell
# List all installed WinGet packages
winget list

# Check a specific app
winget list --id Google.Chrome
```

### Check the Log File

Logs are saved with timestamps in the `/logs` directory:

```
logs/
├── install-log_2026-04-03_14-30-00.txt
├── install-log_2026-04-04_09-15-22.txt
└── ...
```

---

## Next Steps

- Set up [automatic weekly updates](TASK-SCHEDULER.md) with Task Scheduler
- [Export your installed apps](../README.md#export-installedps1--export-your-current-setup) to replicate on another machine
- Check [Troubleshooting](TROUBLESHOOTING.md) if you hit any issues
