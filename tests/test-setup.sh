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
[[ "$(grep -c '^--- ' <<< "$output")" == 7 ]]
if bash scripts/setup.sh --dry-run unknown >/dev/null 2>&1; then exit 1; fi
if bash scripts/setup.sh --dry-run --check >/dev/null 2>&1; then exit 1; fi
bash scripts/setup.sh --help >/dev/null
# Dry-run must also work when called from outside the repository.
(cd / && bash "$root/scripts/setup.sh" --dry-run apps >/dev/null)
echo 'PASS: shell syntax, profile selection, deduplication, invalid arguments, help and working-directory independence.'
