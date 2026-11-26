#!/usr/bin/env bash
# First-run preflight only. Never downloads or executes a remote installer.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "${1:-}" == --help && $# -eq 1 ]]; then
  echo 'Usage: bash scripts/bootstrap.sh [setup.sh options] (no args opens the menu)'
  exit 0
fi
# Offline preview should not need macOS or Homebrew.
for arg in "$@"; do
  case "$arg" in --dry-run|--list|--help|-h) exec bash "$root/scripts/setup.sh" "$@";; esac
done
[[ "$(uname -s)" == Darwin ]] || { echo 'macOS required.' >&2; exit 1; }
[[ "$(id -u)" != 0 ]] || { echo 'Run without sudo.' >&2; exit 1; }
if ! xcode-select -p >/dev/null 2>&1; then
  echo 'Step 1: run xcode-select --install, then rerun bootstrap.'
  exit 1
fi
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  echo 'Step 2: review and install Homebrew from https://brew.sh/, then rerun bootstrap.'
  exit 1
fi
if [[ $# -eq 0 ]]; then exec bash "$root/scripts/menu.sh"; fi
exec bash "$root/scripts/setup.sh" "$@"
