#!/usr/bin/env bash
# One command, one selected mode. Compatible with macOS Bash 3.2.
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
mode=full
preview=false
menu=false
ai_policy=default
custom=(core)
custom_count=0

list_modes() {
  cat <<'MODES'
Modes:
  full          All supported profiles, AI apps/agents, runtimes and extensions
  minimal       Core CLI tools and VS Code
  dotnet        .NET 10, Rider, Node.js, database/API tools, Docker and terminal
  frontend      Node.js, browser, terminal and frontend extensions
  mobile        .NET SDK, Android Studio, Node.js and terminal (Xcode manual)
  devops        Containers, Kubernetes, database/API apps and terminal
  python        Python 3.13, uv, terminal and Python extensions
  ai            Codex, Claude Code, Antigravity CLI + AI desktop apps and terminal
  everyday      Desktop utilities, browser and modern terminal
  custom        Explicit profile names (e.g. custom dotnet terminal ai-codex)
MODES
}
usage() {
  echo 'Usage: bash install.sh [--mode NAME] [--with-ai|--skip-ai] [--dry-run]'
  echo '       bash install.sh --menu | --list | --help'
  echo '       bash install.sh --mode custom PROFILE [PROFILE ...]'
  echo 'Default mode: full. Each named mode runs without a selection menu.'
  list_modes
  echo 'Custom: dotnet frontend mobile devops python apps terminal ide ai-codex ai-claude ai-google ai-desktop'
}
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) usage; exit 0 ;;
    --list) list_modes; exit 0 ;;
    --mode)
      [[ $# -ge 2 ]] || { echo 'Missing mode name.' >&2; exit 2; }
      shift; mode="$1" ;;
    --menu) menu=true ;;
    --dry-run) preview=true ;;
    --with-ai|--skip-ai)
      if [[ "$ai_policy" != default && "$ai_policy" != "$1" ]]; then
        echo 'Choose only one AI policy.' >&2; exit 2
      fi
      ai_policy="$1" ;;
    dotnet|frontend|mobile|devops|python|apps|terminal|ide|ai-codex|ai-claude|ai-google|ai-desktop)
      custom+=("$1"); custom_count=$((custom_count + 1)) ;;
    *) echo "Unknown option/profile: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done
if [[ "$menu" == true ]]; then
  [[ -t 0 && -t 1 && "$custom_count" == 0 && "$mode" == full ]] || {
    echo 'Use --menu from a terminal without --mode or custom profiles.' >&2; exit 2;
  }
  cat <<'MENU'
MacBook Dev Setup 2026 — choose one mode:
  1) Full (everything + AI)
  2) Minimal
  3) .NET Full-stack
  4) Frontend
  5) Mobile
  6) DevOps
  7) Python
  8) AI apps and agents
  9) Everyday apps
  10) Custom profiles
  q) Quit
MENU
  printf 'Selection: '
  IFS= read -r choice || exit 0
  case "$choice" in
    1) mode=full ;; 2) mode=minimal ;; 3) mode=dotnet ;;
    4) mode=frontend ;; 5) mode=mobile ;; 6) mode=devops ;;
    7) mode=python ;; 8) mode=ai ;; 9) mode=everyday ;;
    10)
      mode=custom
      echo 'Profiles: dotnet frontend mobile devops python apps terminal ide ai-codex ai-claude ai-google ai-desktop'
      printf 'Enter space-separated profiles: '
      IFS=' ' read -r -a chosen || exit 0
      for item in "${chosen[@]}"; do
        case "$item" in
          dotnet|frontend|mobile|devops|python|apps|terminal|ide|ai-codex|ai-claude|ai-google|ai-desktop)
            custom+=("$item"); custom_count=$((custom_count + 1)) ;;
          *) echo "Unknown profile: $item" >&2; exit 2 ;;
        esac
      done ;;
    q|Q) exit 0 ;;
    *) echo 'Unknown selection.' >&2; exit 2 ;;
  esac
fi
if [[ "$mode" != custom && "$custom_count" != 0 ]]; then
  echo 'Profile names require --mode custom.' >&2; exit 2
fi

