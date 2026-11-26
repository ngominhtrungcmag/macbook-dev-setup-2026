# AI apps and coding agents

The one-command Full and AI modes include these packages. Other named modes omit them unless you add `--with-ai`. Use `--skip-ai` with Full to exclude them.

```bash
bash install.sh --mode ai --dry-run
bash install.sh --mode ai
bash install.sh --mode dotnet --with-ai
bash install.sh --mode full --skip-ai
```

| Profile | Homebrew packages |
| --- | --- |
| ai-codex | codex |
| ai-claude | claude-code |
| ai-google | antigravity-cli |
| ai-desktop | chatgpt, claude, cursor, antigravity |

The standalone `codex-app` cask is deprecated in favor of `chatgpt` in Homebrew's catalog. Gemini CLI is not installed by default following Google's migration to Antigravity CLI for individual users; existing supported users should follow official account-specific instructions.

Installation does not start agents, sign into accounts, grant permissions or change billing. Verify application compatibility and licensing, and follow organizational policies for confidential data.

References:
- https://formulae.brew.sh/cask/codex
- https://formulae.brew.sh/cask/claude-code
- https://formulae.brew.sh/cask/antigravity-cli
- https://formulae.brew.sh/cask/codex-app
- https://formulae.brew.sh/cask/chatgpt
- https://formulae.brew.sh/cask/claude
- https://formulae.brew.sh/cask/cursor
- https://formulae.brew.sh/cask/antigravity
- https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/
