#!/usr/bin/env bash

export BIN_DIR=~/.local/bin
export PIPX_BIN_DIR="${PIPX_BIN_DIR:-$BIN_DIR}"
export PATH="$PIPX_BIN_DIR:$PATH"

# Install PipX.
[ -d ~/.pipx ] || python -m venv ~/.pipx
. ~/.pipx/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade "pipx>=1.4,<2"
mkdir -p "$PIPX_BIN_DIR"
ln -sf $(which pipx) "$PIPX_BIN_DIR/pipx"
deactivate

# Install PyInfra.
if ! command -v pyinfra &>/dev/null; then
  pipx install -f 'pyinfra==2.*'
fi

# Install Ansible.
if ! command -v ansible-playbook &>/dev/null; then
  pipx install -f --include-deps 'ansible==9.*'
  LC_ALL=C.UTF-8 ansible-galaxy collection install --upgrade community.general
fi

# Run playbook.
ANSIBLE_LOCALHOST_WARNING="False" \
  ANSIBLE_INVENTORY_UNPARSED_WARNING="False" \
  LC_ALL="C.UTF-8" \
  ansible-playbook apply.yml "$@" --extra-vars "ansible_user=$(whoami)"

# Setup dedicated Python environment for vim.
if [ ! -d ~/.vim/.venv ]; then
  /usr/bin/python3 -m venv ~/.vim/.venv
fi
~/.vim/.venv/bin/python -m pip install --upgrade pynvim ropevim # openai
