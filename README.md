# dotfiles

Personal dotfiles, symlinked into `$HOME` by mise's built-in dotfiles manager
([`mise dot`](https://mise.jdx.dev/dotfiles.html)) and driven by
[`just`](https://github.com/casey/just). CLI tools are installed by
[`mise`](https://mise.jdx.dev) from `home/.config/mise/config.toml`.

## Setup

Prerequisites: `git` and `mise` (a version with `mise dot` variants, e.g. 2026.9.17), plus
Homebrew on macOS for GUI apps. The root `mise.toml` pins `just` for the recipes below.

```sh
git clone https://github.com/fresh2dev/dotfiles ~/projects/github.com/fresh2dev/dotfiles
cd ~/projects/github.com/fresh2dev/dotfiles
mise install      # just, for the recipes below
just link         # symlink every [dotfiles] entry into ~
mise install      # again, now reading the linked ~/.config/mise/config.toml
```

This repo used to be linked with stow, and those existing relative symlinks count as
`applied` when they already point at the right source, so migrating a live machine is just
`just link`. No `--force` or unlink step is needed.

## Layout

| Path | Purpose |
|---|---|
| `home/` | Files linked on every platform, each at its `$HOME`-relative path |
| `home-macos/` | macOS-only files (Brewfile, colima, mise's `config.macos-arm64.toml`, `.hushlogin`, a LaunchAgent) |
| `mise.toml` | pins `just`; its `[dotfiles]` table lists every linked file |
| `justfile` | `link`, `unlink`, `status`, `diff` and `adopt`; a bare `just` opens a chooser |

## The `[dotfiles]` table

The root `mise.toml` ends with a `[dotfiles]` table that has **one entry per file**. The key
is the target (`~/…`) and `source` is the repo-relative path. Every entry uses
`mode = "symlink"`, so mise creates an absolute symlink into this checkout:

```toml
[dotfiles]
"~/.zshrc" = { source = "home/.zshrc", mode = "symlink" }
"~/.config/zellij/config.kdl" = { source = "home/.config/zellij/config.kdl", mode = "symlink" }
```

Only files are linked, never whole directories, so a real directory in `$HOME` is never
replaced by a link into the repo. `README.md` files inside `home/` have no entry and are
not linked.

Entries for `home-macos/` files add an `os = "macos"` variant. mise applies them on macOS
and skips them on every other OS, so the same `mise.toml` is safe to apply anywhere:

```toml
"~/.hushlogin" = { source = "home-macos/.hushlogin", mode = "symlink", variants = [{ os = "macos" }] }
```

`[dotfiles]` stays the **last** table in `mise.toml`, because `just adopt` appends new
entries to the end of the file.

## Recipes

Every recipe exports `MISE_CONFIG_DIR` as the repo root and runs `mise dot`, which reads
the repo's `mise.toml`.

| Command | Effect |
|---|---|
| `just link [targets…]` | `mise dot apply`: link every entry, or only the named targets (e.g. `~/.zshrc`) |
| `just unlink [targets…]` | `mise dot unapply`: remove the links for every entry, or only the named targets |
| `just status` | `mise dot status`: show the state of every entry |
| `just diff [targets…]` | `mise dot diff`: show what `link` would change |
| `just adopt <paths…>` | move regular files from `$HOME` into `home/`, add their entries, and link them |

## Adding a file

### By hand

Put the file under `home/` at its `$HOME`-relative path, then add one entry to the end of
`mise.toml` and link just that target:

```toml
"~/.config/foo/config.toml" = { source = "home/.config/foo/config.toml", mode = "symlink" }
```

```sh
just link ~/.config/foo/config.toml
```

For a macOS-only file, put it under `home-macos/` and add `variants = [{ os = "macos" }]`
to the entry.

### `just adopt`

`adopt` brings real files that already exist in `$HOME` under version control:

```sh
just adopt ~/.config/foo/config.toml
just adopt ./config.toml ~/.config/bar/bar.yaml   # relative paths work; the recipe is [no-cd]
```

It validates **every** path before anything moves. A single bad path aborts the whole run
and names that path. A path is rejected if any of these hold:

- it is not a regular file (a directory, a symlink, or missing);
- it is outside `$HOME` or inside this repo;
- `home/<path>` already exists in the repo;
- `"~/<path>"` is already a key in `mise.toml`.

For each file, `adopt` moves it to `home/<path>` and appends
`"~/<path>" = { source = "home/<path>", mode = "symlink" }` to `mise.toml`. It then runs
`mise dot apply` for only the adopted targets. It always adopts into `home/`. Add
macOS-only files by hand.

`adopt` does not use `mise dot add`. That command writes absolute, machine-specific target
keys, and for a relative `--source` it writes a broken relative symlink. The entries in this
repo must stay portable, with `~/…` keys and repo-relative sources.
