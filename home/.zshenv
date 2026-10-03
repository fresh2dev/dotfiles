# eval $(/opt/homebrew/bin/brew shellenv)

if [ -d '/opt/homebrew' ]; then
  export PATH="/opt/homebrew/bin:$PATH"
  export XDG_DATA_DIRS="/opt/homebrew/share:${XDG_DATA_DIRS}"
fi

export PATH="$HOME/.local/bin:$PATH"

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
