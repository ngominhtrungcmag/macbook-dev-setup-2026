# MacBook Dev Setup 2026

A modular, reviewable macOS workstation setup for developers. Start with the essentials, then add only the toolchains you need.

**Apple Silicon first · Homebrew · Bash · Optional development profiles**

> Reference date: 25 November 2026. This is a starter kit, not a fully tested macOS image. The scripts have basic static and dry-run tests; actual package installation and application setup still require macOS validation. Package availability changes over time.

## Goals

- Make a fresh MacBook setup repeatable using readable Brewfiles.
- Support backend, frontend, mobile, Python and DevOps workflows.
- Keep developer credentials and system preferences out of a public repository.
- Avoid destructive cleanup, automatic login, global shell edits and automatic background service startup.

## 1. Before you start

- Update macOS to a supported release, subject to your organization's policies.
- Back up your data and check available disk space.
- On Apple Silicon, open a native ARM64 terminal (`uname -m` should return `arm64`). Install Rosetta only if a trusted Intel-only tool requires it.
- Install Apple Command Line Tools:

```bash
xcode-select --install
```

- Install Homebrew using the instructions at [brew.sh](https://brew.sh/). Follow its shell/PATH instructions and open a new terminal.

```bash
brew --version
```

Homebrew supports a range of macOS versions and architectures. Apple Silicon is the primary target; Intel is best-effort, and not all profiles are available on every Mac.

## 2. Quick start

Clone the repository and enter its root directory:

```bash
git clone https://github.com/ngominhtrungcmag/macbook-dev-setup-2026.git
cd macbook-dev-setup-2026
bash scripts/bootstrap.sh
```

The bootstrap performs preflight checks and opens a menu. It never downloads a remote installer. Review the selected packages first (previews also work without Homebrew):

```bash
bash scripts/setup.sh --dry-run dotnet frontend devops
bash scripts/setup.sh dotnet frontend devops
```

For a curated .NET/Blazor workstation or another preset:

```bash
bash scripts/setup.sh --list
bash scripts/setup.sh --dry-run --preset dotnet-fullstack
bash scripts/setup.sh --preset dotnet-fullstack
```

For core tools only:

```bash
bash scripts/setup.sh
```

To check the installed packages without installing missing ones:

```bash
bash scripts/setup.sh --check dotnet frontend devops
bash scripts/doctor.sh
```

Finish the manual steps in [Toolchains](docs/toolchains.md), including Node.js activation, mobile SDKs and Docker Compose configuration. Do not run the scripts with `sudo`; Homebrew or application installers may independently request authorization.

## 3. Profiles

The core Brewfile is included with every run. Profiles are additive and can be combined.

| Profile | Contents | Manual follow-up |
| --- | --- | --- |
| Core (always) | Git, GitHub CLI, jq, ripgrep, fd, fzf, bat, mise, VS Code, ShellCheck | Git identity and shell integration |
| `frontend` | Chrome | Node.js through mise; package manager per project |
| `dotnet` | .NET 10 SDK cask | C# extensions, HTTPS certificate, SDK verification |
| `mobile` | Android Studio | Xcode, Android SDK, simulator/emulator, project workloads |
| `devops` | Colima, Docker CLI, Docker Compose, kubectl, Helm | Start container runtime, configure Compose |
| `python` | uv | Select Python version and project dependencies |
| `apps` | iTerm2, Rectangle, DBeaver, Postman | Optional app sign-in and license checks |
| `terminal` | Ghostty, Starship, zoxide, Nerd Font, chezmoi | Review optional starter dotfiles |
| `ai-codex` | OpenAI Codex CLI | Sign in manually |
| `ai-claude` | Claude Code | Sign in manually |
| `ai-google` | Google Antigravity CLI | Sign in manually; see migration note |

`all` selects non-AI profiles only. AI tools are explicit opt-in (`ai` selects all three); a smaller combination is recommended. Review licensing, architecture compatibility and package requirements first.

## 4. Suggested 2026 toolchains

- **.NET / C# / Blazor:** .NET 10 LTS for new long-lived projects; use .NET 11 STS when required. Respect the project's `global.json`.
- **JavaScript / TypeScript:** Node.js 26 or 24 LTS, using the version and package manager declared by the project.
- **Python:** uv and per-project Python environments.
- **Containers:** Colima + Docker CLI as an optional local runtime. Docker Desktop and OrbStack are alternative choices; avoid running multiple engines unintentionally.
- **Editors:** VS Code by default; JetBrains Rider or another editor can be added manually.

These release recommendations reflect the reference date, not a promise that future versions remain supported. See the [official .NET release policy](https://learn.microsoft.com/en-us/dotnet/core/releases-and-support) and [Node.js release table](https://nodejs.org/en/about/previous-releases).

## 5. Developer experience (optional)

```bash
# Preview namespaced configuration and editor extensions.
bash scripts/dotfiles.sh --plan
bash scripts/dotfiles.sh --diff
bash scripts/extensions.sh dotnet frontend
# Explicitly apply only after reviewing the output.
bash scripts/dotfiles.sh --apply
bash scripts/extensions.sh --apply dotnet frontend
# Optional AI coding tools; no sign-in or credential changes.
bash scripts/setup.sh --dry-run ai-codex ai-google
# Snapshot installed packages, not application data.
bash scripts/backup.sh capture "$HOME"
```

See [developer experience](docs/developer-experience.md), [AI tools](docs/ai-tools.md), and [backup and restore](docs/backup-restore.md). The starter configs are stored under `~/.config/macbook-dev-setup`; activating them is a separate manual step. VS Code extensions are installed into a dedicated profile only after explicit opt-in.

## 6. Documentation

- [Toolchain configuration](docs/toolchains.md)
- [macOS first-day and security checklist](docs/checklist.md)
- [Maintenance, recovery and troubleshooting](docs/maintenance.md)
- [Roadmap](ROADMAP.md) and [inspiration / upstream references](docs/inspiration.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)

## 7. Repository layout

```text
Brewfile                  # Core packages
profiles/                 # Optional Brewfiles
scripts/bootstrap.sh      # First-run preflight
scripts/menu.sh           # Interactive profile selection
scripts/setup.sh          # Install, preview or check
scripts/doctor.sh         # Basic diagnostics
scripts/dotfiles.sh       # Namespaced chezmoi starter configs
scripts/extensions.sh     # VS Code profile extensions
scripts/backup.sh         # Private package inventory and restore
dotfiles/                 # Reviewed configuration examples
extensions/               # Extension manifests
docs/                     # Manual setup guides
tests/test-setup.sh        # Offline smoke tests
.github/workflows/ci.yml  # Syntax and smoke-test workflow
```

## 8. Testing and safety

```bash
bash tests/test-setup.sh
shellcheck scripts/*.sh tests/*.sh
```

The setup uses Homebrew Bundle with `--no-upgrade` and does not call `brew bundle cleanup`. Dependencies can still change during installation. Brewfiles describe desired packages, not exact version locks. To update tools, use the maintenance guide. The core installer does not modify macOS security settings, install credentials, or overwrite your shell config. Optional extensions and dotfiles require an explicit apply step. Homebrew Brewfiles are executable Ruby; restore only trusted snapshots.

## 9. Contributing

Issues and pull requests are welcome. Please provide macOS version, architecture and the failing profile, but redact tokens, paths containing sensitive identities, employer details and private repository URLs.

License: MIT (see [LICENSE](LICENSE)).