selected=(core)
add_profile() {
  local p existing
  for p in "$@"; do
    for existing in "${selected[@]}"; do
      if [[ "$existing" == "$p" ]]; then continue 2; fi
    done
    selected+=("$p")
  done
}
add_ai() { add_profile ai-codex ai-claude ai-google ai-desktop; }
case "$mode" in
  full) add_profile dotnet frontend mobile devops python apps terminal ide; add_ai ;;
  minimal) ;;
  dotnet) add_profile dotnet frontend devops apps terminal ide ;;
  frontend) add_profile frontend terminal ;;
  mobile) add_profile mobile dotnet frontend terminal ;;
  devops) add_profile devops apps terminal ;;
  python) add_profile python terminal ;;
  ai) add_profile terminal; add_ai ;;
  everyday) add_profile apps frontend terminal ;;
  custom)
    [[ "$custom_count" -gt 0 ]] || { echo 'Custom mode needs at least one profile.' >&2; exit 2; }
    add_profile "${custom[@]}" ;;
  *) echo "Unknown mode: $mode" >&2; list_modes >&2; exit 2 ;;
esac
if [[ "$ai_policy" == --with-ai ]]; then add_ai; fi
if [[ "$ai_policy" == --skip-ai ]]; then
  [[ "$mode" != ai ]] || { echo 'AI mode cannot be combined with --skip-ai.' >&2; exit 2; }
  filtered=(core)
  for p in "${selected[@]}"; do
    case "$p" in core|ai-*) ;; *) filtered+=("$p") ;; esac
  done
  selected=("${filtered[@]}")
fi
has_profile() {
  local p
  for p in "${selected[@]}"; do [[ "$p" != "$1" ]] || return 0; done
  return 1
}
package_args=(--preset minimal)
extension_args=(core)
for p in "${selected[@]}"; do
  case "$p" in core) ;; *) package_args+=("$p") ;; esac
  case "$p" in dotnet|frontend|python|devops) extension_args+=("$p") ;; esac
done

printf 'Mode: %s\nProfiles: %s\n' "$mode" "${selected[*]}"
if [[ "$preview" == true ]]; then
  echo 'Preflight: native macOS, Apple Command Line Tools, Homebrew (install if missing).'
  bash "$root/scripts/setup.sh" --dry-run "${package_args[@]}"
  if has_profile frontend; then echo 'Runtime: mise install node@26; select a default only if no existing configuration.'; fi
  if has_profile python; then echo 'Runtime: uv python install 3.13'; fi
  bash "$root/scripts/extensions.sh" --dry-run "${extension_args[@]}"
  echo 'Shell: create missing Zsh startup files only; never modify existing ones.'
  echo 'Final step: verify selected Homebrew packages. Sign-in and platform SDK setup remain manual.'
  exit 0
fi

# Platform bootstrap is mandatory. Do not use sudo for the entire installer.
[[ "$(uname -s)" == Darwin ]] || { echo 'This installer requires macOS.' >&2; exit 1; }
[[ "$(id -u)" != 0 ]] || { echo 'Run as your normal macOS user, not root.' >&2; exit 1; }
[[ "$(sysctl -in sysctl.proc_translated 2>/dev/null || true)" != 1 ]] || {
  echo 'Run in a native ARM64 terminal, not Rosetta.' >&2; exit 1;
}
case "$(uname -m)" in
  arm64) brew_path=/opt/homebrew/bin/brew ;;
  x86_64) brew_path=/usr/local/bin/brew ;;
  *) echo 'Unsupported architecture.' >&2; exit 1 ;;
esac

if ! xcode-select -p >/dev/null 2>&1; then
  echo 'Requesting Apple Command Line Tools. Confirm the macOS dialog.'
  xcode-select --install || echo 'Installation may already be requested; waiting for Command Line Tools.'
  for ((attempt=0; attempt<180; attempt++)); do
    if xcode-select -p >/dev/null 2>&1; then break; fi
    sleep 15
  done
  if ! xcode-select -p >/dev/null 2>&1; then
    echo 'Command Line Tools not ready after 45 minutes. Finish the macOS install and rerun.' >&2
    exit 1
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  if [[ ! -x "$brew_path" ]]; then
    echo 'Installing Homebrew from its official upstream installer. Review its prompt.'
    download="$(mktemp -t macbook-brew-install)"
    trap 'rm -f -- "$download"' EXIT
    /usr/bin/curl --fail --show-error --silent --location --proto '=https' \
      https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$download"
    /bin/bash "$download"
    rm -f -- "$download"
    trap - EXIT
  fi
  [[ -x "$brew_path" ]] || { echo 'Homebrew installation did not produce the expected executable.' >&2; exit 1; }
  eval "$("$brew_path" shellenv)"
