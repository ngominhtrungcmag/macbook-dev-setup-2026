# AI coding tools (opt-in)

Use one or more explicit profiles. No credentials are collected, no agents are launched, and no authentication or permission changes are automated.

| Profile | Homebrew package | Documentation |
| --- | --- | --- |
| ai-codex | codex cask | https://github.com/openai/codex |
| ai-claude | claude-code cask | https://formulae.brew.sh/cask/claude-code |
| ai-google | antigravity-cli cask | https://antigravity.google/product/antigravity-cli |

```bash
bash scripts/setup.sh --dry-run ai-codex ai-claude ai-google
bash scripts/setup.sh ai-codex
```

`all` deliberately excludes these tools; `ai` selects all three. Sign in manually according to vendor documentation. Check billing, data handling and organization policy; review tool permissions, avoid unrestricted access, and never send secrets or regulated data to an unapproved service.

## Gemini CLI migration

Google announced the move to Antigravity CLI on 19 May 2026. Individual/free/Google AI Pro/Ultra usage stopped receiving requests via Gemini CLI on 18 June 2026; enterprise licensing and paid API-key cases are distinct. Homebrew marks its Gemini CLI formula deprecated, with a listed disable date of 18 December 2026. We do not include it in the default installer. Existing supported users should follow Google's migration and authentication documentation.

Sources:
- https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/
- https://developers.google.com/gemini-code-assist/docs/deprecations/code-assist-individuals
- https://formulae.brew.sh/formula/gemini-cli
- https://formulae.brew.sh/cask/antigravity-cli
