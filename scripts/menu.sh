#!/usr/bin/env bash
# Dependency-free interactive entry point; no package installs before confirmation.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "${1:-}" == --help && $# -eq 1 ]]; then
  echo 'Usage: bash scripts/menu.sh (interactive terminal)'
  exit 0
fi
if [[ $# -ne 0 || ! -t 0 || ! -t 1 ]]; then
  echo 'Use an interactive terminal, or scripts/setup.sh --preset NAME for automation.' >&2
  exit 2
fi
cat <<'MENU'
MacBook Dev Setup 2026
Choose your workstation:
  1) Minimal / core only
  2) .NET full-stack (C#, Blazor, frontend, DevOps, terminal)
  3) Web development
  4) Mobile (.NET + Android Studio; Xcode manual)
  5) Platform / DevOps
  6) Python
  7) All non-AI profiles
  q) Quit
MENU
printf 'Selection: '
IFS= read -r choice || exit 0
case "$choice" in
  1) args=(--preset minimal) ;;
  2) args=(--preset dotnet-fullstack) ;;
  3) args=(--preset web) ;;
  4) args=(--preset mobile) ;;
  5) args=(--preset platform) ;;
  6) args=(--preset python) ;;
  7) args=(all) ;;
  q|Q) exit 0 ;;
  *) echo 'Unknown selection.' >&2; exit 2 ;;
esac
printf 'Include optional desktop apps? [y/N] '
IFS= read -r answer || exit 0
case "$answer" in y|Y|yes|YES) args+=(apps);; esac
printf 'Include Codex CLI? [y/N] '
IFS= read -r answer || exit 0
case "$answer" in y|Y|yes|YES) args+=(ai-codex);; esac
printf 'Include Claude Code? [y/N] '
IFS= read -r answer || exit 0
case "$answer" in y|Y|yes|YES) args+=(ai-claude);; esac
printf 'Include Google Antigravity CLI? [y/N] '
IFS= read -r answer || exit 0
case "$answer" in y|Y|yes|YES) args+=(ai-google);; esac
bash "$root/scripts/setup.sh" --dry-run "${args[@]}"
printf '\nInstall the listed packages? [y/N] '
IFS= read -r answer || exit 0
case "$answer" in
  y|Y|yes|YES) exec bash "$root/scripts/setup.sh" "${args[@]}" ;;
  *) echo 'Cancelled. No packages installed.' ;;
esac
