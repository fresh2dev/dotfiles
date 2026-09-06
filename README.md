# dotfiles

Personal dotfiles, symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/)
and driven by [`just`](https://github.com/casey/just). CLI tools are installed by
[`mise`](https://mise.jdx.dev) from `home/.config/mise/config.toml`.

The `stow` actually pinned here (root `mise.toml`) is
[Stow-Python](https://github.com/isarandi/stow-python), a drop-in reimplementation of GNU
Stow; everything below applies to either.

## Setup

Prerequisites: `git` and `mise` (plus Homebrew on macOS for GUI apps). The root `mise.toml`
pins the tools the recipes themselves need (`just`, `stow`, `fzf`, `ripgrep`); `bat`
(picker preview) and `gum` (`adopt` prompts) come from `home/.config/mise/config.toml` once
it is linked and installed.

```sh
git clone https://github.com/fresh2dev/dotfiles ~/projects/github.com/fresh2dev/dotfiles
cd ~/projects/github.com/fresh2dev/dotfiles
mise install                     # just, stow, fzf, rg for the recipes below
just link                        # pick files (tab toggles, alt-a selects all) and symlink them into ~
just link home/.zshrc            # or name them directly
mise install                     # again, now reading the linked ~/.config/mise/config.toml
```

`alt-a` selects everything only because `FZF_DEFAULT_OPTS` in mise's `[env]` binds it; on a
fresh machine (before that config is linked and mise is activated) use `tab` to toggle files.

## Layout

| Path | Purpose |
|---|---|
| `home/` | Stow package mirroring `$HOME`; linked on every platform |
| `home-macos/` | macOS-only files (Brewfile, colima, mise's `config.macos-arm64.toml`); linked only on macOS |
| `home-arch/` | Arch-family files (mise's `config.linux.toml`); linked on Linux when `pacman` is on PATH |
| `home-debian/` | Debian-family files (mise's `config.linux.toml`); linked on Linux when `apt` is on PATH and `pacman` is not |
| `justfile` | link / unlink / relink (interactive pickers), clean, adopt recipes; bare `just` opens a chooser |
| `mise.toml` | pins the tools the recipes need (`just`, `stow`, `fzf`, `ripgrep`) |
| `.stowrc` | `--target=~ --no-folding`: individual files are linked, never directories; also ignores `README.md` |

On Linux with neither `pacman` nor `apt` on PATH, only `home/` is linked.

## Recipes

| Command | Effect |
|---|---|
| `just link [files] [stow flags]` | stow the named files (e.g. `home/.zshrc` from the repo root), or pick them with `rg --files \| fzf --multi` |
| `just unlink [files] [stow flags]` | same, `stow --delete` |
| `just relink [files] [stow flags]` | same, `stow --restow` |
| `just clean [depth]` | remove broken symlinks under `~`, `~/.config`, and `~/.local/bin`, and empty dirs under `~` and `~/.config` (default depth 1) |
| `just adopt [path]` | move a real file (or files picked under a directory) from `$HOME` into a chosen stow package, then link just those files |

## Linking a subset

`just link` lists every file in the packages for this OS and lets you pick with
`fzf --multi` (the highlighted file is previewed with `bat`); it then builds the allow-list
regex described below and runs stow once per package. Selecting everything (`alt-a`) skips
the regex and stows the packages whole. To skip the prompt, name the files instead:
`just link home/.zshrc home/.local/bin/rgv`. Paths are resolved relative to the cwd (so the
`home/.zshrc` form works from the repo root) or absolute, and must land on a file inside a
package that is active on this OS; anything else is rejected before stow runs. Flags that
take a value must use the `--flag=value` form so they are not mistaken for files.

After stow runs, each requested file is listed with its final state: `ok linked` /
`ok absent` when it matches what was asked for, otherwise `FAIL` with the state found
(`CONFLICT` means something else already sits at the target path). Stow itself prints
nothing when a file is already in the requested state, so this line is the confirmation
that "nothing happened" was correct. `-n` (`--simulate`) skips the report.
`just unlink` and `just relink` are the same picker with `--delete` and `--restow`. All
three are thin wrappers over the hidden `_stow-choices` recipe, which pipes the selection
into `_stow-picks` (the stow driver `adopt` also uses). Extra flags pass through to stow,
so `--adopt` and `-n` work. The one exception is `--target` / `-t`: the recipes refuse it
and point you at `$DOTFILES_TARGET` (next paragraph), so the picker, `clean`, and `adopt` can
never disagree about where home is.

Every recipe links into, cleans, and adopts from `$DOTFILES_TARGET`, which the `justfile`
defaults to `$HOME`. Export `DOTFILES_TARGET=~/.donald` (for example, or prefix a single run
with `DOTFILES_TARGET=~/.donald just link`) and the whole recipe set operates on that directory
instead; the recipes pass it to stow as `--target`, so `.stowrc`'s `--target=~` is only the
fallback for a bare `stow` command. It must be *exported*: a plain `DOTFILES_TARGET=...`
assignment in `.zshrc` is invisible to `just`, which then silently falls back to `$HOME`.
(mise's `[env]` re-exports `DOTFILES_TARGET`, defaulting to `$HOME`, so once that config is
active the variable is always set.)

For a hand-written subset, pass `--ignore` through `just link` and select everything in
the picker: stow accepts several `--ignore` flags, so yours applies on top of whatever the
picker builds. Run it as many times as you need — stow is idempotent. Add `-n` to simulate
first. The same flags work on a bare `stow` command, which reads `--target=~` from `.stowrc`
and, unlike the recipes, accepts an explicit `--target`.

```sh
# only ~/.zshrc
just link --ignore='^(?!\.zshrc$).*'          # then alt-a in the picker

# only ~/.donald/.config/zellij
stow --target ~/.donald --ignore='^(?!\.config(?:/zellij(?:/.*)?)?$).*' home
```

Two rules make those regexes look the way they do:

- **`--ignore` is anchored at the end**, not both ends — stow compiles it as
  `($regex)\z` ("ignore files *ending* in this regex"; Perl in GNU Stow, Python `re` in
  Stow-Python, and the patterns here work in both). An allow-list therefore
  needs a leading `^`, a negative lookahead naming what to keep, and a trailing `.*` to
  reach the end. Drop the `.*` and the pattern can only match the empty string, so nothing
  is ignored and everything gets linked.
- **Ignored directories are pruned**, so every parent of a kept file must be allowed too:
  keeping `.config/zellij/**` requires `.config` in the lookahead as well.

Excluding a few paths instead is much simpler, since the end anchor does the work:

```sh
stow --ignore='^\.config/(k9s|zed)$' home   # everything except k9s and zed
```

To remove one subset again, pass the same `--ignore` to `stow --delete` (or pick the same
files in `just unlink`); note that selecting everything in `just relink` restows
*everything*, widening the subset back out.

```sh
stow --delete --ignore='^(?!\.zshrc$).*' home
```

An alternative for whole directories is to re-root stow, treating a subdirectory as the
stow directory and its children as packages (`just link` can't do this, since the recipe
appends `home` as the package name):

```sh
stow -d home/.config -t ~/.donald/.config zellij zed
```

## Adopting files

Two ways to bring a real file that already exists in `$HOME` under version control.

### `just adopt`

Moves each file into a stow package of your choice at its `$DOTFILES_TARGET`-relative path,
then links only those files back into place (through the same stow driver the pickers use).
If the chosen package is not active on this OS (say `home-debian` on a Mac), the files are
moved but not linked, and a warning names the package.

```sh
just adopt ~/.config/foo/config.toml
just adopt ./config.toml   # relative paths work; the recipe is [no-cd]
just adopt ~/.config/foo   # a directory: pick one or more files under it with `rg --files | fzf --multi`
just adopt                 # no argument: same picker, rooted at the cwd (or ~/.config from inside this repo)
```

The argument must be a regular file or a directory; anything else (a missing path, a
socket, a fifo) fails. `rg --files` skips symlinks, so files that are already stowed do
not appear in the picker.

The run goes: pick the destination package via `gum choose` (every `home*/` directory in
the repo: `home`, `home-macos`, `home-arch`, `home-debian`), validate every path, list the
files, then confirm once via `gum confirm` before anything moves. One bad path aborts the
whole run. Validation resolves each path with `realpath` (so a symlink already pointing
into the repo is caught), then refuses anything inside this checkout or outside
`$DOTFILES_TARGET`, accepts only regular files (directories are rejected because `.stowrc`
sets `--no-folding`), and refuses to overwrite: if `<package>/<relative path>` already
exists in the repo, the run fails (use `stow --adopt` below to pull the `$HOME` version over
the repo's copy). The duplicate check is against the chosen package, so the same relative
path may exist in `home/` and an OS package.

Note that it derives the destination from `$DOTFILES_TARGET`: with the default, adopting
`~/.donald/.zshrc` lands it at `home/.donald/.zshrc`, not `home/.zshrc`. Run it as
`DOTFILES_TARGET=~/.donald just adopt ~/.donald/.zshrc` to get `home/.zshrc`.

### `stow --adopt`

`just link` aborts when a real file already sits where a symlink should go, and the state
report marks it `FAIL CONFLICT`:

```
WARNING! stowing home would cause conflicts:
  * cannot stow .../home/.zshrc over existing target .zshrc since neither a link
    nor a directory and --adopt not specified
All operations aborted.
  FAIL  CONFLICT /home/you/.zshrc
```

`--adopt` resolves that in place, and combines with the subset flags above:

```sh
DOTFILES_TARGET=~/.donald just link --adopt --ignore='^(?!\.zshrc$).*'   # then alt-a in the picker
```

**`--adopt` overwrites the repo's copy with the version found at the target**, then links
it back. The repo content is replaced, not merged and not preserved — so run `git diff`
straight afterwards to see what changed, and `git checkout -- <path>` to keep the repo's
version and discard what was adopted.
