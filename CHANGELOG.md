# Changelog

## Unreleased — one-command installer (v0.7)

- Add a Homebrew release pipeline and a `macbook-dev-setup` command that runs without a source checkout.
- Add root install.sh with Full, Minimal, .NET, Frontend, Mobile, DevOps, Python, AI, Everyday and Custom modes; optional menu and dry-run.
- Bootstrap Apple CLT and official Homebrew when missing; install Node.js, Python and dedicated VS Code extensions automatically by selected mode.
- Add Rider and AI desktop applications alongside existing agents. Support AI opt-in/out and continue past failed package groups.
- Preserve existing Zsh files, verify packages and extend mocked orchestration tests.

Full physical macOS validation remains pending.

## Unreleased — roadmap implementation pass (v0.2–v0.6)

- Add bootstrap preflight, interactive installer and named workstation presets.
- Add optional terminal tools and namespaced chezmoi starter configuration.
- Add dedicated VS Code profile extension manifests.
- Add opt-in Codex, Claude Code and Google Antigravity CLI profiles.
- Keep AI packages out of the `all` preset; individual Gemini CLI migration documented.
- Add private package snapshot and preview-first restore.
- Extend offline smoke tests and CI; add sources, security notes and v1.0 release gates.

Actual macOS installs, extension availability, dotfiles application and restore still require validation. No stable release is claimed.

## Baseline

- Modular Homebrew profiles for .NET, frontend, mobile, Python, DevOps and optional apps.
- Setup, dry-run, check, doctor and documentation.
