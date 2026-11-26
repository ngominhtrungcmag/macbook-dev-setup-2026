# First-day MacBook checklist

## Before installing developer software

- [ ] Update macOS and review organizational device-management requirements.
- [ ] Verify FileVault status and securely store the recovery method.
- [ ] Review firewall, automatic security updates, screen lock and Find My settings as appropriate.
- [ ] Set up Time Machine or another approved backup process.
- [ ] Use a password manager, passkeys or MFA where available.
- [ ] Preview the daily setup with `bash install.sh --dry-run --mode everyday` and review the selected Brewfiles.
- [ ] Run `bash install.sh --mode everyday`. The installer bootstraps Command Line Tools and Homebrew if needed. Use `--mode full` for all profiles.

## Developer preferences (manual, optional)

- [ ] Configure Finder to display file extensions and choose a preferred view.
- [ ] Configure keyboard shortcuts, trackpad gestures and Dock behavior.
- [ ] Set terminal font, theme and shell preferences.
- [ ] Configure Git identity, editor, SSH or HTTPS authentication.
- [ ] Configure project-specific SDK versions and editor extensions.
- [ ] Open the apps you use. Sign in, activate licenses and grant the macOS permissions each app needs. Set login items if desired.

## Final smoke test

- [ ] Run `bash scripts/doctor.sh`.
- [ ] Run `bash scripts/setup.sh --check apps frontend terminal` for Everyday. Use the profiles shown in the preview for other modes.
- [ ] Clone an authorized project and restore dependencies.
- [ ] Build and test the project; verify local service and container connectivity if applicable.
- [ ] Verify backup and access recovery methods.

Avoid disabling Gatekeeper, SIP or security protections for convenience. Keep private keys, `.env` files, access tokens, VPN profiles and signing credentials outside this repository. For a company-managed Mac, follow your organization's requirements and consult IT before making changes.
