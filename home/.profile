DEVBOX_GLOBAL_PREFIX="${HOME}/.local/share/devbox/global/default/.devbox/nix/profile/default"

XDG_DATA_DIRS="${DEVBOX_GLOBAL_PREFIX}/share:${HOME}/.nix-profile/share:/nix/var/nix/profiles/default/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

PIPX_BIN_DIR="${HOME}/.local/bin"
EGET_BIN="$PIPX_BIN_DIR"

PATH="${PIPX_BIN_DIR}:${HOME}/.cargo/bin:${DEVBOX_GLOBAL_PREFIX}/bin:${PATH}"

MAMBA_ROOT_PREFIX=$HOME/.python
if [ -d "$MAMBA_ROOT_PREFIX" ]; then
  for x in $(find "$MAMBA_ROOT_PREFIX/envs" -mindepth 1 -maxdepth 1 -type d); do
    PATH="$x/bin:$PATH"
  done
fi
