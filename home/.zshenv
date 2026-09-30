export PATH="$HOME/.local/bin:$PATH"

if [ -e '/opt/homebrew/bin/brew' ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export XDG_DATA_DIRS="${HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS}"
fi

export MISE_CONFIG_DIR="$HOME/.config/mise"

# # Add `mise` shims dir to path (typically ~/.local/share/mise/shims)
# eval "$("$HOME/.local/bin/mise" activate --shims)"
# Export all env vars defined in mise/config.toml
eval "$(mise env -s zsh)"

# Define all shell aliases defined in mise/config.toml
mise shell-alias ls --no-header | while read -r name cmd; do
  alias -- "$name=$cmd"
done

if [ -f "$HOME/.secrets.env" ]; then
  source "$HOME/.secrets.env"
fi
