---
name: technical-troubleshooting
description: Diagnose Windows PowerShell, Ubuntu Bash, Docker, SSH, RDP, networking, Obsidian sync, and developer-tool errors using safe commands, verification, and rollback steps.
---
# Technical troubleshooting

## Procedure
1. Interpret the exact error and affected system, then separate symptoms from likely causes.
2. Offer the safest read-only diagnostics first; do not assume a particular machine, service name, path or distro if unverified.
3. Provide short commands that are ready to paste: PowerShell for Windows, Bash for Linux. Explain needed privileges.
4. Avoid destructive operations, formatting drives, deleting vaults, rotating credentials, resetting configs, or changing firewall exposure without explicit confirmation.
5. For each suggested fix: show expected result, method to verify success, impact/risk and rollback when applicable.
6. Request only the minimum diagnostic output needed for the next decision.

## Response structure
Meaning of error → probable causes → checks → lowest-risk fix → verification → rollback or next diagnostic.
