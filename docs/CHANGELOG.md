# 📋 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [1.0.0] — 2026-04-03

### Added

- **Install-Apps.ps1** — Bulk install/upgrade script with logging and summary reporting
- **Update-Apps.ps1** — Update all installed applications via `winget upgrade --all`
- **Export-Installed.ps1** — Export currently installed packages to a reusable text file
- **packages.txt** — Default package list with 20+ curated applications across 6 categories
- Comprehensive **README.md** with quick start guide, script reference, and pro tips
- **Detailed documentation:**
  - `docs/SETUP.md` — Step-by-step setup instructions
  - `docs/TASK-SCHEDULER.md` — Windows Task Scheduler automation guide
  - `docs/TROUBLESHOOTING.md` — Common issues and solutions
- **GitHub templates:**
  - Bug report issue template
  - Feature request issue template
- **CONTRIBUTING.md** — Contribution guidelines and style guide
- **MIT License**

### Features

- Silent, non-interactive installs with auto-acceptance of agreements
- Automatic log file generation with timestamps in `/logs`
- Smart upgrade detection (installs new, upgrades existing, skips up-to-date)
- Per-package error handling with colored console output
- Summary report showing install/skip/fail counts
- Comment and blank line support in `packages.txt`
- Configurable paths for package lists and log files via script parameters
