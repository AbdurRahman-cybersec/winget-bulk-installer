# Project Planning & Architecture

## Overview

`winget-bulk-installer` is a PowerShell-based automation toolkit for managing Windows applications via WinGet. It simplifies bulk installation, updating, and environment replication for Windows users and administrators.

## Goals

1. **Simplify Windows App Management** — One command to install/update dozens of apps.
2. **Enable Reproducibility** — Easily replicate a configured environment across machines.
3. **Promote Automation** — Support for Task Scheduler to reduce manual maintenance.
4. **Maintainability** — Clear logging, error handling, and modular script design.

## Current Features

### Implemented Scripts

1. **Install-Apps.ps1**
   - Reads package IDs from `packages.txt`
   - Performs install or upgrade (using `--upgrade` flag)
   - Silent execution with auto-accept flags
   - Per-app status reporting (Success, Skipped, Failed)
   - Summary report at completion
   - Timestamped log files

2. **Update-Apps.ps1**
   - Runs `winget upgrade --all`
   - Updates all WinGet-managed apps
   - Ideal for automation/scheduled tasks

3. **Export-Installed.ps1**
   - Exports currently installed WinGet packages to a text file
   - Useful for backup or environment migration

### Infrastructure

- **Logging**: Auto-generated logs in `/logs` directory
- **Package List**: `packages.txt` supports comments and blank lines
- **Documentation**: README, SETUP.md, TROUBLESHOOTING.md, TASK-SCHEDULER.md
- **Templates**: Example package lists in `/templates`

## Architecture

### Directory Structure

```
winget-bulk-installer/
├── packages.txt          # User-configurable package list
├── templates/           # Example configs
│   └── packages-example.txt
├── scripts/             # Core automation scripts
│   ├── Install-Apps.ps1
│   ├── Update-Apps.ps1
│   └── Export-Installed.ps1
├── docs/                # Documentation
├── logs/                # Runtime logs (gitignored)
├── .github/             # GitHub templates
└── README.md
```

### Script Design Principles

- **Idempotency**: Running the script multiple times should be safe (upgrades existing apps)
- **Fail-Safe**: Individual package failures don't stop the entire batch
- **Verbosity**: Clear console output + detailed file logging
- **Parameterization**: Accept paths for package lists and logs as arguments
- **WinGet Best Practices**: Uses `--exact`, `--silent`, `--accept-*` flags

## Roadmap & Future Ideas

### Short-Term

- [ ] Add `-WhatIf` support to simulate installs without executing
- [ ] Support for `--scope` (user vs. machine) installation
- [ ] CSV input support alongside TXT

### Medium-Term

- [ ] **GUI Wrapper**: Simple WinForms/PSQuickUI to view status and edit lists
- [ ] **Diff Tool**: Compare two package lists and show differences
- [ ] **Version Pinning UI**: Manage version constraints easily

### Long-Term

- [ ] **Chocolatey/Scoopy Integration**: Import existing configs from other package managers
- [ ] **Cloud Sync**: Optional sync of `packages.txt` via GitHub Gist or Dropbox
- [ ] **Web Dashboard**: (Future) Remote monitoring of multiple machines

## Design Decisions

1. **PowerShell Scripts** — Native to Windows, no external runtimes needed.
2. **Text-based Package List** — Human-readable, easy to version control, diff-friendly.
3. **Sequential Processing** — WinGet doesn't support parallel installs safely yet.
4. **Exact Match Default** — Prevents accidental installation of wrong apps due to name collisions.

## Known Limitations

- WinGet must be installed (pre-installed on Windows 10 21H1+ / Windows 11)
- Admin privileges required for system-wide installs
- Some apps may require additional configuration (e.g., PATH updates) post-install
- Rate limiting from WinGet source if too many requests in short time

## Contribution Guidelines

See [CONTRIBUTING.md](../CONTRIBUTING.md).

## License

MIT — See [LICENSE](../LICENSE).