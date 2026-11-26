#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -d "$(brew --cellar)/macbook-dev-setup" ]]; then
  echo 'Use a Homebrew environment without macbook-dev-setup installed.' >&2
  exit 1
fi
tmp="$(mktemp -d)"
trap 'rm -rf -- "$tmp"' EXIT
tap="macbook-dev-setup-ci/local-${tmp##*.}"
package="$tap/macbook-dev-setup"
export XDG_CONFIG_HOME="$tmp/config" HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_DEVELOPER=1

cleanup() {
  brew uninstall --formula "$package" >/dev/null 2>&1 || true
  brew untap "$tap" >/dev/null 2>&1 || true
  rm -rf -- "$tmp"
}

bash "$root/scripts/package-homebrew.sh" v0.0.0 "$tmp"
mkdir -p "$tmp/tap/Formula"
sed "s|https://github.com/[^\"]*/releases/download/v0.0.0/|file://$tmp/|" \
  "$tmp/macbook-dev-setup.rb" > "$tmp/tap/Formula/macbook-dev-setup.rb"
git -C "$tmp/tap" init -q
git -C "$tmp/tap" add Formula
git -C "$tmp/tap" -c user.name=CI -c user.email=ci@example.invalid commit -qm 'Add smoke test formula'
brew tap "$tap" "$tmp/tap"
trap cleanup EXIT
if brew commands --quiet | awk '$0 == "trust" { found = 1 } END { exit !found }'; then
  brew trust --formula "$package"
fi
brew install "$package"
brew test "$package"
