#!/usr/bin/env bash
# Manage only this project's namespaced starter files. No shell rc edits.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
src="$root/dotfiles"
target="$HOME/.config/macbook-dev-setup"
mode="${1:---diff}"
if [[ $# -gt 1 ]]; then echo 'Too many arguments.' >&2; exit 2; fi
case "$mode" in
  --help) echo 'Usage: bash scripts/dotfiles.sh [--plan|--diff|--apply]'; exit 0 ;;
  --plan)
    printf 'Namespaced starter files (no changes):\n'
    printf '  ~/.config/macbook-dev-setup/%s\n' starship.toml ghostty.conf shell.zsh vscode-settings.json
    exit 0 ;;
  --diff|--apply) ;;
  *) echo 'Use --plan, --diff or --apply.' >&2; exit 2 ;;
esac
command -v chezmoi >/dev/null 2>&1 || { echo 'Install the terminal profile first.' >&2; exit 1; }
if [[ "$mode" == --diff ]]; then
  exec chezmoi --source="$src" --destination="$HOME" diff
fi
# Refuse existing divergent targets and directory symlinks; never overwrite user edits.
[[ ! -L "$HOME/.config" && ! -L "$target" ]] || { echo 'Refusing symlinked config directory.' >&2; exit 1; }
for name in starship.toml ghostty.conf shell.zsh vscode-settings.json; do
  path="$target/$name"
  if [[ -L "$path" ]] || { [[ -e "$path" ]] && ! cmp -s "$src/dot_config/macbook-dev-setup/$name" "$path"; }; then
    printf 'Existing or linked target; merge manually: %s\n' "$path" >&2
    exit 1
  fi
done
exec chezmoi --source="$src" --destination="$HOME" apply --verbose
