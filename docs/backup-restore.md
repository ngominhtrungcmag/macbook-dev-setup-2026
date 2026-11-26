# Package inventory and recovery

This is a package snapshot, **not** a complete backup, lockfile, rollback or system image. Use Time Machine or your organization's approved backup for personal data, project files, credentials, databases, VM data, settings and signing certificates.

## Capture

```bash
bash scripts/backup.sh capture "$HOME"
```

The script creates a new private directory using mktemp and writes a Homebrew Bundle inventory. It does not read home-directory contents or upload files. The inventory may still reveal private taps, app names or organizational tools; inspect it and do not commit it to this public repo.

## Restore

Copy your reviewed snapshot to the new Mac using a trusted private channel. Install Homebrew first and confirm architecture and OS compatibility.

```bash
bash scripts/backup.sh restore /path/to/Brewfile
# Only after reviewing all entries and Ruby code:
bash scripts/backup.sh restore /path/to/Brewfile --apply
```

The preview prints the file without executing it. A Brewfile can execute Ruby code; use only snapshots you trust. Restore installs missing packages with no automatic blanket upgrade or cleanup, but dependency changes are possible. Versions are not pinned; Homebrew's available packages change over time. Repeat manual toolchain setup, logins and personal configuration from approved backups.

Reference: https://docs.brew.sh/Brew-Bundle-and-Brewfile
