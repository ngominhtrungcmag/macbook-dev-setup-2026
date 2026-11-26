#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tag="${1:-}"
out="${2:-}"
if [[ ! "$tag" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ || -z "$out" ]]; then
  echo 'Usage: bash scripts/package-homebrew.sh vMAJOR.MINOR.PATCH OUTPUT_DIR' >&2
  exit 2
fi

name=macbook-dev-setup
archive="$name-$tag.tar.gz"
repo=https://github.com/ngominhtrungcmag/macbook-dev-setup-2026
mkdir -p "$out"
git -C "$root" archive --format=tar --prefix="$name-$tag/" HEAD \
  LICENSE install.sh Brewfile scripts profiles extensions dotfiles \
  | gzip -n > "$out/$archive"
sha="$(shasum -a 256 "$out/$archive")"
cat > "$out/$name.rb" <<FORMULA
class MacbookDevSetup < Formula
  desc "Set up a macOS development workstation"
  homepage "$repo"
  url "$repo/releases/download/$tag/$archive"
  version "${tag#v}"
  sha256 "${sha%% *}"
  license "MIT"

  depends_on :macos

  def install
    libexec.install "install.sh" => "macbook-dev-setup"
    libexec.install "Brewfile", "scripts", "profiles", "extensions", "dotfiles"
    bin.write_exec_script libexec/"macbook-dev-setup"
  end

  test do
    output = shell_output("#{bin}/macbook-dev-setup --dry-run --mode frontend")
    assert_match "Mode: frontend", output
    assert_match "profiles/frontend.Brewfile", output
    assert_match "Runtime: mise install node@26", output
  end
end
FORMULA
