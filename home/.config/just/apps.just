# CLI tools are installed by mise from $DOTFILES_TARGET/.config/mise/config.toml. This file
# only covers what mise cannot: brew casks, zsh plugin clones, zellij wasm plugins,
# and cache cleanup for the ecosystems mise drives.
set no-cd

# Home directory the dotfiles are linked into; defaults to $HOME (see the root justfile).
export DOTFILES_TARGET := env('DOTFILES_TARGET', env('HOME'))

editor := quote(env('EDITOR', 'nvim'))
brewfile := quote(env('HOMEBREW_BREWFILE', DOTFILES_TARGET / '.config/brewfile/Brewfile'))
zsh_config_dir := quote(DOTFILES_TARGET / '.zsh')

default:
    @ just -f {{ source_file() }} --choose

edit:
    {{ editor }} {{ source_file() }}

##################################################
# mise (source of truth for CLI tools)
##################################################

[positional-arguments]
install-mise *args:
    mise install --yes "$@"

# Bump every pinned version in the mise config to the latest release
update-mise:
    mise upgrade --bump

cleanup-mise:
    mise prune --yes

##################################################
# brew (macOS GUI apps and fonts), driven by brew-file (rcmdnk/homebrew-file).
# The Brewfile is the source of truth; `brew file` reads $HOMEBREW_BREWFILE.
##################################################

# brew-file is itself listed in the Brewfile, but must exist before it can read it.
_install-brew-file:
    command -v brew-file >/dev/null || brew install rcmdnk/file/brew-file

edit-brewfile: _install-brew-file
    brew file edit --file {{ brewfile }}

# Install every package in the Brewfile, then start the services it provides
[positional-arguments]
install-brew *args: _install-brew-file
    brew file install --yes --file {{ brewfile }} "$@"
    brew services start colima syncthing || true

# Full cycle: brew update + upgrade, install missing, uninstall unlisted, rewrite the Brewfile
update-brew: _install-brew-file
    brew file update --yes --file {{ brewfile }}

# Uninstall packages not in the Brewfile, then `brew cleanup`. Add `--dry-run` to preview.
[positional-arguments]
cleanup-brew *args: _install-brew-file
    brew file clean --yes --file {{ brewfile }} "$@"

##################################################
# zsh plugins (git clones sourced by $DOTFILES_TARGET/.zshrc)
##################################################

# GitHub repos cloned into $DOTFILES_TARGET/.zsh/<repo name>
zsh_plugins := '''
    Aloxaf/fzf-tab
    jeffreytse/zsh-vi-mode
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
'''

# Clones that already exist are skipped (git exits non-zero), then everything is pulled
install-zsh-plugins: && update-zsh-plugins
    for repo in {{ replace(zsh_plugins, "\n", " ") }}; do \
        git clone "https://github.com/$repo.git" {{ zsh_config_dir }}/"${repo#*/}" || true; \
    done

update-zsh-plugins:
    find {{ zsh_config_dir }} -type d -mindepth 1 -maxdepth 1 -exec sh -c 'cd "{}" && git pull' \;

##################################################
# zellij plugins (wasm downloads referenced by $DOTFILES_TARGET/.config/zellij/config.kdl)
##################################################

zellij_plugins_dir := '"${ZELLIJ_CONFIG_DIR:?}/plugins"'

# GitHub repos whose latest release ships a single `.wasm` asset
zellij_plugins := '''
    karimould/zellij-forgot
    rvcas/room
    codingfragments/zellij-zextract
    bezbac/zellij-tabula
    JoseMM2002/zellij-favs
'''

install-zellij-plugins: && update-zellij-plugins
    mkdir -p {{ zellij_plugins_dir }}

# Requires `ghgrab` (installed by mise)
update-zellij-plugins:
    ghgrab release --out {{ zellij_plugins_dir }} --asset-regex '^zjstatus\.wasm$' dj95/zjstatus
    for repo in {{ replace(zellij_plugins, "\n", " ") }}; do \
        ghgrab release --out {{ zellij_plugins_dir }} --asset-regex '\.wasm$' "$repo"; \
    done

##################################################
# neovim plugins (config lives in the separate nvim-config repo)
##################################################

update-neovim-plugins:
    nvim --headless -c "lua vim.pack.update()" -c "qa"

install-neovim-plugins: update-neovim-plugins

##################################################
# Cache cleanup
##################################################

cleanup-docker:
    docker system prune --volumes --all --force || true

cleanup-macos:
    mo clean
