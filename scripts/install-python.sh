#!/usr/bin/env bash

curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj --strip-components=1 -C /tmp bin/micromamba

export MAMBA_ROOT_PREFIX=$HOME/.python MAMBA_EXE=/tmp/micromamba

for version in 3.7 3.8 3.9 3.10 3.11 3.12; do
  "$MAMBA_EXE" create -c conda-forge --always-copy --no-allow-uninstall --yes --name ${version} python=${version}
done

### Finally, add this to your shell profile to make each Python version available in PATH.
# MAMBA_ROOT_PREFIX=$HOME/.python
# if [ -d "$MAMBA_ROOT_PREFIX" ]; then
#   for x in $(find "$MAMBA_ROOT_PREFIX/envs" -mindepth 1 -maxdepth 1 -type d); do
#     export PATH="$x/bin:$PATH"
#   done
# fi
