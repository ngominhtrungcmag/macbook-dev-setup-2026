#!/usr/bin/env bash
# Default preview; installs into a dedicated VS Code profile only on --apply.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
groups=(core)
mode=preview
profile='MacBook Dev Setup'
add_group() {
  local g
  for g in "${groups[@]}"; do [[ "$g" != "$1" ]] || return 0; done
  groups+=("$1")
}
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help) echo 'Usage: bash scripts/extensions.sh [--apply|--dry-run] [dotnet frontend python devops all]'; exit 0 ;;
    --apply) mode=apply ;;
    --dry-run) mode=preview ;;
    core|dotnet|frontend|python|devops) add_group "$1" ;;
    all) for g in dotnet frontend python devops; do add_group "$g"; done ;;
    *) echo "Unknown extension group: $1" >&2; exit 2 ;;
  esac
  shift
done
if [[ "$mode" == apply ]]; then
  command -v code >/dev/null 2>&1 || { echo 'Install the VS Code shell command from its Command Palette first.' >&2; exit 1; }
fi
printf 'VS Code profile: %s (%s)\n' "$profile" "$mode"
status=0
for group in "${groups[@]}"; do
  while IFS= read -r id || [[ -n "$id" ]]; do
    case "$id" in ''|\#*) continue ;; esac
    [[ "$id" =~ ^[A-Za-z0-9_-]+\.[A-Za-z0-9_.-]+$ ]] || { echo "Invalid extension ID: $id" >&2; exit 2; }
    printf '  %s\n' "$id"
    if [[ "$mode" == apply ]]; then code --profile "$profile" --install-extension "$id" || status=1; fi
  done < "$root/extensions/$group.txt"
done
exit "$status"
