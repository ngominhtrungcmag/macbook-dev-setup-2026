#!/usr/bin/env bash
# Package inventory only. Do not copy home directories, secrets, or system state.
set -euo pipefail
usage() {
  echo 'Usage: bash scripts/backup.sh capture DIRECTORY | restore BREWFILE [--apply]'
  echo 'Restore previews by default; only apply a reviewed, trusted Brewfile (Ruby code).'
}
if [[ $# -eq 1 && "$1" == --help ]]; then usage; exit 0; fi
if [[ $# -lt 2 || $# -gt 3 ]]; then usage >&2; exit 2; fi
mode="$1"
path="$2"
flag="${3:-}"
case "$mode" in
  capture)
    [[ -z "$flag" && -d "$path" ]] || { echo 'Capture requires an existing directory.' >&2; exit 2; }
    [[ "$(uname -s)" == Darwin && "$(id -u)" != 0 ]] || { echo 'Run as a normal macOS user.' >&2; exit 1; }
    command -v brew >/dev/null 2>&1 || { echo 'Homebrew is required.' >&2; exit 1; }
    umask 077
    base="$(cd -- "$path" && pwd -P)"
    dest="$(mktemp -d "$base/macbook-dev-setup.XXXXXXXX")"
    # brew bundle dump can include private taps and app inventory. Keep the result private.
    if ! brew bundle dump --file="$dest/Brewfile"; then
      echo "Capture failed; inspect private partial snapshot: $dest" >&2; exit 1
    fi
    printf 'Private package snapshot: %s/Brewfile\n' "$dest"
    printf 'Review before sharing. Versions, application data and credentials are not backed up.\n'
    ;;
  restore)
    [[ -f "$path" && ! -L "$path" ]] || { echo 'Choose a regular, non-symlink Brewfile.' >&2; exit 2; }
    case "$flag" in
      '') echo 'Preview only. Review all Ruby instructions before trusting this Brewfile:'; cat -- "$path" ;;
      --apply)
        [[ "$(uname -s)" == Darwin && "$(id -u)" != 0 ]] || { echo 'Run as a normal macOS user.' >&2; exit 1; }
        command -v brew >/dev/null 2>&1 || { echo 'Homebrew is required.' >&2; exit 1; }
        echo 'Applying the explicitly trusted Brewfile; dependencies may change.'
        HOMEBREW_NO_AUTO_UPDATE=1 brew bundle install --no-upgrade --file="$path" ;;
      *) usage >&2; exit 2 ;;
    esac
    ;;
  *) usage >&2; exit 2 ;;
esac
