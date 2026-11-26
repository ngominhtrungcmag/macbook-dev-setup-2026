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

## Homebrew releases

The public tap is `ngominhtrungcmag/homebrew-macbook-dev-setup`. The release workflow uses a dedicated SSH deploy key with write access to that tap. To rotate it, add the new public key to the tap with write access, update the source repository's Actions secret `HOMEBREW_TAP_DEPLOY_KEY` with the private key, and remove the old deploy key.

Once the workflow is on the default branch, tag the tested commit with an unused version and push the tag:

```bash
git tag -a v0.7.0 -m "Release v0.7.0"
git push origin v0.7.0
```

The tag workflow runs CI, publishes the runtime archive and its SHA-256-pinned formula as release assets, then updates the tap. If updating the tap fails after publication, fix the issue and rerun the failed job for the same tag. To verify the published package, follow the Homebrew quick start in the README and run `brew test macbook-dev-setup`.
