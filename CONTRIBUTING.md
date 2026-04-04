# Contributing to WinGet Bulk Installer

First off, **thank you** for considering contributing! Every contribution helps make this tool better for the Windows community.

---

## Table of Contents

- [Code of Conduct](#-code-of-conduct)
- [How Can I Contribute?](#-how-can-i-contribute)
- [Getting Started](#-getting-started)
- [Pull Request Process](#-pull-request-process)
- [Style Guidelines](#-style-guidelines)
- [Reporting Bugs](#-reporting-bugs)
- [Suggesting Features](#-suggesting-features)

---

## Code of Conduct

This project follows a simple rule: **be respectful and constructive**. We're all here to learn and build something useful together.

---

## How Can I Contribute?

### Bug Reports
Found a bug? [Open an issue](https://github.com/your-username/winget-bulk-installer/issues/new?template=bug_report.md) using the bug report template.

### Feature Requests
Have an idea? [Open a feature request](https://github.com/your-username/winget-bulk-installer/issues/new?template=feature_request.md) using the feature request template.

### Documentation
- Fix typos or unclear instructions
- Add examples or use cases
- Improve the troubleshooting guide

### Code Contributions
- Fix bugs listed in [Issues](https://github.com/your-username/winget-bulk-installer/issues)
- Implement features from the roadmap
- Improve error handling or logging
- Add new scripts or utilities

---

## Getting Started

1. **Fork** the repository
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/winget-bulk-installer.git
   cd winget-bulk-installer
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes** and test them on a Windows machine
5. **Commit** with a clear message:
   ```bash
   git commit -m "Add: brief description of what you changed"
   ```
6. **Push** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Open a Pull Request** against the `main` branch

---

## Pull Request Process

1. Ensure your script runs without errors on a clean Windows 10/11 installation
2. Update documentation if you've changed functionality
3. Add comments to any complex logic in your PowerShell scripts
4. Follow the [Style Guidelines](#-style-guidelines) below
5. Link any related issues in your PR description

### PR Title Format

```
Add: description     (new features)
Fix: description     (bug fixes)
Docs: description    (documentation changes)
Refactor: description (code restructuring)
```

---

## Style Guidelines

### PowerShell Scripts

- Use **PascalCase** for function names: `Write-Log`, `Test-WinGetInstalled`
- Use **camelCase** for local variables: `$packageList`, `$logPath`
- Add **comment-based help** (`.SYNOPSIS`, `.DESCRIPTION`, `.EXAMPLE`) to all scripts
- Use `[CmdletBinding()]` and `param()` blocks for script parameters
- Include **error handling** with `try/catch` blocks
- Use `Write-Host` with `-ForegroundColor` for user-facing output

### Documentation

- Use **Markdown** for all documentation
- Include **code examples** where applicable
- Keep paragraphs concise and scannable
- Use tables for comparing options or listing parameters

### Commit Messages

- Use the present tense: "Add feature" not "Added feature"
- Use the imperative mood: "Fix bug" not "Fixes bug"
- Keep the first line under 72 characters
- Reference issue numbers where applicable: "Fix: handle spaces in path (#12)"

---

## Reporting Bugs

When reporting a bug, please include:

- **Windows version** (e.g., Windows 11 23H2)
- **PowerShell version** (`$PSVersionTable.PSVersion`)
- **WinGet version** (`winget --version`)
- **Steps to reproduce** the issue
- **Expected behavior** vs. **actual behavior**
- **Log output** (check the `/logs` folder)

---

## Suggesting Features

When suggesting a feature, please describe:

- **The problem** you're trying to solve
- **Your proposed solution** (if you have one)
- **Alternatives** you've considered
- Whether you'd be **willing to implement** it

---

## Questions?

If you have questions about contributing, feel free to [open a discussion](https://github.com/your-username/winget-bulk-installer/discussions) or reach out by creating an issue.

---

**Thank you for helping make WinGet Bulk Installer better!**
