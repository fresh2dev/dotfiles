export DOTFILES_TARGET="${DOTFILES_TARGET:-${HOME:?}}"

export PATH="$DOTFILES_TARGET/.local/bin:$PATH"

if [ -e '/opt/homebrew/bin/brew' ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export XDG_DATA_DIRS="${HOMEBREW_PREFIX}/share:${XDG_DATA_DIRS}"
fi

if command -v mise &>/dev/null; then
  # Add `mise` shims dir to path (typically ~/.local/share/mise/shims)
  eval "$(mise activate --shims)"
fi
