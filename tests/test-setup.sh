#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
for script in scripts/*.sh tests/*.sh; do bash -n "$script"; done
output="$(bash scripts/setup.sh --dry-run dotnet frontend dotnet)"
grep -q 'dotnet-sdk@10' <<< "$output"
grep -q 'google-chrome' <<< "$output"
[[ "$(grep -c '^--- profiles/dotnet.Brewfile ---$' <<< "$output")" == 1 ]]
! grep -q 'brew "colima"' <<< "$output" || exit 1
output="$(bash scripts/setup.sh --dry-run all)"
[[ "$(grep -c '^--- ' <<< "$output")" == 8 ]]
if bash scripts/setup.sh --dry-run unknown >/dev/null 2>&1; then exit 1; fi
if bash scripts/setup.sh --dry-run --check >/dev/null 2>&1; then exit 1; fi
bash scripts/setup.sh --help >/dev/null
# Dry-run must also work when called from outside the repository.
(cd / && bash "$root/scripts/setup.sh" --dry-run apps >/dev/null)
! grep -q 'cask "codex"' <<< "$output" || exit 1
output="$(bash scripts/setup.sh --dry-run --preset dotnet-fullstack ai-codex)"
grep -q 'dotnet-sdk@10' <<< "$output"
grep -q 'cask "ghostty"' <<< "$output"
grep -q 'cask "codex"' <<< "$output"
! grep -q 'cask "claude-code"' <<< "$output" || exit 1
[[ "$(grep -c '^--- ' <<< "$output")" == 6 ]]
output="$(bash scripts/setup.sh --dry-run ai)"
grep -q 'antigravity-cli' <<< "$output"
! grep -q 'gemini-cli' <<< "$output" || exit 1
if bash scripts/setup.sh --preset invalid >/dev/null 2>&1; then exit 1; fi
if bash scripts/setup.sh --preset >/dev/null 2>&1; then exit 1; fi
bash scripts/bootstrap.sh --dry-run --preset web | grep -q 'cask "ghostty"'
bash scripts/menu.sh --help >/dev/null
bash scripts/dotfiles.sh --plan | grep -q 'starship.toml'
output="$(bash scripts/extensions.sh --dry-run dotnet frontend dotnet)"
[[ "$(grep -c 'ms-dotnettools.csharp' <<< "$output")" == 1 ]]
grep -q 'esbenp.prettier-vscode' <<< "$output"
if bash scripts/extensions.sh --dry-run invalid >/dev/null 2>&1; then exit 1; fi
bash scripts/backup.sh restore Brewfile | grep -q 'brew "git"'
if bash scripts/backup.sh restore /no-such-brewfile >/dev/null 2>&1; then exit 1; fi
echo 'PASS: syntax, profiles, presets, AI opt-in, extension preview, dotfiles plan and backup preview.'
