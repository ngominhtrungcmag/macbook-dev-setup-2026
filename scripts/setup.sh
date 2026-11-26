#!/usr/bin/env bash
# Compatible with the Bash bundled with macOS (3.2+).
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
profiles=(frontend dotnet mobile devops python apps)
selected=("$root/Brewfile")
mode=install

usage() {
  cat <<'HELP'
Usage: bash scripts/setup.sh [--dry-run|--check] [PROFILE ...]

Core tools are always included. Optional profiles:
  frontend dotnet mobile devops python apps
  all  (all optional profiles; review before installing)

--dry-run  Print selected Brewfiles without installing or changing anything.
--check    Check selected packages without installing them.
--help     Show this help.
HELP
}

add_profile() {
  local file="$root/profiles/$1.Brewfile" existing
  for existing in "${selected[@]}"; do
    if [[ "$existing" == "$file" ]]; then return; fi
  done
  selected+=("$file")
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    --dry-run|--check)
      if [[ "$mode" != install && "$mode" != "${1#--}" ]]; then
        echo 'Choose only one of --dry-run and --check.' >&2; exit 2
      fi
      mode="${1#--}" ;;
    frontend|dotnet|mobile|devops|python|apps) add_profile "$1" ;;
    all) for p in "${profiles[@]}"; do add_profile "$p"; done ;;
    *) echo "Unknown option/profile: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$mode" == dry-run ]]; then
  for file in "${selected[@]}"; do
    printf '\n--- %s ---\n' "${file#"$root/"}"
    cat "$file"
  done
  exit 0
fi

if [[ "$(uname -s)" != Darwin ]]; then echo 'This setup targets macOS.' >&2; exit 1; fi
if [[ "$(id -u)" == 0 ]]; then echo 'Run as your normal user, not root.' >&2; exit 1; fi
if [[ "$(sysctl -in sysctl.proc_translated 2>/dev/null || true)" == 1 ]]; then
  echo 'Use a native arm64 terminal instead of Rosetta.' >&2; exit 1
fi
if ! xcode-select -p >/dev/null 2>&1; then
  echo 'Install Xcode Command Line Tools with: xcode-select --install' >&2; exit 1
fi
if ! command -v brew >/dev/null 2>&1; then
  case "$(uname -m)" in
    arm64) candidate=/opt/homebrew/bin/brew ;;
    x86_64) candidate=/usr/local/bin/brew ;;
    *) echo 'Unsupported architecture.' >&2; exit 1 ;;
  esac
  if [[ -x "$candidate" ]]; then eval "$("$candidate" shellenv)"; fi
fi
if ! command -v brew >/dev/null 2>&1; then
  echo 'Install Homebrew from https://brew.sh/ and follow its PATH instructions.' >&2
  exit 1
fi

# Do not automatically update Homebrew or upgrade the existing package set.
# Homebrew may still update required dependencies as part of an installation.
export HOMEBREW_NO_AUTO_UPDATE=1
status=0
for file in "${selected[@]}"; do
  printf '\n==> %s\n' "${file#"$root/"}"
  if [[ "$mode" == check ]]; then
    brew bundle check --no-upgrade --verbose --file="$file" || status=1
  else
    brew bundle install --no-upgrade --file="$file"
  fi
done
if [[ "$mode" == install ]]; then
  printf '\nPackages installed. Complete manual toolchain steps in docs/toolchains.md.\n'
fi
exit "$status"
