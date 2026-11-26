# Inspiration and upstream references

We use these projects and docs as design references, not as copied source code. The implementation in this repository is intentionally small, Bash 3.2-compatible and Homebrew-based.

| Source | Adopted design idea | Intentional difference |
| --- | --- | --- |
| [Jeff Geerling Mac Dev Playbook](https://github.com/geerlingguy/mac-dev-playbook) | Separate automated provisioning from manual onboarding | No Ansible requirement |
| [Antoine Toussaint mac-setup](https://github.com/AntoineToussaint/mac-setup) | Bootstrap, profiles, runtime management, doctor | No remote shell bootstrap, automatic hardening or blanket upgrades |
| [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile) | Declarative package manifests, check and snapshot | Not an exact version lock or full backup |
| [chezmoi](https://www.chezmoi.io/quick-start/) | Review diffs before applying configuration | Namespaced starter files, no overwriting existing divergent files |
| [Starship](https://starship.rs/guide/) and [Ghostty](https://ghostty.org/docs/config) | Optional terminal setup | No automatic modification of shell startup files |
| [VS Code CLI](https://code.visualstudio.com/docs/configure/command-line) | Extension manifests and dedicated editor profile | Explicit opt-in, no global settings overwrite |
| [Google migration announcement](https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/) | Update AI tooling for current vendor lifecycle | No automatic sign-in or credential configuration |

Reviewed 26 November 2026. Upstream projects have their own licenses; consult them before reusing any source or assets.
