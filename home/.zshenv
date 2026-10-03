export DO_NOT_TRACK='1'

export MISE_CONFIG_DIR="$HOME/.config/mise"
# Enables auto-loading of `config.<os>-<arch>.toml`
export MISE_AUTO_ENV=true

# # Add `mise` shims dir to path (typically ~/.local/share/mise/shims)
# eval "$("$HOME/.local/bin/mise" activate --shims)"
# Export all env vars defined in mise/config.toml, with its tools and `_.path` ahead
# of the inherited PATH. Login shells activate in .zprofile instead, after
# /etc/zprofile's path_helper has reordered PATH.
[[ -o login ]] || eval "$(~/.local/bin/mise activate zsh)"

# Define all shell aliases defined in mise/config.toml
~/.local/bin/mise shell-alias ls --no-header | while read -r name cmd; do
  alias -- "$name=$cmd"
done

if [ -f "$HOME/.secrets.env" ]; then
  source "$HOME/.secrets.env"
fi
