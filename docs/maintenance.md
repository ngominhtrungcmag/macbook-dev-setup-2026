# Maintenance and troubleshooting

## Routine updates

Check what will change before approving updates:

```bash
brew update
brew outdated
# Upgrade only after reviewing the list and compatibility.
brew upgrade
brew doctor
```

Keep project SDKs pinned separately. Homebrew Bundle is not a lockfile and does not freeze all package versions. Revisit release support policies and review each Brewfile periodically.

## Backup installed package inventory

```bash
brew bundle dump --file="$HOME/Brewfile.backup"
```

Choose a new filename if it already exists. Review the inventory before committing or sharing it; it can reveal internal or sensitive tools. A Brewfile is not a backup of application data, preferences or secrets.

## Common problems

| Problem | What to check |
| --- | --- |
| `brew: command not found` | Follow the Homebrew installer PATH instructions; Apple Silicon and Intel use different default prefixes. |
| `xcode-select` error | Install Command Line Tools; select full Xcode when required by mobile tooling. |
| `dotnet` SDK mismatch | Inspect `dotnet --list-sdks` and the project's `global.json`. Check SDK and architecture. |
| `node` missing | Activate mise in your shell or use `mise exec node@26 -- node --version`. |
| Docker cannot connect | Check `colima status`, `docker context ls` and the active context. |
| Compose unavailable | Review `brew info docker-compose` caveats and existing Docker CLI plugin configuration. |
| Brew package unavailable | Check `brew info <package>` and the package's supported macOS releases. |

## Recovery

The install script can be rerun after resolving an error, but it does not provide transactional rollback. Review any partial installations. Do not use `brew bundle cleanup` or destructive uninstall commands as an automatic rollback. Restore user data from a verified backup when needed.

## Release checklist for maintainers

- [ ] Run offline smoke tests and shellcheck.
- [ ] Validate package availability on a supported macOS release.
- [ ] Test core and each optional profile on a disposable or fresh Mac environment.
- [ ] Verify SDK support tables, app licenses and README instructions.
- [ ] Record the macOS version, architecture and date of real installation testing.