fi
command -v brew >/dev/null 2>&1 || { echo 'Homebrew is unavailable.' >&2; exit 1; }

failures=0
run_stage() {
  local label="$1"
  shift
  printf '\n==> %s\n' "$label"
  if "$@"; then
    printf 'OK: %s\n' "$label"
  else
    printf 'FAILED: %s (continuing)\n' "$label" >&2
    failures=$((failures + 1))
  fi
}

run_stage 'Homebrew packages' bash "$root/scripts/setup.sh" "${package_args[@]}"

# Existing runtime configuration is respected; only new users get a global Node default.
install_node() {
  command -v mise >/dev/null 2>&1 || return 1
  mise install node@26 || return 1
  local config_base="${XDG_CONFIG_HOME:-$HOME/.config}/mise"
  if [[ -z "${MISE_CONFIG_DIR:-}" && -z "${MISE_GLOBAL_CONFIG_FILE:-}" && -z "${MISE_CONFIG_FILE:-}" && \
        ! -e "$config_base" && ! -L "$config_base" && ! -e "$HOME/.mise.toml" && \
        ! -e "$HOME/.tool-versions" ]]; then
    mise use -g node@26 || return 1
  else
    echo 'Existing mise configuration preserved. Use mise exec node@26 -- node as needed.'
  fi
  mise exec node@26 -- node --version
}
if has_profile frontend; then
  run_stage 'Node.js 26' install_node
fi
if has_profile python; then
  run_stage 'Python 3.13' uv python install 3.13
fi

# Brew's VS Code cask may expose code on PATH; also support the standard app path.
if ! command -v code >/dev/null 2>&1 && [[ -x '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' ]]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi
run_stage 'VS Code extensions' bash "$root/scripts/extensions.sh" --apply "${extension_args[@]}"

# Fresh-machine convenience only. Existing shell files, including symlinks, are untouched.
create_shell_files() {
  local status=0
  if [[ ! -e "$HOME/.zprofile" && ! -L "$HOME/.zprofile" ]]; then
    (umask 077; set -o noclobber; cat > "$HOME/.zprofile" <<'ZPROFILE'
# Homebrew and user-local executables (MacBook Dev Setup).
if [[ "$(uname -m)" == arm64 && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$(uname -m)" == x86_64 && -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
export PATH="$HOME/.local/bin:$PATH"
ZPROFILE
    ) || status=1
  else
    echo 'Existing .zprofile preserved; ensure Homebrew and ~/.local/bin are on PATH.'
  fi
  if [[ ! -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
    (umask 077; set -o noclobber; cat > "$HOME/.zshrc" <<'ZSHRC'
# Optional tools installed by MacBook Dev Setup.
if command -v mise >/dev/null 2>&1; then eval "$(mise activate zsh)"; fi
if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi
if command -v starship >/dev/null 2>&1; then eval "$(starship init zsh)"; fi
ZSHRC
    ) || status=1
  else
    echo 'Existing .zshrc preserved; activate mise/starship/zoxide manually if desired.'
  fi
  return "$status"
}
run_stage 'Fresh shell defaults' create_shell_files
run_stage 'Verify selected Homebrew packages' bash "$root/scripts/setup.sh" --check "${package_args[@]}"

printf '\nMode %s finished with %s failed stage(s).\n' "$mode" "$failures"
echo 'Open a new terminal. Sign in to installed apps/AI agents as needed.'
if has_profile mobile; then echo 'Mobile: install full Xcode, Android SDK and project-specific MAUI workloads manually.'; fi
if has_profile devops; then echo 'Containers: select/configure Docker Compose and start Colima when needed.'; fi
echo 'See docs/toolchains.md for certificates, licenses, project runtime selection and troubleshooting.'
if [[ "$failures" -ne 0 ]]; then
  echo 'Rerun the same command after resolving the failed stages; installed packages are retained.' >&2
  exit 1
fi
