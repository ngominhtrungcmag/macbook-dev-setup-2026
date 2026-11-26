# Roadmap

The following milestones are feature targets, not published releases. The first implementation pass is subject to CI and real-machine validation.

| Milestone | Scope | Status |
| --- | --- | --- |
| v0.1.0 | Core Brewfiles, setup/doctor, baseline docs | Existing baseline |
| v0.2.0 | Bootstrap preflight, interactive menu, presets, opt-in preview | Implemented for review |
| v0.3.0 | Ghostty, Starship, Zsh snippet, Nerd Font, chezmoi | Implemented for review |
| v0.4.0 | VS Code extension manifests and starter settings | Implemented for review |
| v0.5.0 | Codex, Claude Code, Antigravity CLI profiles | Implemented for review |
| v0.6.0 | Private Homebrew package snapshot and explicit restore | Implemented for review; not full system backup |
| v0.7.0 | One-command installer, full/default, named modes, custom and menu | Implemented for review |
| v1.0.0 | Stable release | Blocked on validation and maintainer review |

## v1.0 release gate

- [ ] Linux and macOS CI smoke tests and ShellCheck pass on the release commit.
- [ ] Fresh Apple Silicon Mac: one-command bootstrap from no CLT/Homebrew, modes, package installation, repeat installation and check mode verified.
- [ ] Existing Mac: no unexpected changes to shell configuration, user dotfiles, credentials or VS Code default profile.
- [ ] Validate package and extension identifiers and architecture compatibility.
- [ ] Verify .NET / Blazor, Node.js, Python, mobile and container smoke tests.
- [ ] Validate namespaced configuration application, backup preview and trusted restore on macOS.
- [ ] Document known limitations and approve the release; create tag and release notes only then.

Later ideas: optional macOS preferences with reversible, reviewed settings; CI package metadata check; runtime manifest with per-project version selection; private config migration using a user-owned chezmoi repository.
