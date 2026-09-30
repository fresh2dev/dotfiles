# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles linked into `$HOME` by mise's built-in dotfiles manager
([`mise dot`](https://mise.jdx.dev/dotfiles.html)). There is no build, no test suite, and no
application code. `home/` mirrors `$HOME`: `home/.config/zellij/config.kdl` is linked to
`~/.config/zellij/config.kdl`, and so on. macOS-only files live in `home/` too; their
entries restrict them to macOS.

`README.md` covers setup and day-to-day usage; read it before changing how linking works.

Linking happens in two layers, each with its own `[dotfiles]` table:

- **Bootstrap layer**: the root `mise.toml`. It only links `~/.dotfiles` → `home/`, the
  files of `home/.config/mise` into `~/.config/mise` (`symlink-each`), which makes the file
  layer reachable, and the root `justfile` to `~/.config/mise/justfile`. Its `[tools]` pins
  the tools the root `justfile` needs.
- **File layer**: the `[dotfiles]` table in `home/.config/mise/config.toml` (the global mise
  config). Its settings make `~/.dotfiles` the dotfiles root and `symlink` the default mode,
  so a plain entry is just its target:

```toml
"~/.zshrc" = {}
"~/.hushlogin" = { mode = "symlink", variants = [{ os = "macos" }] }
```

Keys are `~/…` targets. An entry can name a file or a whole directory, and can set `source`
to link a target to a different path under `home/`. macOS-only entries carry
`variants = [{ os = "macos" }]` plus an explicit `mode` (with only `variants`, mise
ignores the entry). There is no Linux-specific variant.

A bare `mise dot` inside the repo loads both layers and fails with "conflicting dotfile
declarations". Run the file layer from outside the repo (`cd ~ && mise dot …`) and the
bootstrap layer from the repo root with `MISE_CONFIG_DIR="$PWD" mise dot …`.

## Commands

The bootstrap layer links the root `justfile` to `~/.config/mise/justfile`, so
`bs <recipe>` runs it from anywhere, and `just <recipe>` works from the repo root. `bs` is
a shell alias for `bootstrap`, itself an alias for `just -f $MISE_CONFIG_DIR/justfile` (both
in mise's `[shell_alias]`). `bs` with no args opens a chooser.

| Command | Effect |
|---|---|
| `bs install [args…]` | Apply the bootstrap layer, then `mise bootstrap` (file layer, Homebrew packages, services, macOS settings, tools, hooks), then clone missing zsh plugins and install missing agent skills. Args reach only `mise bootstrap`, so `--dry-run` still applies the bootstrap layer and installs plugins and skills |
| `bs upgrade [args…]` | `prune`, then `mise self-update`, `mise upgrade --bump --interactive`, and `mise bootstrap packages upgrade`, then pull zsh plugins and update agent skills. Args reach every `mise` step except `self-update` (which has no `--dry-run`); plugins and skills update regardless |
| `bs prune [args…]` | `mise prune`, then remove undeclared Homebrew formulae and undeclared casks that mise installed |
| `bs format` (alias `fmt`) | `treefmt -C <repo>`, which picks up `.treefmt.toml`, then prek's `trailing-whitespace` and `end-of-file-fixer` hooks on all files (`.pre-commit-config.yaml`) |
| `bs dir` | Print `repo_dir`, the repo checkout the justfile resolves to, e.g. `cd "$(bs dir)"` |
| `bs edit`, `bs edit-mise`, `bs edit-mise-macos` | Open the justfile, `config.toml`, or `config.macos.toml` in `$EDITOR` |
| `cd ~ && mise dot <subcommand>` | The file layer (`apply`, `status`, `diff`, `add`, …) |
| `MISE_CONFIG_DIR="$PWD" mise dot <subcommand>` | The bootstrap layer, from the repo root |

The recipes pass arguments with `[positional-arguments]` and `"$@"`; keep it that way so
quoted arguments aren't re-split.

Run through `bs`, the justfile is read through a symlink, so `source_directory()` is
`~/.config/mise`, not the repo. Its `repo_dir` variable resolves the symlink with
`canonicalize()`; use it for any path into the repo.

The `mise_local` and `mise_global` variables expand to `mise` with `MISE_CONFIG_DIR` set
for that command only. `install` uses `mise_local` (`repo_dir`) for its bootstrap-layer
`mise dot apply`; that is what makes mise read `mise.toml` as global config (no `mise
trust` needed) and skip the global config. Every other `mise` call uses `mise_global`,
which runs from `~` (`mise -C`) with `MISE_CONFIG_DIR` set to `mise_config_dir`:
`$XDG_CONFIG_HOME/mise`, else `~/.config/mise`. It deliberately ignores an inherited
`$MISE_CONFIG_DIR`: Setup runs `just install` from a `MISE_CONFIG_DIR="$PWD" mise en`
shell, where honoring it would point every step at the bootstrap layer. Don't change that.

Recipes call mise-managed tools through `mise_exec` (`mise_global` + `exec --`), not bare,
so they work before the shell activates mise and install lazy tools on first use. Tools
not managed by mise, such as `git`, are called directly.

`mise dot add <path>`, run from outside the repo, moves the file into `home/`, adds a
`"~/<path>" = {}` entry to the global config (through the `~/.config/mise` symlink), and
links it. macOS-only `variants` are added by hand.

## Tool installation

**mise is the single source of truth for CLI tools.** `home/.config/mise/config.toml`
pins every version under `[tools]`, grouped by purpose, using registry names where they
exist and explicit backends (`cargo:`, `go:`, `pypi:`, `npm:`, `aqua:`) otherwise.
To add a tool, add a pinned entry there; do not add `cargo binstall` / `go install` /
`uv tool install` lines to a justfile.

The root `mise.toml` is the only other `[tools]` table. It pins just the tools the root
`justfile` needs, by major version, so a fresh checkout can install them before anything is
linked (see the README's Setup). Don't add other tools there. The global config pins the
same tools at exact versions so they stay available outside the repo; keep a prerequisite
in both places.

`.zshenv` sets `MISE_CONFIG_DIR="$HOME/.config/mise"` and `MISE_AUTO_ENV=true` (before
activating mise), which is how per-platform configs such as `config.macos.toml`
get loaded alongside the main config.

Most tools are marked `lazy = true` (requires mise >= 2026.9.0): a bare `mise install`
skips them and they install on first use through a bootstrap shim; `mise install
--include-lazy` installs everything. Tools without `lazy = true` are eager. Any lazy tool
that mise's registry has no `bins` metadata for, and every explicit-backend tool (`cargo:`,
`go:`, `pypi:`, `npm:`), needs a `lazy_bins = [...]` list of its command names or
`mise reshim` fails.

**Homebrew is managed by `mise bootstrap`**, not by a Brewfile. In
`home/.config/mise/config.macos.toml`, taps are `[bootstrap.brew.taps]` entries, and
formulae and casks are `"brew:<name>"` / `"brew-cask:<name>"` entries in
`[bootstrap.packages]`, at `"latest"`. To add one, add an entry there; `bs prune` removes
undeclared formulae and undeclared casks that mise installed. The same file holds the rest of the macOS-only
bootstrap config: Dock and Finder defaults, LaunchAgents
(`[bootstrap.macos.launchd.agents]`), user services (`[bootstrap.services]`), and a
`post-defaults` hook that restarts Dock and Finder. GUI apps not started from a terminal
get their environment from launchd, not the shell: the `mise-env` LaunchAgent runs
`launchctl setenv` for `PATH`, `XDG_CONFIG_HOME` and `XDG_DATA_DIRS` at login, for the
current user only. To expose another variable to GUI apps, add it there. Avoid
`launchctl config user path` (or managing its `user.plist`): it applies to every user on
the Mac. Cross-platform hooks (`[bootstrap.hooks.*]`) live in `config.toml`; its `post-tools` hook
updates neovim plugins.

The justfile only covers what `mise bootstrap` cannot: zsh plugins and agent skills, plus
wrappers around `mise` commands. Its conventions:

- Helpers are hidden with a leading `_`, named `_install-<thing>` / `_update-<thing>`, and
  run as dependencies of `install` and `upgrade`.
- Lists of things to install (plugin repos, skills) are `'''` string variables, one item
  per line, looped over in the recipe body. Don't turn them into long dependency lists
  continued with `\`: `just --fmt` joins those onto one line.
- Recipes don't depend on the working directory: `mise` calls go through `mise_global`
  (which `cd`s to `~`) or `mise_local`, and other paths come from `repo_dir`,
  `env('HOME')`, or env vars.

## Structure notes

- **Shell startup** is zsh only; there is no `.profile`, `.bash_profile`, or `.bashrc`.
  `.zshenv` does environment setup for every shell: it sets `MISE_CONFIG_DIR`, activates
  mise (its `[env]`, tools and `_.path`) in non-login shells, defines mise's aliases, and
  sources `~/.secrets.env` if present. Login shells activate mise in `.zprofile` instead
  (see PATH additions below); not `.zlogin`, which runs after `.zshrc`. `.zshrc` sets up interactive tools and plugins. Optional tools and plugins in `.zshrc` are guarded
  with `command -v` or a directory test; guard new ones the same way. Tools that are eager
  in mise are initialized unconditionally.
- **Global env vars** (`EDITOR`, `XDG_*`, tool config paths, fzf/zoxide options, …) are set
  in mise's `[env]` table (using `{{ env.HOME }}`), not in shell rc files. Shell aliases
  live in mise's `[shell_alias]` table.
- **PATH additions** (`~/.local/bin`, `/opt/homebrew/bin`, `$GOPATH/bin`) are mise's
  `_.path` in `[env]`, not shell exports; don't list dirs a mise tool already adds (the
  `rust` tool adds `$CARGO_HOME/bin`). `mise activate` puts them ahead of the inherited
  PATH, so `~/.local/bin`'s uutils coreutils shadow the BSD tools. Login shells run
  `/etc/zprofile` (macOS `path_helper`) after `.zshenv`, which moves the system dirs back
  in front, so login shells skip activation in `.zshenv` and activate in `.zprofile`. Use `mise activate`, not
  `mise env`: `mise env` neither reorders dirs already on PATH nor tracks what it added,
  so re-running it duplicates entries. Keep the `mise-env` LaunchAgent's PATH in
  `config.macos.toml` in the same order.
- **Zellij plugins** are referenced as `file:$ZELLIJ_CONFIG_DIR/plugins/<name>.wasm`
  (`ZELLIJ_CONFIG_DIR` is exported by mise's `[env]`). A bare relative `file:name.wasm`
  resolves against the cwd and `~/.local/share/zellij/plugins`, *not* the config dir. They
  are `github:` tools in the global mise config: `asset_pattern` selects the release's
  `.wasm`, and a per-tool `postinstall` symlinks it into `$ZELLIJ_CONFIG_DIR/plugins`.
- `home/.config/mise/*` and the root `justfile` are linked only by the bootstrap layer. Their
  file-layer entries are left commented out in `config.toml`; keep them that way, or both
  layers declare the same targets. In a throwaway `HOME`, `mise dot apply` warns that the
  linked global config is not trusted; linking still works.
- `.treefmt.toml` at the repo root is this repo's treefmt config, found because
  `format` runs treefmt with `-C <repo>`; it has no `[dotfiles]` entry. Its `just` formatter
  loops over files in `sh` because `just --fmt -f` takes one justfile, and it excludes
  `.agents/skills`. Keep both.
- `.pre-commit-config.yaml` configures [prek](https://prek.j178.dev) with `repo: builtin`
  hooks only (prek-only; upstream pre-commit can't run it). It excludes `home/.agents/`
  and includes `no-commit-to-branch`, so commits to `main` fail once the git hook is
  installed (`prek install`; nothing installs it automatically).
- Don't leave a shell file empty: shfmt writes a newline into it and prek's
  `end-of-file-fixer` truncates it again, so `bs format` changes it on every run. Give it
  a comment instead.
- **Neovim config** is `home/.config/nvim/`, linked as a whole directory, with its own
  `CLAUDE.md` and `README.md`; follow those when editing it.
- **Agent skills** in `home/.agents/skills/` are vendored from upstream by the `skills` CLI
  and tracked in `home/.agents/.skill-lock.json`. Never edit them: `bs upgrade`
  overwrites them.
- Hand-written scripts live in `home/.local/bin/`.

## Conventions

- Adding a file under `home/` also requires a `"~/<path>" = {}` entry in the `[dotfiles]`
  table of `home/.config/mise/config.toml`; without one it is never linked. Then run
  `cd ~ && mise dot apply ~/<path>` (or use `mise dot add` from outside the repo, which does
  all three steps). macOS-only entries add the `mode` and `variants` shown above.
- Never add dotfile entries to the root `mise.toml`; it holds only the bootstrap layer.
- Files stay in place under `home/` at their exact `$HOME`-relative path; renaming or
  moving a config file changes where it is linked, and its entry must change with it.
- No machine-specific absolute paths (`/Users/<name>`, `/home/<name>`), in `[dotfiles]` or
  anywhere else; use `~` or `$HOME`.
- Anything sensitive does not go in this repo; there is no git-crypt setup.
