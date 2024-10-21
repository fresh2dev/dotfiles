export DEVBOX_GLOBAL_PREFIX="${HOME}/.local/share/devbox/global/default/.devbox/nix/profile/default"

export XDG_DATA_DIRS="${DEVBOX_GLOBAL_PREFIX}/share:${HOME}/.nix-profile/share:/nix/var/nix/profiles/default/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

export MY_TOOL_DIR="${HOME}/.local/bin"
export UV_TOOL_BIN_DIR="$MY_TOOL_DIR"
export PIPX_BIN_DIR="$MY_TOOL_DIR"
export EGET_BIN="$MY_TOOL_DIR"

if [ -e '/opt/homebrew/bin/brew' ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

export PATH="${MY_TOOL_DIR}:${HOME}/.cargo/bin:${DEVBOX_GLOBAL_PREFIX}/bin:${PATH}"
