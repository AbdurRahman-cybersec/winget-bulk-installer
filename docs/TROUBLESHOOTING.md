# Troubleshooting Guide

Common issues and their solutions when using WinGet Bulk Installer.

---

## Table of Contents

- [WinGet Issues](#winget-issues)
- [PowerShell Issues](#powershell-issues)
- [Script Issues](#script-issues)
- [Package Issues](#package-issues)
- [Task Scheduler Issues](#task-scheduler-issues)
- [Getting Help](#getting-help)

---

## WinGet Issues

### "winget" is not recognized as a command

**Cause:** WinGet is not installed or not in your system PATH.

**Solution:**
1. Install **"App Installer"** from the [Microsoft Store](https://apps.microsoft.com/detail/9NBLGGH4NNS1)
2. Restart your terminal
3. Try again: `winget --version`

**Alternative:** Download the latest `.msixbundle` from [WinGet releases](https://github.com/microsoft/winget-cli/releases).

---

### WinGet source errors / "Failed to update source"

**Cause:** Network issues or corrupted WinGet source cache.

**Solution:**
```powershell
# Reset WinGet sources
winget source reset --force

# Update sources
winget source update
```

---

### WinGet hangs or is very slow

**Cause:** First-time source indexing or network issues.

**Solution:**
- Wait 1-2 minutes on first run (source indexing is normal)
- Check your internet connection
- Try: `winget source update`

---

## PowerShell Issues

### "Execution of scripts is disabled on this system"

**Cause:** PowerShell execution policy blocks script files.

**Solution (per-session, safest):**
```powershell
Set-ExecutionPolicy Bypass -Scope Process
```

**Solution (permanent for current user):**
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

> **Note:** `Bypass -Scope Process` only affects the current window and resets when you close it. This is the safest approach.

---

### "Access is denied" or "requires elevation"

**Cause:** Script needs Administrator privileges for system-wide installs.

**Solution:**
1. Close your current PowerShell window
2. Right-click PowerShell → **"Run as Administrator"**
3. Navigate to the project folder and run the script again

---

### Script parameters not working

**Cause:** Syntax error when passing parameters.

**Solution — correct syntax:**
```powershell
# Correct
.\scripts\Install-Apps.ps1 -PackageListPath "C:\my-packages.txt"

# Wrong (no space after parameter name)
.\scripts\Install-Apps.ps1 -PackageListPath="C:\my-packages.txt"
```

---

## Script Issues

### "Package list not found"

**Cause:** The script can't find `packages.txt` at the expected path.

**Solution:**
- Make sure `packages.txt` exists in the repository root
- Or specify a custom path:
  ```powershell
  .\scripts\Install-Apps.ps1 -PackageListPath "C:\full\path\to\packages.txt"
  ```

---

### No log file created

**Cause:** The `/logs` directory couldn't be created (permissions issue).

**Solution:**
1. Create the directory manually:
   ```powershell
   New-Item -ItemType Directory -Path ".\logs" -Force
   ```
2. Run the script as Administrator

---

### Script completes but nothing installed

**Cause:** Package IDs in `packages.txt` may be incorrect.

**Solution:**
1. Verify each ID: `winget search --exact --id "Package.ID"`
2. Check for typos (IDs are case-sensitive)
3. Review the log file in `/logs` for error messages

---

## Package Issues

### "No package found matching input criteria"

**Cause:** The package ID doesn't exist in the WinGet repository.

**Solution:**
```powershell
# Search for the correct ID
winget search "app name"

# Use the exact ID from the search results
winget show --id "Exact.Package.Id"
```

---

### Package installs wrong version

**Cause:** WinGet installs the latest version by default.

**Solution — pin a specific version:**
```powershell
winget install --id "Package.Id" --version "1.2.3" --exact
```

To use version pinning with the bulk installer, you'll need to modify `Install-Apps.ps1` or add version info to your package list.

---

### "Installer hash does not match"

**Cause:** The installer was updated but WinGet's manifest hasn't caught up yet.

**Solution:**
```powershell
# Force install (use with caution)
winget install --id "Package.Id" --force

# Or wait 24-48 hours for the manifest to update
```

---

### Package requires a reboot

**Cause:** Some apps (drivers, runtimes) require a system restart.

**Solution:** If multiple packages require reboots, install them last. The script continues past reboot-required packages without interruption.

---

## Task Scheduler Issues

### Task runs but nothing happens

**Solution checklist:**
1. Is the script path correct in **"Add arguments"**?
2. Is **"Run with highest privileges"** checked?
3. Is the **"Start in"** directory set to the project folder?
4. Does the task show in History? (Enable history if needed)

---

### Task shows "Last Run Result: 0x1"

**Cause:** The script exited with an error (exit code 1).

**Solution:**
1. Run the script manually first to see the error
2. Check the log file in `/logs`
3. Common cause: WinGet not found (the scheduled task runs in a different environment)

---

### Task doesn't run when computer is locked

**Solution:**
- Set **"Run whether user is logged on or not"** in the General tab
- You'll need to enter your password when saving the task

---

## Getting Help

If you're still stuck:

1. **Check the logs** — look in the `/logs` folder for detailed output
2. **Search existing issues** — someone may have hit the same problem
3. **Open a new issue** — include your Windows version, PowerShell version, WinGet version, and the error output

[Open an Issue](https://github.com/your-username/winget-bulk-installer/issues/new?template=bug_report.md)
