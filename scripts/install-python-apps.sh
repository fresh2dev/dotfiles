#!/usr/bin/env bash

export BIN_DIR=$HOME/.local/bin
export UV_TOOL_BIN_DIR="${UV_TOOL_BIN_DIR:-$BIN_DIR}"
export UV_PYTHON_INSTALL_DIR="${HOME}/.local/share/uv/python"
export PIPX_BIN_DIR="${PIPX_BIN_DIR:-$BIN_DIR}"
export PATH="$UV_TOOL_BIN_DIR:$PATH"

uv python install 3.{8,9,10,11,12}

ln -sf $(ls "$UV_PYTHON_INSTALL_DIR"/*/bin/python3.* | grep '[0-9]$') "$BIN_DIR"/
ln -sf "$BIN_DIR/python3.12" "$BIN_DIR/python3"
ln -sf "$BIN_DIR/python3" "$BIN_DIR/python"

uv tool install --upgrade myke
# uv tool install --upgrade hostbutter
# uv tool install --upgrade figbox

myke os upgrade

# uv tool install --upgrade pipx
#
# pipx install --include-deps 'ansible==9.*'
# LC_ALL=C.UTF-8 ansible-galaxy collection install --upgrade community.general
