# Automate with Task Scheduler

Set up Windows Task Scheduler to automatically update your apps on a recurring schedule. Once configured, your software stays up to date without any manual intervention.

---

## Table of Contents

- [Overview](#overview)
- [Step-by-Step Setup](#step-by-step-setup)
- [Using the Install Script Instead](#using-the-install-script-instead)
- [Advanced: Multiple Schedules](#advanced-multiple-schedules)
- [Verifying It Works](#verifying-it-works)
- [Disabling or Removing the Task](#disabling-or-removing-the-task)

---

## Overview

| Setting | Recommendation |
|---|---|
| **Script** | `Update-Apps.ps1` (updates all) or `Install-Apps.ps1` (install + update from list) |
| **Frequency** | Weekly |
| **Day/Time** | Sunday at 2:00 AM (or whenever your PC is on and idle) |
| **Privileges** | Run with highest privileges (Administrator) |

---

## Step-by-Step Setup

### 1. Open Task Scheduler

- Press `Win + R`, type `taskschd.msc`, and press Enter
- Or search for **"Task Scheduler"** in the Start menu

### 2. Create a New Task

- In the right panel, click **"Create Task…"** (not "Create Basic Task")

### 3. General Tab

| Setting | Value |
|---|---|
| **Name** | `WinGet Auto Update` |
| **Description** | `Automatically updates all installed apps using WinGet` |
| **Security options** | Select **"Run whether user is logged on or not"** |
| **Privileges** | ☑️ Check **"Run with highest privileges"** |
| **Configure for** | Windows 10 |

### 4. Triggers Tab

Click **"New…"** to create a trigger:

| Setting | Value |
|---|---|
| **Begin the task** | On a schedule |
| **Frequency** | Weekly |
| **Start** | Choose a date and time (e.g., Sunday at 2:00 AM) |
| **Recur every** | 1 week |
| **Days** | ☑️ Sunday (or your preferred day) |
| **Enabled** | ☑️ Yes |

### 5. Actions Tab

Click **"New…"** to create an action:

| Setting | Value |
|---|---|
| **Action** | Start a program |
| **Program/script** | `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` |
| **Add arguments** | `-ExecutionPolicy Bypass -File "C:\path\to\winget-bulk-installer\scripts\Update-Apps.ps1"` |
| **Start in** | `C:\path\to\winget-bulk-installer` |

> **Important:** Replace `C:\path\to\winget-bulk-installer` with the actual path where you cloned/extracted the repository.

### 6. Conditions Tab (Optional)

| Setting | Recommendation |
|---|---|
| **Start only if the computer is on AC power** | (for laptops) |
| **Wake the computer to run this task** | (optional) |
| **Start only if network is available** | Yes |

### 7. Settings Tab

| Setting | Recommendation |
|---|---|
| **Allow task to be run on demand** | Yes |
| **Run task as soon as possible after a missed start** | Yes |
| **Stop the task if it runs longer than** | 1 hour |
| **If the running task does not end when requested** | Force it to stop |

### 8. Save

Click **OK**. You may be prompted for your Windows password to save the task.

---

## Using the Install Script Instead

If you want to ensure specific apps from your `packages.txt` are always installed (not just update existing ones), use the install script instead:

**Add arguments:**
```
-ExecutionPolicy Bypass -File "C:\path\to\winget-bulk-installer\scripts\Install-Apps.ps1"
```

This is useful if you sometimes uninstall apps and want them reinstalled automatically.

---

## Advanced: Multiple Schedules

You can create multiple tasks for different scenarios:

| Task Name | Script | Schedule | Purpose |
|---|---|---|---|
| `WinGet Weekly Update` | `Update-Apps.ps1` | Weekly (Sunday 2 AM) | Keep all apps current |
| `WinGet Monthly Install Check` | `Install-Apps.ps1` | Monthly (1st, 3 AM) | Ensure all required apps are installed |

---

## Verifying It Works

### Run the Task Manually

1. In Task Scheduler, find your task under **Task Scheduler Library**
2. Right-click → **"Run"**
3. Check the `/logs` folder for output

### Check Task History

1. In Task Scheduler, click on your task
2. Click the **"History"** tab at the bottom
3. Look for **"Action completed"** entries

> **Note:** If history is disabled, enable it:  
> Click **"Enable All Tasks History"** in the right panel of Task Scheduler.

### Check Log Files

```powershell
# View the latest log
Get-ChildItem "C:\path\to\winget-bulk-installer\logs" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content
```

---

## Disabling or Removing the Task

### Disable (keep for later)

1. Right-click the task → **"Disable"**

### Delete

1. Right-click the task → **"Delete"**

### Via PowerShell

```powershell
# Disable
Disable-ScheduledTask -TaskName "WinGet Auto Update"

# Delete
Unregister-ScheduledTask -TaskName "WinGet Auto Update" -Confirm:$false
```

---

## Troubleshooting Task Scheduler

| Issue | Solution |
|---|---|
| Task runs but nothing happens | Check the path in **"Add arguments"** is correct |
| Access denied | Ensure **"Run with highest privileges"** is checked |
| Task shows "Last Run Result: 0x1" | Usually means the script path is wrong |
| Task doesn't run when logged off | Use **"Run whether user is logged on or not"** |
| No log file created | Check the **"Start in"** directory is set correctly |
