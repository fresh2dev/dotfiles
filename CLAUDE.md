# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles linked into `$HOME` by mise's built-in dotfiles manager
([`mise dot`](https://mise.jdx.dev/dotfiles.html)). There is no build, no test suite, and no
application code. Two directories mirror `$HOME`:

- `home/`: linked on every platform. `home/.config/zellij/config.kdl` is linked to
  `~/.config/zellij/config.kdl`, and so on.
- `home-macos/`: macOS-only files (Brewfile, colima config, mise's
  `config.macos-arm64.toml`, `.hushlogin`, the `mise-env.plist` LaunchAgent).

The root `mise.toml` pins `just` under `[tools]` and ends with a **`[dotfiles]` table** that
has one entry per file:

```toml
"~/.zshrc" = { source = "home/.zshrc", mode = "symlink" }
"~/.hushlogin" = { source = "home-macos/.hushlogin", mode = "symlink", variants = [{ os = "macos" }] }
```

Keys are `~/…` targets and sources are repo-relative. `mode = "symlink"` creates an absolute
symlink into the checkout. Only individual files are linked, never directories, and there are
no whole-directory or `symlink-each` entries. `home-macos/` entries carry
`variants = [{ os = "macos" }]`, so mise skips them on any other OS. `README.md` files inside
the packages have no entry. There is no Linux-specific package.

The root `justfile` exports `MISE_CONFIG_DIR` as the repo root (`source_directory()`), and
each recipe runs `mise dot` from there, so mise reads the repo's `mise.toml` without
`mise trust`. The `MISE_CONFIG_DIR` export only applies to recipe processes; the user's shell
sets its own in `.zshenv`.

## Commands

All entry points are in the root `justfile`. `just` with no args opens a chooser. The
global `~/.config/just/justfile` does **not** mount this justfile, so run the recipes from
the repo root or with `just -f <repo>/justfile <recipe>`.

| Command | Effect |
|---|---|
| `just link [targets…]` | `mise dot apply`: link every `[dotfiles]` entry, or only the named targets (`~/.zshrc`; absolute `$HOME/…` paths also work) |
| `just unlink [targets…]` | `mise dot unapply`: remove every link, or only the named targets |
| `just status` | `mise dot status` (output passed through unchanged, history notes included) |
| `just diff [targets…]` | `mise dot diff` |
| `just adopt <paths…>` | move regular files from `$HOME` into `home/`, append a `[dotfiles]` entry per file to the end of `mise.toml`, then `mise dot apply -y` only those targets |

`adopt` is `[no-cd]`, so relative paths resolve against the caller's cwd. It validates every
path before moving anything and exits non-zero, naming the path, if any path is not a
regular file (directory, symlink, missing), is outside `$HOME`, is inside the repo, already
exists as `home/<rel>`, already has a `"~/<rel>"` key in `mise.toml`, or is given twice.
It always adopts into `home/`; macOS-only entries are added by hand. It never calls
`mise dot add`, because that writes absolute, machine-specific target keys.

Relative symlinks from before the migration that already point at the right source show as
`applied`, so migrating a live machine needs only `just link`.

## Tool installation

**mise is the single source of truth for CLI tools.** `home/.config/mise/config.toml`
pins every version under `[tools]`, grouped by purpose, using registry names where they
exist and explicit backends (`cargo:`, `go:`, `pypi:`, `npm:`, `aqua:`) otherwise.
To add a tool, add a pinned entry there; do not add `cargo binstall` / `go install` /
`uv tool install` lines to a justfile. The root `mise.toml` is the only exception: it pins
just `just`, so `mise install` in the repo works before anything is linked.

`.zshenv` sets `MISE_CONFIG_DIR="$HOME/.config/mise"` and `.zshrc` sets
`MISE_AUTO_ENV=true`, which is how the per-platform `config.macos-arm64.toml` from
`home-macos/` gets loaded alongside the main config.

Most tools are marked `lazy = true` (requires mise >= 2026.9.0): a bare `mise install`
skips them and they install on first use through a bootstrap shim; `mise install
--include-lazy` installs everything. Tools without `lazy = true` are eager. Any lazy tool
that mise's registry has no `bins` metadata for, and every explicit-backend tool (`cargo:`,
`go:`, `pypi:`, `npm:`), needs a `lazy_bins = [...]` list of its command names or
`mise reshim` fails.

The global justfile `home/.config/just/justfile` (run with `just -g <recipe>`) only
covers what mise cannot install:

- brew packages and casks: `install-brew` / `update-brew` / `cleanup-brew` / `edit-brewfile`,
  driven by [brew-file](https://github.com/rcmdnk/homebrew-file) reading
  `~/.config/brewfile/Brewfile` (linked from `home-macos/`) via `$HOMEBREW_BREWFILE`; a hidden
  `_install-brew-file` bootstraps brew-file itself
- zsh plugin clones into `~/.zsh/<repo>`: `install-zsh-plugins` / `update-zsh-plugins`
- zellij wasm plugins into `$ZELLIJ_CONFIG_DIR/plugins`: `install-zellij-plugins` /
  `update-zellij-plugins`, downloaded with `ghgrab` (itself a lazy mise tool)
- neovim plugins: `update-neovim-plugins` / `install-neovim-plugins` (`vim.pack.update()` headless)
- `install-mise` / `update-mise` / `cleanup-mise` wrappers, plus `cleanup-docker` and `cleanup-macos`

## Structure notes

- **Global justfile**: `home/.config/just/justfile` sets `no-cd` and holds the recipes
  above directly. It derives `brewfile` and `zsh_config_dir` from `env('HOME')` and does not
  reference this repo's root `justfile`.
- **Shell startup chain** (zsh only; there is no `.profile`, `.bash_profile`, or `.bashrc`):
  - `.zshenv` prepends `$HOME/.local/bin` to `PATH`, runs Homebrew's shellenv when
    `/opt/homebrew/bin/brew` exists, exports `MISE_CONFIG_DIR="$HOME/.config/mise"`, loads
    mise's `[env]` with `mise env -s zsh`, defines aliases from `mise shell-alias ls`, and
    sources `$HOME/.secrets.env` if present.
  - `.zshrc` exports `ZDOTDIR` (default `$HOME`), sources `$ZDOTDIR/.zprofile`, sets
    `MISE_AUTO_ENV=true`, and runs `$HOME/.local/bin/mise activate zsh`. It then sets up
    atuin (falling back to `HISTFILE="$HOME/.zsh_history"`), brew-wrap, fzf-tab, fzf,
    zsh-autosuggestions, and zsh-syntax-highlighting (cloned into `$HOME/.zsh/` by
    `install-zsh-plugins`), and finally starship, direnv, and zoxide.
  - `.zprofile` is empty. `.zlogin` creates any `XDG_*_HOME` directory that is set.
  - Optional tools and plugins in `.zshrc` are guarded with `command -v` or a directory
    test; guard new ones the same way. starship, direnv, and zoxide are eager mise tools and
    are initialized unconditionally.
  - Global env vars like `EDITOR`, `XDG_CONFIG_HOME`, `GOPATH`, `CARGO_HOME`, `GHQ_ROOT`,
    and fzf/zoxide options are set in mise's `[env]` table (using `{{ env.HOME }}`), not in
    shell rc files. Shell aliases live in mise's `[shell_alias]` table.
- **Zellij plugins** are referenced as `file:$ZELLIJ_CONFIG_DIR/plugins/<name>.wasm`
  (`ZELLIJ_CONFIG_DIR` is exported by mise's `[env]`). A bare relative `file:name.wasm`
  resolves against the cwd and `~/.local/share/zellij/plugins`, *not* the config dir.
  `update-zellij-plugins` downloads into the same `$ZELLIJ_CONFIG_DIR/plugins` path.
- `home/.config/mise/config.toml` is itself a `[dotfiles]` entry. In a throwaway `HOME`,
  `mise dot apply` warns that the linked global config is not trusted; linking still works.
- `.treefmt.toml` at the repo root is the global treefmt config. It has no `[dotfiles]`
  entry, so nothing links it to the `~/.config/treefmt/treefmt.toml` path that mise's
  `TREEFMT_CONFIG` points at.
- Neovim config is **not** in this repo despite `rgv` and `update-neovim-plugins`
  depending on it (it lives in the separate `nvim-config` repo).
- `home/.local/bin/` holds one hand-written script: `rgv` (ripgrep → fzf-lua in neovim).

## Conventions

- Adding a file under `home/` (or `home-macos/`) also requires a `[dotfiles]` entry in the
  root `mise.toml`; without one it is never linked. Then run `just link ~/<path>`.
  `home-macos/` entries add `variants = [{ os = "macos" }]`.
- `[dotfiles]` stays the **last** table in `mise.toml`, because `adopt` appends entries to
  the end of the file.
- `[dotfiles]` keys start with `~/` and sources are repo-relative. Never write absolute paths
  there, and never use `mise dot add`.
- Files stay in place under `home/` (or `home-macos/`) at their exact `$HOME`-relative
  path; renaming or moving a config file changes where it is linked, and its entry must
  change with it.
- No machine-specific absolute paths (`/Users/<name>`, `/home/<name>`); use `~` or
  `$HOME`.
- Anything sensitive does not go in this repo; there is no git-crypt setup.
