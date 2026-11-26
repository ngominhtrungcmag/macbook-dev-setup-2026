#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != Darwin ]]; then echo 'This diagnostic targets macOS.' >&2; exit 1; fi
printf 'macOS: %s | Architecture: %s\n' "$(sw_vers -productVersion)" "$(uname -m)"
if [[ "$(sysctl -in sysctl.proc_translated 2>/dev/null || true)" == 1 ]]; then
  echo 'WARN: terminal is running under Rosetta.'
fi
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew && "$(uname -m)" == arm64 ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew && "$(uname -m)" == x86_64 ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
status=0
for tool in brew git gh mise; do
  if command -v "$tool" >/dev/null 2>&1; then printf 'OK   %s\n' "$tool";
  else printf 'MISS %s (core)\n' "$tool"; status=1; fi
done
for tool in code dotnet node npm uv docker colima kubectl helm xcodebuild adb; do
  if command -v "$tool" >/dev/null 2>&1; then printf 'OK   %s\n' "$tool";
  else printf 'SKIP %s (optional or not on PATH)\n' "$tool"; fi
done
if ! xcode-select -p >/dev/null 2>&1; then echo 'MISS Xcode Command Line Tools'; status=1; fi
if command -v dotnet >/dev/null 2>&1; then dotnet --list-sdks || status=1; fi
if command -v node >/dev/null 2>&1; then node --version || status=1; fi
if command -v docker >/dev/null 2>&1; then docker --version || status=1; fi
exit "$status"
