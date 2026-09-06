# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed with GNU Stow. There is no build, no test suite, and no
application code. Four stow packages mirror `$HOME`; `home/` plus at most one OS-specific
package is linked:

- `home/` — linked on every platform. `home/.config/zellij/config.kdl` is symlinked to
  `~/.config/zellij/config.kdl`, and so on.
- `home-macos/` — macOS-only files (Brewfile, colima config, mise's `config.macos-arm64.toml`).
  Linked when `os() == "macos"`.
- `home-arch/` / `home-debian/` — Linux distro-family files (currently mise's
  `config.linux.toml`). On Linux the root `justfile` picks one by package manager:
  `pacman` on PATH selects `home-arch`, otherwise `apt` selects `home-debian`, otherwise
  only `home/` is linked. Detection uses `shell('command -v …')`, since `which()` is gated
  behind `set lists` in the pinned just.

The `stow` binary is [Stow-Python](https://github.com/isarandi/stow-python), a drop-in
Python reimplementation of GNU Stow, pinned in the root `mise.toml` together with the other
tools the recipes need (`just`, `fzf`, `ripgrep`). It reads `.stowrc`, supports
`--no-folding` and `--adopt`, and compiles `--ignore` as `($regex)\Z` like GNU Stow does.
`bat` (fzf preview) and `gum` (`adopt` prompts) come from `home/.config/mise/config.toml`.

Every recipe resolves the link target through **`DOTFILES_TARGET`**, exported by the root
`justfile` as `env("DOTFILES_TARGET", env("HOME"))`. It defaults to `$HOME`; export
`DOTFILES_TARGET=/some/dir` to link, clean, and adopt against another directory instead.
The recipes pass `--target "$DOTFILES_TARGET"` explicitly and **reject** a user-supplied
`--target` / `-t` (the hidden `_reject-target` recipe, run before the picker opens and again
before stow), so `.stowrc`'s `--target=~` only matters when stow is invoked by hand. The
variable must be exported; an unexported shell assignment is invisible to `just`.
`.zprofile`, `.zshrc`, mise's `[env]`, and `apps.just` all export it with the same
`${DOTFILES_TARGET:-$HOME}` default, so once the dotfiles are active it is always set.

`.stowrc` sets `--target=~` and `--no-folding`, so stow links **individual files**, never
directories. Adding a file under `home/` and running `just link` creates one new symlink;
it never replaces a real directory in `$HOME` with a link into this repo.

## Commands

All entry points are in the root `justfile`. `just` with no args opens a chooser. The
global `~/.config/just/justfile` does **not** mount this justfile, so run the recipes from
the repo root or with `just -f <repo>/justfile <recipe>`.

| Command | Effect |
|---|---|
| `just link [files] [stow flags]` | stow the named files or, with no files, pick them with `rg --files \| fzf --multi`. File args are resolved relative to the cwd or absolute (so `home/.zshrc` works from the repo root only) and must be a linkable file in a package active on this OS; anything else is rejected before stow runs. Builds a `--ignore` allow-list regex per package; selecting everything stows the packages whole; `-` flags pass through (use `--flag=value` for valued flags). Prints an `ok`/`FAIL` state line per file afterwards, since stow is silent on no-ops; `-n` skips the report |
| `just unlink [files] [stow flags]` / `just relink [files] [stow flags]` | same with `stow --delete` / `--restow`; all three wrap the hidden `_stow-choices` recipe, which pipes `<package>/<path>` lines into the hidden `_stow-picks` stow driver |
| `just clean [depth]` | remove broken symlinks under `~`, `~/.config`, and `~/.local/bin`, and empty dirs under `~` and `~/.config` (default depth 1) |
| `just adopt [path]` | move a real file from `$DOTFILES_TARGET` into a stow package chosen via `gum choose`, then link only those files via `_stow-picks` (warns and skips linking if the package is not active on this OS); a directory (or no arg) opens an `rg --files \| fzf --multi` picker rooted there (default: cwd, or `$DOTFILES_TARGET/.config` from inside the repo) |

`adopt` asks for the package first, then validates every path before moving anything: it
refuses paths outside `$DOTFILES_TARGET` or inside the repo itself, refuses to overwrite a
file that already exists in the chosen package, and only accepts regular files (not
directories) because of `--no-folding`. The package prompt lists every `home*/` directory in
the repo. A `gum confirm` runs once before the move.

## Tool installation

**mise is the single source of truth for CLI tools.** `home/.config/mise/config.toml`
pins every version under `[tools]`, grouped by purpose, using registry names where they
exist and explicit backends (`cargo:`, `go:`, `pipx:`, `npm:`, `aqua:`) otherwise.
`pipx:` tools are installed with `uv` (`pipx.uvx = true`). To add a tool, add a pinned
entry there; do not add `cargo binstall` / `go install` / `uv tool install` lines to a
justfile. The root `mise.toml` is the only exception: it pins just the bootstrap tools the
stow recipes need, so `mise install` in the repo works before anything is linked.

`.zshrc` sets `MISE_CONFIG_DIR="$DOTFILES_TARGET/.config/mise"` and `MISE_AUTO_ENV=true`,
which is how the per-platform `config.macos-arm64.toml` / `config.linux.toml` from the OS
packages get loaded alongside the main config.

Most tools are marked `lazy = true` (requires mise >= 2026.9.0): a bare `mise install`
skips them and they install on first use through a bootstrap shim; `mise install
--include-lazy` installs everything. Tools without `lazy = true` are eager. Any lazy tool
that mise's registry has no `bins` metadata for, and every explicit-backend tool (`cargo:`,
`go:`, `pipx:`, `npm:`), needs a `lazy_bins = [...]` list of its command names or
`mise reshim` fails.

`home/.config/just/apps.just` (reachable as `just apps <recipe>` via the global
`~/.config/just/justfile`) only covers what mise cannot install:

- brew packages and casks: `install-brew` / `update-brew` / `cleanup-brew` / `edit-brewfile`,
  driven by [brew-file](https://github.com/rcmdnk/homebrew-file) reading
  `home-macos/.config/brewfile/Brewfile` via `$HOMEBREW_BREWFILE`; a hidden
  `_install-brew-file` bootstraps brew-file itself
- zsh plugin clones into `$DOTFILES_TARGET/.zsh/<repo>`: `install-zsh-plugins` / `update-zsh-plugins`
- zellij wasm plugins into `$ZELLIJ_CONFIG_DIR/plugins`: `install-zellij-plugins` /
  `update-zellij-plugins`, downloaded with `ghgrab` (itself a lazy mise tool)
- neovim plugins: `update-neovim-plugins` / `install-neovim-plugins` (`vim.pack.update()` headless)
- `install-mise` / `update-mise` / `cleanup-mise` wrappers, plus `cleanup-docker` and `cleanup-macos`

## Structure notes

- **Global justfile**: `home/.config/just/justfile` sets `no-cd` and mounts `apps`, `common`,
  `docs`, and `py` from its own directory (`mod? apps "apps.just"` etc.). It does not
  reference this repo's root `justfile`; there is no `DOTFILES_DIR` variable anywhere.
- **Shell startup chain**: `.zshrc` exports `DOTFILES_TARGET` and `ZDOTDIR`, then sources
  `$ZDOTDIR/.zprofile` (PATH for `$DOTFILES_TARGET/.local/bin`, Homebrew shellenv,
  `mise activate --shims`). `.zshrc` then installs mise via `curl https://mise.run` if it
  is missing, runs `mise activate zsh`, and sets up atuin, fzf-tab, zsh-autosuggestions,
  zsh-syntax-highlighting (cloned into `$DOTFILES_TARGET/.zsh/` by `install-zsh-plugins`),
  starship, zoxide, direnv, and kubectl completion. There is no `.profile`, `.bash_profile`,
  or `.bashrc` in the repo. Every optional tool in `.zshrc` is guarded with `command -v` or
  a directory test; keep it that way. Global env vars like `EDITOR`, `XDG_CONFIG_HOME`,
  `GOPATH`, `CARGO_HOME`, `GHQ_ROOT`, and fzf/zoxide options are set in mise's `[env]`
  table, not in shell rc files; shell aliases live in mise's `[shell_alias]` table.
- **Zellij plugins** are referenced as `file:$ZELLIJ_CONFIG_DIR/plugins/<name>.wasm`
  (`ZELLIJ_CONFIG_DIR` is exported by mise's `[env]`). A bare relative `file:name.wasm`
  resolves against the cwd and `~/.local/share/zellij/plugins`, *not* the config dir.
  `update-zellij-plugins` downloads into the same `$ZELLIJ_CONFIG_DIR/plugins` path.
- `.stowrc` ignores `README.md`, so a README inside a package is never linked.
- `.treefmt.toml` at the repo root is the global treefmt config. It is not inside a stow
  package, so nothing links it to the `~/.config/treefmt/treefmt.toml` path that mise's
  `TREEFMT_CONFIG` points at.
- `PLAN.md` is a dated (2026-09-06) list of inconsistencies and bugs found in a full read of
  the repo, with an ordered cleanup plan. Check it before fixing something it may already cover.
- Neovim config is **not** in this repo despite `rgv` and `update-neovim-plugins`
  depending on it (it lives in the separate `nvim-config` repo).
- `home/.local/bin/` holds one hand-written script: `rgv` (ripgrep → fzf-lua in neovim).

## Conventions

- Files stay in place under `home/` (or an OS package such as `home-macos/`) at their exact
  `$HOME`-relative path; renaming or moving a config file changes where it is linked.
- No machine-specific absolute paths (`/Users/<name>`, `/home/<name>`); use `~` or
  `$HOME`.
- Anything sensitive does not go in this repo; there is no git-crypt setup.
