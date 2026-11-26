# Optional Zsh snippet. Source explicitly after reviewing existing plugins.
# Use a private namespace rather than overwriting ~/.zshrc or ~/.config/starship.toml.
if [[ -o interactive ]]; then
  if command -v mise >/dev/null 2>&1; then eval "$(mise activate zsh)"; fi
  if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi
  if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/macbook-dev-setup/starship.toml}"
    eval "$(starship init zsh)"
  fi
fi
