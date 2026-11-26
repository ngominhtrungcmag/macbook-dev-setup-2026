# Developer experience

Install the optional terminal tools with `bash scripts/setup.sh terminal` (or a preset containing it). Ghostty, Starship, zoxide and chezmoi are independent choices; do not replace a working terminal environment automatically.

## Review and apply starter files

```bash
bash scripts/dotfiles.sh --plan
bash scripts/dotfiles.sh --diff
bash scripts/dotfiles.sh --apply
```

The local chezmoi source is `dotfiles/`; the destination is your home directory. The only managed files are in `~/.config/macbook-dev-setup/`. Existing differing files and linked targets are rejected; back up or merge your edits manually. This does not initialize or replace your normal chezmoi source repo. If you already use chezmoi, review its existing configuration and use your own source of truth instead.

To activate the shell snippet, review it and add this line manually to your existing `~/.zshrc` (do not duplicate existing mise, zoxide or prompt initialization):

```zsh
source "$HOME/.config/macbook-dev-setup/shell.zsh"
```

Ghostty works without configuration. To opt into our font and padding, review the file and add the following to your existing Ghostty config, substituting your actual home path:

```text
config-file = /Users/YOUR_USER/.config/macbook-dev-setup/ghostty.conf
```

Use `ghostty +list-fonts` where available to verify the installed font. Existing macOS-specific config may take precedence. See https://ghostty.org/docs/config.

## Editor profiles

After installing VS Code, enable its `code` shell command using the Command Palette.

```bash
bash scripts/extensions.sh dotnet frontend
bash scripts/extensions.sh --apply dotnet frontend
code --profile "MacBook Dev Setup" .
```

Select the dedicated profile before reviewing and manually merging the sample settings JSON. Extension installs may update an existing extension or create the named profile. Review publisher identity, licenses, permissions and organizational policy before installing. C# Dev Kit is intentionally manual. Never put tokens or private settings into this public repository.

References:
- https://www.chezmoi.io/quick-start/
- https://starship.rs/guide/
- https://code.visualstudio.com/docs/configure/command-line
- https://ghostty.org/docs/config
