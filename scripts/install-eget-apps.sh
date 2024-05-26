#!/usr/bin/env bash

export EGET_BIN="$HOME/.local/bin"

# Install eget.
if ! command -v eget &>/dev/null; then
  . install-eget.sh && mv eget "$EGET_BIN/eget"
fi

eget mamba-org/micromamba-releases --asset 'linux-64.tar.bz2'

eget jetpack-io/devbox --tag="0.10.7"

eget neovide/neovide --tag="0.13.0"

eget BurntSushi/ripgrep --tag="14.1.0"

eget junegunn/fzf --tag="0.52.1"

eget sharkdp/fd --tag="v9.0.0"

eget sharkdp/bat --tag="v0.24.0"

eget sharkdp/pastel --tag="v0.9.0"

eget dandavison/delta --tag="0.16.5"

eget eza-community/eza --tag="v0.17.2"

eget koalaman/shellcheck --tag="v0.10.0"

eget mvdan/sh --tag="v3.8.0" --to="$EGET_BIN/shfmt"

eget atuinsh/atuin --tag="v18.2.0" --asset "musl"

eget aristocratos/btop --tag="v1.3.2"

eget orf/gping --tag="gping-v1.16.1" --asset "musl"

eget jqlang/jq --tag="jq-1.7.1"

eget charmbracelet/gum --tag="v0.13.0"
eget charmbracelet/glow --tag="v1.5.1"
eget charmbracelet/mods --tag="v1.3.0" --asset=".tar.gz" --asset="^sbom"

eget artempyanykh/marksman --tag="2023-12-09"

eget sxyazi/yazi --tag="v0.2.1"

eget ajeetdsouza/zoxide --tag="v0.9.4"

eget LuaLS/lua-language-server --tag="3.9.1" --asset "musl"

eget starship/starship --tag="v1.19.0" --asset "musl"

eget neovim/neovim --tag="v0.10.0"

eget gohugoio/hugo --tag="v0.125.5" --asset "_extended_" --asset ".tar.gz"

eget harness/drone-cli --tag="v1.7.0"

eget wfxr/code-minimap --tag="v0.6.4"

eget direnv/direnv --tag="v2.34.0"

eget openfaas/faas-cli --tag="0.16.21"

eget orhun/git-cliff --tag="v2.2.1" --asset "musl" --asset "^.sha512" --asset "^.sig" --to="$EGET_BIN/git-cliff"

eget moncho/dry --tag="v0.11.2"

eget sachaos/viddy --tag="v0.4.0"

eget nektos/act --tag="v0.2.61"

eget zellij-org/zellij --tag="v0.40.1"

eget helmwave/helmwave --asset=".tar.gz" --tag="v0.36.0"

eget hairyhenderson/gomplate --tag="v3.11.7" --asset="^-slim"

eget arttor/helmify --tag="v0.4.10"

eget hadolint/hadolint --tag="v2.12.0"

eget devspace-sh/devspace --tag="v6.3.12"

eget marp-team/marp-cli --tag="v3.4.0"

eget mikefarah/yq --tag="v4.43.1" --asset=".tar.gz" --file="yq_*" --to="$EGET_BIN/yq"

eget astral-sh/rye --tag="0.34.0"

eget kubernetes/kompose --tag="v1.32.0" --asset=".tar.gz" --to="$EGET_BIN/kompose"

eget ahmetb/kubectx --tag="v0.9.5" --asset=kubectx --to="$EGET_BIN/kubectl-ctx"

eget ahmetb/kubectx --tag="v0.9.5" --asset=kubens --to="$EGET_BIN/kubectl-ns"

eget keisku/kubectl-explore --tag="v0.7.2" --to="$EGET_BIN/kubectl-explore"

eget corneliusweig/ketall --tag="v1.3.8" --asset="ketall" --file="ketall*" --to="$EGET_BIN/kubectl-get_all"

eget vladimirvivien/ktop --tag="v0.3.5" --asset=kubectl-ktop --file=kubectl-ktop --to="$EGET_BIN/kubectl-ktop"

eget iximiuz/kexp --tag="v0.0.5" --to="$EGET_BIN/kubectl-kexp"

eget derailed/k9s --tag="v0.32.4" --asset=".tar.gz" --asset="^sbom"

eget kubescape/kubescape --tag="v3.0.3" --asset=".tar.gz" --to="$EGET_BIN/kubectl-kubescape"

eget derailed/popeye --tag="v0.11.2" --to="$EGET_BIN/kubectl-popeye"

eget tohjustin/kube-lineage --tag="v0.5.0" --to="$EGET_BIN/kubectl-get_lineage"

eget robscott/kube-capacity --tag="v0.7.4" --to="$EGET_BIN/kubectl-capacity"

eget zegl/kube-score --tag="v1.18.0" --asset=".tar.gz" --to="$EGET_BIN/kubectl-score"

eget boz/kail --tag="v0.17.4" --asset="v3" --to="$EGET_BIN/kubectl-tail"

eget ahmetb/kubectl-tree --tag="v0.4.3" --to="$EGET_BIN/kubectl-tree"

eget kubepug/kubepug --tag="v1.7.1" --asset=".tar.gz" --asset="^.tar.gz." --to="$EGET_BIN/kubectl-deprecations"

eget komodorio/helm-dashboard --tag="v1.3.3" --to="$EGET_BIN/helm-dashboard"

eget https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz --file "helm"

eget https://releases.hashicorp.com/vault/1.16.0/vault_1.16.0_linux_amd64.zip
