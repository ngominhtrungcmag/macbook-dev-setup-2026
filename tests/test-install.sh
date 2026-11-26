#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
full="$(bash install.sh --dry-run)"
for expected in 'Mode: full' 'dotnet-sdk@10' 'cask "rider"' 'cask "codex"' 'cask "claude-code"' 'cask "antigravity-cli"' 'cask "chatgpt"' 'cask "cursor"' 'mise install node@26' 'uv python install 3.13' 'ms-dotnettools.csharp'; do
  grep -Fq "$expected" <<< "$full"
done
minimal="$(bash install.sh --dry-run --mode minimal)"
grep -q 'Mode: minimal' <<< "$minimal"
if grep -Eq 'dotnet-sdk@10|cask "codex"|Runtime: mise' <<< "$minimal"; then exit 1; fi
for mode in dotnet frontend mobile devops python ai everyday; do
  output="$(bash install.sh --dry-run --mode "$mode")"
  grep -q "Mode: $mode" <<< "$output"
done
output="$(bash install.sh --dry-run --mode dotnet --with-ai)"
grep -q 'cask "codex"' <<< "$output"
output="$(bash install.sh --dry-run --skip-ai)"
if grep -Eq 'cask "(codex|claude-code|antigravity-cli|chatgpt|cursor)"' <<< "$output"; then exit 1; fi
output="$(bash install.sh --dry-run --mode custom dotnet ai-codex dotnet)"
[[ "$(grep -c '^--- profiles/dotnet.Brewfile ---$' <<< "$output")" == 1 ]]
grep -q 'cask "codex"' <<< "$output"
if grep -q 'cask "claude-code"' <<< "$output"; then exit 1; fi
if bash install.sh --dry-run --mode invalid >/dev/null 2>&1; then exit 1; fi
if bash install.sh --mode custom --dry-run >/dev/null 2>&1; then exit 1; fi
if bash install.sh --mode minimal dotnet --dry-run >/dev/null 2>&1; then exit 1; fi
if bash install.sh --mode ai --skip-ai --dry-run >/dev/null 2>&1; then exit 1; fi
if bash install.sh --with-ai --skip-ai --dry-run >/dev/null 2>&1; then exit 1; fi
bash install.sh --list >/dev/null

# Test orchestration without performing real package installations or touching user files.
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
mkdir "$tmp/bin" "$tmp/home"
export HOME="$tmp/home"
export TEST_LOG="$tmp/calls.log"
export PATH="$tmp/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
cat > "$tmp/bin/stub" <<'STUB'
#!/usr/bin/env bash
set -eu
name="$(basename "$0")"
case "$name" in
  uname) case "$1" in -s) echo Darwin ;; -m) echo arm64 ;; esac ;;
  id) echo 501 ;;
  sysctl) echo 0 ;;
  xcode-select) echo /mock/CLT ;;
  brew)
    printf 'brew %s\n' "$*" >> "$TEST_LOG"
    if [[ "${FAIL_DOTNET:-0}" == 1 && "$*" == *'bundle install'* && "$*" == *'dotnet.Brewfile'* ]]; then exit 7; fi ;;
  mise|uv|code) printf '%s %s\n' "$name" "$*" >> "$TEST_LOG" ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$tmp/bin/stub"
for command in uname id sysctl xcode-select brew mise uv code; do ln -s stub "$tmp/bin/$command"; done
bash install.sh --mode custom dotnet frontend python ai-codex > "$tmp/output"
grep -q '0 failed stage(s)' "$tmp/output"
grep -q 'mise install node@26' "$TEST_LOG"
grep -q 'uv python install 3.13' "$TEST_LOG"
grep -q 'install-extension ms-dotnettools.csharp' "$TEST_LOG"
grep -q 'bundle check.*ai-codex.Brewfile' "$TEST_LOG"
[[ -f "$HOME/.zprofile" && -f "$HOME/.zshrc" ]]
printf 'existing user configuration\n' > "$HOME/.zshrc"
: > "$TEST_LOG"
if FAIL_DOTNET=1 bash install.sh --mode custom dotnet frontend ai-codex > "$tmp/failure" 2>&1; then
  echo 'Expected nonzero exit on failed package group.' >&2; exit 1
fi
grep -q 'bundle install.*ai-codex.Brewfile' "$TEST_LOG"
grep -q 'mise install node@26' "$TEST_LOG"
grep -q 'existing user configuration' "$HOME/.zshrc"
grep -q 'failed stage(s)' "$tmp/failure"
echo 'PASS: installation modes, AI opt-in/out, custom deduplication, simulated orchestration, failure continuation and existing shell preservation.'
