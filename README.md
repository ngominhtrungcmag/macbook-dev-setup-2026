# MacBook Dev Setup 2026

**One command. Choose a developer mode. Install your workstation.**

A macOS bootstrap toolkit for a new or existing MacBook: apps, command-line tools, development runtimes, IDEs, VS Code extensions and AI coding agents. Apple Silicon first; Intel best-effort. No profile-by-profile selection is required.

> Current implementation is a pre-release toolkit. Offline CI and mocked orchestration tests do not substitute for a fresh physical Mac installation. Administrator prompts, Apple dialogs, licenses, sign-in, full Xcode, platform SDKs and credentials may still need your attention.

## Quick start

### With Homebrew

After the first Homebrew release is published, run these commands on a Mac that already has Homebrew:

```bash
brew tap ngominhtrungcmag/macbook-dev-setup
brew trust --formula ngominhtrungcmag/macbook-dev-setup/macbook-dev-setup
brew install ngominhtrungcmag/macbook-dev-setup/macbook-dev-setup
macbook-dev-setup --dry-run --mode frontend
macbook-dev-setup --menu
```

Run the trust command on Homebrew versions that require tap trust. The formula installs the setup command and its manifests. Choose a mode with `--menu` or pass `--mode NAME` directly to install the selected tools. Run `brew upgrade macbook-dev-setup` to update the setup command.

### On a fresh Mac

Review [install.sh](install.sh) and the [package manifests](profiles/) before running. On a fresh Mac with no Git yet, download the repository archive using macOS's built-in curl and tar, then run the installer in one terminal command (this tracks the mutable main branch; use an audited commit/tag archive for repeatable production use):

```bash
(tmp="$(mktemp -d)" && trap 'rm -rf -- "$tmp"' EXIT && curl -fsSL --proto '=https' https://github.com/ngominhtrungcmag/macbook-dev-setup-2026/archive/refs/heads/main.tar.gz -o "$tmp/setup.tar.gz" && tar -xzf "$tmp/setup.tar.gz" -C "$tmp" && bash "$tmp/macbook-dev-setup-2026-main/install.sh" --mode full)
```

If you already cloned or extracted the repo:

```bash
bash install.sh
```

The default is Full. Use a named mode directly or open a single selection menu:

```bash
bash install.sh --menu
bash install.sh --mode dotnet
bash install.sh --mode ai
```

## Choose your mode

| Mode | Installs |
| --- | --- |
| `full` (default) | All package profiles, Rider, Android Studio, Node.js, Python, modern terminal, desktop apps, AI agents/apps and VS Code extensions |
| `minimal` | Core CLI tools, Git, GitHub CLI, mise and VS Code |
| `dotnet` | .NET 10 SDK, Rider, Node.js, Docker/Colima, Kubernetes tools, database/API apps, modern terminal and relevant extensions |
| `frontend` | Node.js, Chrome, VS Code frontend extensions and modern terminal |
| `mobile` | .NET SDK, Android Studio, Node.js and terminal; full Xcode and project SDKs manual |
| `devops` | Docker CLI, Colima, Compose, kubectl, Helm, database/API apps and terminal |
| `python` | uv, Python 3.13, Python editor extensions and terminal |
| `ai` | Codex, Claude Code, Antigravity CLI, ChatGPT, Claude, Cursor, Antigravity and terminal |
| `everyday` | Desktop utilities, Chrome, Node.js and modern terminal |
| `custom` | Choose explicit package profiles |

Core tools and core VS Code extensions are included in every mode.

```bash
bash install.sh --list
bash install.sh --dry-run --mode full
bash install.sh --mode full --skip-ai
bash install.sh --mode dotnet --with-ai
bash install.sh --mode custom dotnet terminal ai-codex
```

Non-AI named modes other than Full omit AI by default; add `--with-ai` to include all AI profiles. Full includes AI unless `--skip-ai` is supplied. Custom mode accepts `dotnet frontend mobile devops python apps terminal ide ai-codex ai-claude ai-google ai-desktop`.

## What happens automatically

1. Validate native macOS architecture and normal-user execution.
2. Request Apple Command Line Tools installation if missing and wait for completion.
3. Install Homebrew from its official upstream installer if missing.
4. Install the selected Brewfiles, keeping existing packages and continuing across failed profile groups.
5. For frontend/Python profiles, install Node.js 26 via mise and Python 3.13 via uv. Keep existing mise configuration.
6. Install relevant VS Code extensions into a dedicated `MacBook Dev Setup` profile.
7. Create missing Zsh startup files only; existing files are not overwritten or modified.
8. Verify the selected Homebrew packages; report failed stages and return nonzero if necessary.

The same command can be rerun. Package versions and dependencies may change over time; this is not a version-locked system image.

## Installed tools

| Category | Examples |
| --- | --- |
| Core | Git, GitHub CLI, jq, ripgrep, fd, fzf, bat, mise, VS Code |
| .NET | .NET 10 SDK, Rider (license may be required) |
| Frontend | Node.js 26, npm, Chrome |
| Python | uv, Python 3.13 |
| Mobile | Android Studio; full Xcode/Android SDK/MAUI workloads manual |
| Containers | Colima, Docker CLI, Compose, kubectl, Helm |
| Desktop | iTerm2, Rectangle, DBeaver, Postman |
| Terminal | Ghostty, Starship, zoxide, Nerd Font, chezmoi |
| AI CLI | OpenAI Codex, Claude Code, Google Antigravity CLI |
| AI desktop | ChatGPT, Claude, Cursor, Google Antigravity |

Check vendor compatibility and licensing before installing. AI tools are installed, not launched or signed in. The deprecated standalone Codex desktop cask is not included; use the supported ChatGPT cask. Gemini CLI migration details are in [AI tools](docs/ai-tools.md).

## What remains manual

- Confirm macOS/Homebrew administrator prompts and install dialogs.
- Sign in to GitHub, IDEs and AI apps; configure licenses and permissions.
- Install full Xcode and configure required Android SDKs/MAUI workloads, project-specific Java/SDK versions and signing credentials.
- Start Colima and configure the Compose plugin when needed. No background VM or service is started automatically.
- If shell configuration already exists, review and add Homebrew PATH or mise activation yourself.
- Follow project version pins, configure local HTTPS trust and databases as needed.

See [toolchains](docs/toolchains.md) and [first-day checklist](docs/checklist.md). Never run the entire installer with sudo.

## Advanced usage

The original modular scripts remain available:

```bash
bash scripts/setup.sh --dry-run dotnet frontend
bash scripts/setup.sh --check dotnet frontend
bash scripts/doctor.sh
bash scripts/dotfiles.sh --plan
bash scripts/extensions.sh --dry-run all
bash scripts/backup.sh capture "$HOME"
```

Read [developer experience](docs/developer-experience.md), [backup and restore](docs/backup-restore.md), [maintenance](docs/maintenance.md), [inspiration](docs/inspiration.md), [roadmap](ROADMAP.md) and [changelog](CHANGELOG.md).

## Safety and testing

No blanket cleanup, security changes, credential capture or unattended account login. The default Full mode intentionally installs AI packages; use `--skip-ai` or another mode to omit them. Homebrew casks may require permissions, and software installs can update dependencies. Review the package plan first if you are on an existing or managed Mac.

```bash
bash tests/test-setup.sh
bash tests/test-install.sh
shellcheck install.sh scripts/*.sh tests/*.sh
```

Tests exercise Bash syntax, mode selection, preview, profile deduplication and mocked orchestration on CI. They do not download real packages or change the runner's workstation. Report platform, mode and errors with personal information redacted.

MIT License. Contributions welcome.
