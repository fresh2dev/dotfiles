# Neovim config

A personal Neovim configuration for **Neovim 0.12+**. It uses the editor's
built-in `vim.pack` plugin manager, keeps one config file per plugin, loads everything
eagerly, and leans on Neovim's own defaults wherever they are good enough.
Formatting is delegated to whatever `treefmt` the project you are editing
configures, `fzf-lua` is the picker, and tpope-style mnemonics are kept where
they exist (`ys`/`ds`/`cs`, `[q`/`]q`, `[p`/`]p`).

<!-- TOC -->

## Table of Contents

- [Requirements](#requirements)
- [Install](#install)
- [Layout](#layout)
- [Things to know before you start](#things-to-know-before-you-start)
- [Keymap overview](#keymap-overview)
- [Core mappings (no plugin)](#core-mappings-no-plugin)
- [Plugins](#plugins)
  - [Appearance and UI](#appearance-and-ui)
  - [Editing](#editing)
  - [Motions and text objects](#motions-and-text-objects)
  - [Search and navigation](#search-and-navigation)
  - [Files, buffers, windows](#files-buffers-windows)
  - [Git](#git)
  - [LSP, completion, formatting, syntax](#lsp-completion-formatting-syntax)
  - [Integrations](#integrations)
  - [Filetype-specific](#filetype-specific)
  - [Libraries](#libraries)
- [User commands](#user-commands)
- [Extending the config](#extending-the-config)

<!-- /TOC -->

## Requirements

- **Neovim >= 0.12.** The config uses `vim.pack`, `'winborder'`, the
  `foldinner` fill character, and the `main` branch of nvim-treesitter.
- **A Nerd Font** in your terminal, for icons in the statusline, pickers and
  file explorer. On macOS the dotfiles' Brewfile installs several.
- **External tools**, called at use time (a missing binary fails when you use
  the feature, not at startup):

  | Tool | Used by |
  |---|---|
  | `git` | everything git-related |
  | `rg` (ripgrep) | `:Grep`, fzf-lua grep, todo-comments |
  | `fd` | fzf-lua file finding |
  | `bat` | fzf-lua previews |
  | `treefmt` | format on save for every filetype except Lua and TOML |
  | `stylua` >= 2.x | Lua formatting, run as an LSP server |
  | `tombi` | TOML language server and formatter |
  | `lazygit` | `<leader>lg` |
  | `delta` | diffs inside fzf-lua git pickers |
  | `zoxide` | `:Z`, `<leader>fz` |
  | `just` | just.nvim (`<leader>j`) |

- **Language servers on `$PATH`.** There is no Mason. The config enables:
  `basedpyright`, `ruff`, `gopls`, `rust-analyzer`, `typos-lsp`, `tombi`,
  `bash-language-server`, `lua-language-server`, and `stylua --lsp`.

On a machine set up from these dotfiles, mise installs Neovim, the tools and the
language servers from the dotfiles' global mise config
(`home/.config/mise/config.toml`). Add a new dependency there, not here.

## Install

This config is part of the [dotfiles](../../../README.md) repo, at
`home/.config/nvim/`. The dotfiles link the whole directory to `~/.config/nvim`
(an entry in the `[dotfiles]` table of mise's global config), so the dotfiles'
setup installs it along with everything else. Then:

```sh
nvim             # first start installs every plugin, then runs :TSUpdate
```

The first start is slow: `vim.pack` clones every plugin synchronously.
Subsequent starts are fast (`vim.loader` caches compiled Lua).

`~/.config/nvim` is a symlink into the dotfiles checkout, so edits here take
effect on the next start, and `vim.pack` writes `nvim-pack-lock.json` straight
into the checkout: plugin installs and updates show up in `git diff`.

To try the config next to an existing one, or without the rest of the dotfiles,
link this directory under another name and point `NVIM_APPNAME` at it:

```sh
ln -s /path/to/dotfiles/home/.config/nvim ~/.config/nvim-dev
NVIM_APPNAME=nvim-dev nvim
```

Maintenance:

| Task | Command |
|---|---|
| Update plugins | `just -g update-neovim-plugins` (the dotfiles' global justfile): `vim.pack.update()` headlessly; revisions are pinned in `nvim-pack-lock.json` |
| Format Lua | `just format` from the dotfiles root: treefmt runs stylua, which picks up this directory's `.stylua.toml` |
| Check | The commands below |

```sh
cd ~/.config/nvim
nvim --headless -c 'qa'                                                # startup errors surface here
nvim --headless -c 'e README.md' -c 'e init.lua' -c 'qa'               # one buffer per ftplugin, so those plugins reach the lockfile
nvim --headless -c 'lua vim.pack.update(nil, {offline=true})' -c 'qa'  # plugin state
stylua --check .                                                       # formatting
```

## Layout

```text
init.lua            options, core keymaps, autocmds, :Grep, vim.pack build hooks
lua/util.lua        cross-file helpers (`cabbrev`, `keep_cursor`)
plugin/00-*.lua     must run first (colorscheme)
plugin/90-*.lua     infrastructure others depend on (LSP, treesitter)
plugin/99-*.lua     one plugin per file, order-independent
ftplugin/           filetype-scoped plugins (markdown, Lua)
nvim-pack-lock.json pinned plugin revisions
```

Every `plugin/NN-name.lua` calls `vim.pack.add` for the plugin it configures and
then configures it in place: `setup()`, keymaps, autocmds, user commands. There
is no central plugin list. See `CLAUDE.md` for the conventions in detail.

## Things to know before you start

These are the choices most likely to surprise someone coming from stock Vim or
another distribution.

- **`<Space>` is the leader** (and local leader). Press it and wait about 1.5
  seconds to get a which-key popup of everything under it. `<leader>tk` shows
  buffer-local keymaps, `<leader>tK` all of them, `<leader>fk` searches them.
- **The clipboard is the system clipboard.** `'clipboard'` is `unnamedplus`, so
  every yank and put goes through the OS clipboard. Over SSH (where no
  `xclip`/`wl-copy` can work) yanks are sent to your terminal emulator with
  OSC 52 instead, so they land on the *local* machine's clipboard and can be
  pasted anywhere with the terminal's paste (Cmd+V / Ctrl+Shift+V), including
  other SSH sessions, zellij panes and Neovim instances. Every yank is also
  recorded in a per-user file on the server (`stdpath("run")`, e.g.
  `/run/user/<uid>/clipboard.json`), so `p` pastes the latest yank of any
  Neovim instance on that host, across zellij panes included. Text copied on
  your own machine comes in with Cmd+V. Local sessions are unaffected. See the
  comment in `init.lua`.
- **Small deletes and changes do not clobber your yank** (cutlass). `x`, `X`,
  `c` and `C` (and visual `x` / `c`) leave the unnamed register alone: the
  deleted text goes to register `d` and the changed text to register `c`, so
  `"cp` recovers what you just changed. `d` and `D` are deliberately left stock
  in both normal and visual mode, so `dd`, `diw` and a visual `d` still cut.
- **`s` and `S` are vim-sneak**, not "substitute character". Type `s` plus two
  characters to jump forward, `S` to jump backward, `;`/`,` to repeat. `f`/`t`
  are sneak-enhanced too. Visual `s` extends the selection with a sneak jump;
  visual `S` is mini.surround. Use `cl` for the old `s`.
- **`<leader>p` is "replace with register"** (mini.operators): `<leader>piw`
  replaces the word under the cursor with what you last yanked, without
  touching the register. `<leader>pp` does the current line.
- **`cx` is exchange**: `cxiw` on one word, `cxiw` on another, and they swap.
  `cxx` exchanges lines; in visual mode the key is `X`. `gm` multiplies
  (duplicates).
- **`gs` / `gS` go to a symbol**: fuzzy-pick an LSP symbol in the current
  buffer or across the workspace (fzf-lua). mini.operators' sort operator,
  which defaults to `gs`, is disabled to make room.
- **Yanking keeps the cursor and the scroll position where they were**
  (sticky yank, so `ygg` no longer jumps to the top). `.` repeats without
  moving the cursor: it stays on the same text even when the change adds or
  removes lines above it. The exception is repeating the `[p` family, which
  replays the paste as a whole, just like the original.
- **`j`/`k` move by screen line** when there is no count, and by real line
  when there is one (`5j` still goes five lines down). `gj`/`gk` are freed up
  and jump to the next "edge" (indent change).
- **`n` always searches forward, `N` always backward**, no matter whether you
  searched with `/` or `?`. `<Esc>` in normal mode clears the search highlight.
- **`U` opens an undo tree** (Snacks) instead of the rarely useful "undo line".
- **`\` opens the file explorer** (mini.files) at the working directory and
  `|` opens it at the current file.
- **The working directory jumps to the git root on startup** (fugitive
  `:Gcd`). Fuzzy finding, `:Grep`, path completion and recent files are all
  relative to that.
- **Format on save is on** for every filetype: Lua through the stylua language
  server, TOML through tombi, everything else through the project's `treefmt`.
  `:ConformToggle` turns it off for the current buffer.
- **Diagnostics jump with `[d`/`]d`** and open a float when they land. `<C-s>`
  in normal mode shows signature help.
- **`<leader>x` is "I'm done with this"**: it closes the window if the buffer
  is visible elsewhere (or if every other buffer is already on screen in this
  tab), otherwise it deletes the buffer without disturbing the split layout.
- **No swap files, no backups; undo history is persistent** (`undofile` plus
  fundo). `'modeline'` is off, and Neovim's EditorConfig support is off because
  it conflicts with symlinked files.
- **Relative line numbers appear only in visual mode** (mini.basics).
- **`:grep`, `:lgrep`, `:g`, `:git`, `:z`, `:zi` are abbreviations** for
  `:Grep`, `:LGrep`, `:Git`, `:Z`, `:Zi`. They expand only when they are the
  whole command line.
- **In the terminal**, `<Esc><Esc>` or `<C-u>` leaves insert mode and `<C-w>`
  followed by a window key moves between windows without leaving first.
- Indentation defaults to **4 spaces** and is auto-detected per file
  (guess-indent). Line wrapping is off; `<leader>tw` toggles it.

## Keymap overview

Leader groups (which-key shows these):

| Prefix | Group | Where |
|---|---|---|
| `<leader>c` | Code (LSP, diff conflicts) | lspconfig, diffview |
| `<leader>f` | Find (fzf-lua) | fzf-lua, snacks |
| `<leader>g` | Git | fugitive, flog, diffview |
| `<leader>gh` | Git hunk | gitsigns |
| `<leader>j` | Just (run recipes) | just.nvim |
| `<leader>l` | Lazygit | snacks |
| `<leader>p` | Paste with replacement (operator) | mini.operators |
| `<leader>q` | Quit (windows, buffers, tabs) | mini.bufremove |
| `<leader>t` | Toggle | snacks, colorizer, which-key, toggler |
| `<leader>z` | Zoxide | zoxide |
| `<localleader>m` | Markdown (markdown buffers only) | markdown-plus |

Bracket pairs (unimpaired-style, `[` previous / `]` next):

| Keys | Moves between |
|---|---|
| `[a` `]a` `[A` `]A` | argument list |
| `[b` `]b` `[B` `]B` | buffers |
| `[q` `]q` `[Q` `]Q` | quickfix entries |
| `[l` `]l` `[L` `]L` | location list entries |
| `[c` `]c` | git hunks (or diff hunks in diff mode) |
| `[x` `]x` | merge conflict markers |
| `[d` `]d` | diagnostics |
| `[e` `]e` | move current line / selection up / down |
| `[<Space>` `]<Space>` | add blank line above / below |
| `[p` `]p` `[P` `]P` | paste linewise above / below |
| `>p` `<p` `=p` (and `>P` `<P` `=P`) | paste linewise and shift / reindent |
| `[;` `];` | start of current context / next context (dropbar) |
| `[T` | jump up to the treesitter context line |
| `[z` `]z` `zj` `zk` | fold boundaries (builtin) |
| `[[` `]]` | markdown headings (markdown-plus) |
| `[f` `]f` | markdown code fences (markdown-plus) |

Operators and their prefixes:

| Keys | Operator | Plugin |
|---|---|---|
| `ys` `ds` `cs` `yss` | surround add / delete / change / line | mini.surround |
| `S` (visual) | surround selection | mini.surround |
| `cx` `cxx` (`X` in visual) | exchange | mini.operators |
| `gm` `gmm` | multiply (duplicate) | mini.operators |
| `<leader>p` `<leader>pp` `<leader>P` | replace with register (motion / line / to end of line) | mini.operators |
| `gc` `gcc` | toggle comment | mini.comment |
| `ga` | align | vim-easy-align |
| `gz` `gZ` | zoom / zen mode | snacks |

## Core mappings (no plugin)

Everything in this section lives in `init.lua`.

| Key | Mode | Action |
|---|---|---|
| `j` `k` `<Down>` `<Up>` | n, x | Screen line without a count, real line with a count |
| `g/` | x | Start a search limited to the selection |
| `gp` | n | Select the last pasted text |
| `gco` `gcO` | n | Add a commented line below / above |
| `gb` | n | `:ls` then prompt for a buffer number |
| `p` | x | Paste over the selection without the replaced text taking over the register |
| `.` | n | Repeat without moving the cursor (it follows its text if lines are added or removed above; a [count] is passed through). Repeating the `[p` family replays the whole mapping |
| `y` | n, x | Yank without moving the cursor or scrolling (only the mapped keys; `:yank` behaves as usual) |
| `Y` | n | Yank to end of line without moving the cursor or scrolling |
| `<C-w>t` | n | Open the current buffer in a new tab (keeps the original window) |
| `<Esc>` | n | Clear search highlight |
| `<C-n>` `<C-p>` | c | Walk command history unless the wildmenu is open |
| `<Esc><Esc>` `<C-u>` | t | Leave terminal insert mode |
| `[e` `]e` | n, x | Move the current line or selected block up / down (takes a count; the selection stays active; `.` repeats in normal mode) |
| `[<Space>` `]<Space>` | n | Insert [count] blank lines above / below without moving the cursor (`.` repeats) |
| `[a` `[b` `[q` `[l` and `[p` families | n | See the overview table above; the other bracket pairs there belong to plugins or to Neovim |

Behaviour set by autocmds: files are re-read when changed outside Neovim, the
cursor returns to its last position when a file is reopened, `cursorline` is
shown only in the active window and not in insert mode, splits rebalance when
the terminal is resized, terminals start in insert mode, and yanked text
flashes briefly.

`:Grep {args}` and `:LGrep {args}` run ripgrep, fill the quickfix or location list, and open it.

## Plugins

For each plugin: what it is for, the mappings it ships with that still apply,
and the mappings this config adds or changes. "Default" means the plugin's own
default is in effect; "custom" means this config sets it.

### Appearance and UI

#### nightfox.nvim (`00-colorscheme.lua`)

Colorscheme. The `carbonfox` variant is active (`background = "dark"` and
`termguicolors` are set in `init.lua`). No mappings.

#### lualine.nvim (`99-lualine.lua`)

Statusline. A single global statusline (`laststatus = 3`) showing mode,
relative file path, filetype, progress and location. In markdown and asciidoc
buffers it also shows a word count and estimated reading time. No mappings.

#### tabby.nvim (`99-tabby.lua`)

Tabline. Deliberately minimal: it shows only tab numbers, styled from the
colorscheme's `TabLine` groups. No mappings.

#### dropbar.nvim (`99-dropbar.lua`)

Breadcrumbs in the winbar (path and symbol under the cursor). Clickable with
the mouse by default.

| Key | Action |
|---|---|
| `<leader>;` | Pick a breadcrumb component interactively (custom) |
| `[;` | Go to the start of the current context (custom) |
| `];` | Select the next context (custom) |

#### snacks.nvim (`99-snacks.lua`)

A collection of small features from folke. Enabled modules: `bigfile`
(disables heavy features for huge files), `indent` (indent guides), `input`
(nicer `vim.ui.input`), `lazygit`, `notifier` (notifications, 8 s timeout),
`scratch`, `statuscolumn`, `terminal`, `words` (highlights other references of
the symbol under the cursor), and `zen`. `picker` is disabled because fzf-lua
is the picker; only the `undo` and `projects` pickers, which fzf-lua lacks, are
called directly. Animations are off.

| Key | Action |
|---|---|
| `<leader>ts` | Toggle spell checking |
| `<leader>tw` | Toggle line wrap |
| `<leader>td` | Toggle diagnostics |
| `<leader>th` | Toggle inlay hints |
| `<leader>ti` | Toggle indent guides |
| `<leader>tz` / `gz` | Toggle zoom (current window full-size); also turns off line numbers in that window |
| `<leader>tZ` / `gZ` | Toggle zen mode; also turns off line numbers in that window |
| `<leader>fp` | Projects picker |
| `<leader>fu` / `U` | Undo tree |
| `<leader>f-` | Notification history |
| `<leader>lg` | Lazygit |
| `` <leader>` `` / `<C-/>` | Toggle a floating terminal |
| `<C-w>` (terminal mode) | Leave terminal mode and start a window command |

All custom. Scratch buffers are stored per working directory under
`~/.scratch`; there is no mapping, use `:lua Snacks.scratch()`.

#### which-key.nvim (`99-which-key.lua`)

Popup listing the keys that can follow a prefix. It appears after 1.5 seconds
of hesitation (immediately for which-key's own plugins: registers, marks and
the other presets). The leader groups in the overview table are registered
here, along with descriptions for the builtin fold jumps `[z` `]z` `zj` `zk`
and a `gr` group for Neovim's default LSP mappings.

| Key | Action |
|---|---|
| `<leader>tk` | Show buffer-local keymaps (custom) |
| `<leader>tK` | Show all keymaps (custom) |

#### colorful-winsep.nvim (`99-colorful-winsep.lua`)

Highlights the borders of the active window. Animation disabled. No mappings.

#### indent-blankline.nvim (`99-indent-blankline.lua`)

Indent guides that also appear on blank lines. Defaults. No mappings.

#### mini.indentscope (`99-mini.indentscope.lua`)

Draws a line along the current indent scope (no animation) and provides indent
text objects and motions, configured to behave like `vim-indent-object`.

| Key | Action |
|---|---|
| `ii` / `ai` | Inside / around the current indent scope (default) |
| `g<` / `g>` | Jump to the top / bottom of the scope (custom, default `[i`/`]i`) |

#### rainbow-delimiters.nvim (`99-rainbow-delimiters.lua`)

Colours matching brackets by nesting depth. Defaults. No mappings.

#### nvim-colorizer.lua (`99-colorizer.lua`)

Shows colour codes in their colour, in `css`, `javascript` and `html` buffers.

| Key | Action |
|---|---|
| `<leader>tc` | Toggle colorizer in the current buffer (custom) |

#### smartcolumn.nvim (`99-smartcolumn.lua`)

Shows a colour column only when a line actually exceeds it. Off for all
filetypes except Python (column 88). No mappings.

#### visual-whitespace.nvim (`99-visual-whitespace.lua`)

Shows spaces, tabs and line ends inside a visual selection. Defaults. No
mappings.

#### todo-comments.nvim (`99-todo-comments.lua`)

Highlights the plugin's usual keywords in comments (`TODO`, `FIX`/`FIXME`/`BUG`,
`HACK`, `WARN`, `PERF`, `NOTE`/`INFO`, `TEST`, only when followed by a colon);
`TODO` and `NOTE` get custom icons and colours. Signs are off. No mappings;
`:TodoQuickFix` and `:TodoLocList` list the keywords via ripgrep.

#### mini.map (`99-mini.map.lua`)

A minimap on the right edge showing search matches and git diff marks. It
opens automatically in normal file windows and closes when you enter a help,
quickfix or other special buffer. A `CursorHold` autocmd hides it while the
cursor is within 20 columns of the right edge and reopens it otherwise (this
reopening is not filtered by buffer type, so it can bring the map back in a
special buffer once the cursor rests). No mappings.

#### nvim-hlslens (`99-hlslens.lua`) and vim-asterisk

Shows "match 3 of 12" next to search matches and makes `*`/`#` not jump
immediately.

| Key | Mode | Action |
|---|---|---|
| `n` / `N` | n, x, o | Next / previous match, always forward / backward (custom) |
| `*` / `#` | n, x | Search word under cursor (or selection) forward / backward without moving (custom, via vim-asterisk) |
| `g*` / `g#` | n, x | Same, without word boundaries (custom) |

#### fidget.nvim (`90-lspconfig.lua`)

LSP progress messages in the bottom-right corner. Defaults. No mappings.

#### symbol-usage.nvim (`90-lspconfig.lua`)

Shows reference, definition and implementation counts above classes, methods
and functions. No mappings.

### Editing

#### cutlass.nvim (`99-cutlass.lua`)

Makes small delete and change operations stop overwriting the unnamed
register. `d` and `D` are excluded in normal, visual and select mode, so they
keep cutting into the unnamed register (and the clipboard). What remains:
`x`, `X` and visual `x` write to register `d`; `c`, `C` and visual `c` write
to register `c`; text typed over a select-mode selection goes to register `s`.
`"dp` pastes the last `x`-deletion, `"cp` the last change. (cutlass also maps
`s`/`S` in normal and visual mode and visual `X`, but vim-sneak, mini.surround
and mini.operators load later and take those keys back.)

#### mini.surround (`99-mini.surround.lua`)

Add, delete and change surrounding pairs, mapped like tpope's vim-surround.

| Key | Mode | Action |
|---|---|---|
| `ys{motion}{char}` | n | Add surrounding (custom, default `sa`) |
| `yss{char}` | n | Surround the whole line (custom) |
| `S{char}` | x | Surround the selection (custom) |
| `ds{char}` | n | Delete surrounding (custom, default `sd`) |
| `cs{old}{new}` | n | Change surrounding (custom, default `sr`) |
| `c` as a `{char}` | | Markdown code fence (custom surrounding) |

Find / highlight / update mappings and the `n`/`l` (next / last) suffixes are
disabled. Only the surrounding that covers the cursor is considered
(`search_method = "cover"`), searched within 25 lines.

#### mini.operators (`99-mini.operators.lua`)

Text-transforming operators. Each has a `{prefix}{prefix}` form for the current
line.

| Key | Action |
|---|---|
| `cx{motion}` / `cxx` | Exchange two regions: apply once on each (custom, default `gx`) |
| `X` (visual) | Exchange the selection (custom). Not `cx`: cutlass maps visual `c`, and a visual `cx` would make `c` wait for `timeoutlen`. This shadows cutlass's visual `X` (linewise delete); use `d` or `D` |
| `gm{motion}` / `gmm` | Multiply (duplicate) text (default) |
| `<leader>p{motion}` / `<leader>pp` | Replace with the register contents (custom, default `gr`) |
| `<leader>P` | Replace to the end of the line, like `D`/`C` (custom, `<leader>p$`) |

The evaluate operator (`g=`) is disabled, and the sort operator (`gs`) is
disabled because `gs`/`gS` are the fzf-lua symbol pickers.
Exchanged and replaced text is reindented linewise.

#### mini.comment (`99-mini.comment.lua`) and nvim-ts-context-commentstring

Comment toggling with a comment string that follows the treesitter context
(HTML inside markdown, JSX, and so on).

| Key | Mode | Action |
|---|---|---|
| `gc{motion}` | n | Toggle comment (default) |
| `gcc` | n | Toggle comment on the line (default) |
| `gc` | x | Toggle comment on the selection (default) |
| `gc` | o | Comment block text object, e.g. `dgc` (default) |
| `gco` `gcO` | n | See core mappings |

#### nvim-autopairs (`99-autopairs.lua`)

Inserts the closing bracket or quote when you type the opening one. Defaults.
Note that blink's own auto-brackets are disabled so only autopairs does this.

#### vim-easy-align (`99-easy-align.lua`)

Interactive alignment of tables, assignments, comments.

| Key | Mode | Action |
|---|---|---|
| `ga{motion}` | n | Start EasyAlign on a motion, e.g. `gaip=` (custom) |
| `ga` | x | Start EasyAlign on the selection, e.g. `vipga=` (custom) |

Inside the prompt: a delimiter character, `*` for all occurrences, `<C-x>` for
a regex, `<Enter>` to cycle alignment.

#### nvim-toggler (`99-toggler.lua`)

Toggles the word under the cursor to its inverse, using the plugin's default
set: `true`/`false`, `True`/`False`, `yes`/`no`, `on`/`off`, `left`/`right`,
`up`/`down`, `enable`/`disable`, `==`/`!=`.

| Key | Mode | Action |
|---|---|---|
| `<leader>ta` | n, v | Toggle alternative (custom, default `<leader>i` removed) |

#### guess-indent.nvim (`99-guess-indent.lua`)

Detects the indentation of each file and sets `shiftwidth`/`expandtab` to
match. No mappings.

#### mini.basics (`99-mini.basics.lua`)

Only three pieces are enabled: `<C-hjkl>` window navigation and `<C-Arrow>`
window resizing, relative line numbers in linewise/blockwise visual mode, and
bold window borders.

| Key | Action |
|---|---|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Focus the window in that direction (zellij.vim re-maps these; at the edge of Neovim the focus moves to the Zellij pane or tab) |
| `<C-Left>` `<C-Right>` | Decrease / increase window width (takes a count) |
| `<C-Down>` `<C-Up>` | Decrease / increase window height (takes a count) |

#### vim-repeat (`99-repeat.lua`)

Makes `.` repeat plugin mappings (used by the `[p`/`]p` family and vim-sneak).

#### vim-sensible (`99-sensible.lua`)

tpope's sensible defaults. Almost all of them are already Neovim defaults; it
is kept for the few that are not.

### Motions and text objects

#### vim-sneak (`99-sneak.lua`)

Two-character jumps.

| Key | Mode | Action |
|---|---|---|
| `s{c}{c}` | n, x | Jump forward to the two characters (custom mapping of the default behaviour) |
| `S{c}{c}` | n | Jump backward |
| `f` `F` `t` `T` | n, x, o | One-character find / till, sneak-enhanced (repeatable across lines) |
| `;` `,` | n, x | Repeat the last sneak / find forward / backward |

`S` is normal-mode only on purpose, because visual `S` belongs to
mini.surround. Neither key is mapped in operator-pending mode, so `ds`/`cs`
and `ys` are never mistaken for an operator plus sneak motion.

#### vim-edgemotion (`99-edgemotion.lua`)

| Key | Mode | Action |
|---|---|---|
| `gj` | n, x, o | Jump down to the next edge (indent change or blank-line boundary) |
| `gk` | n, x, o | Jump up to the previous edge |

#### mini.ai (`99-mini.ai.lua`) with mini.extra

Better `a`/`i` text objects, with treesitter support. Search radius is 500
lines. `an`/`in`/`al`/`il` (next / last variants) are disabled.

| Key | Action |
|---|---|
| `a(` `i(` and every bracket / quote | Around / inside the pair (default) |
| `ab` `ib` | Any bracket (default) |
| `aq` `iq` | Any quote (default) |
| `af` `if` | Function **call** (default) |
| `aa` `ia` | Function argument (default) |
| `at` `it` | HTML/XML tag (default) |
| `a?` `i?` | Prompted pair (default) |
| `aF` `iF` | Function **definition**, via treesitter (custom) |
| `ae` `ie` | Entire buffer (custom, from mini.extra) |
| `g[` `g]` | Move to the left / right edge of the `a` text object (default) |

#### nvim-various-textobjs (`99-various-textobjs.lua`)

Default mappings are disabled; only one text object is mapped.

| Key | Mode | Action |
|---|---|---|
| `av` / `iv` | o, x | Around / inside a subword (camelCase or snake_case part) |

#### vim-matchup (`99-matchup.lua`)

Extends `%` to language keywords (`if`/`end`, `<div>`/`</div>`), with the
matching pair highlighted and shown in a popup when off-screen.

| Key | Mode | Action |
|---|---|---|
| `%` | n, x, o | Jump to the matching pair (default). `{count}%` jumps to the count-th pair instead of a percentage of the file (custom, `matchup_motion_override_Npercent = 100`) |
| `g%` | n, x, o | Jump backward through the pair (default) |
| `[%` `]%` | n, x, o | Previous / next outer open / close (default) |
| `z%` | n, x, o | Jump inside the nearest block (default) |
| `a%` `i%` | o, x | Around / inside the matching pair (default) |

#### nvim-treesitter-context (`99-treesitter-context.lua`)

Pins the enclosing function or block signature to the top of the window (one
line, cursor mode).

| Key | Action |
|---|---|
| `[T` | Jump to the context line; with a count, that many levels up (custom) |

#### nvim-ufo (`99-ufo.lua`) with promise-async

Folding driven by treesitter, with indent as fallback. Files open fully
unfolded; a one-character fold column with custom fold glyphs is always shown
(the fold options live in this file, not `init.lua`).

| Key | Action |
|---|---|
| `zR` / `zM` | Open / close all folds (custom, ufo-aware) |
| `zr` | Open all folds except configured kinds (custom, ufo-aware; no kinds are configured, so in practice this equals `zR`) |
| `zm` | Close folds by level (custom, ufo-aware) |
| `zK` | Peek the folded lines under the cursor, or LSP hover if not on a fold (custom) |
| `za` `zo` `zc` `zj` `zk` `[z` `]z` | Builtin fold commands still work |

### Search and navigation

#### fzf-lua (`99-fzf.lua`)

The picker for files, grep, buffers, LSP symbols, git objects and more. Also
provides `vim.ui.select`. Previews use `bat`, laid out below the list. Grep
includes hidden files and follows symlinks.

| Key | Mode | Action |
|---|---|---|
| `<leader>F` | n | Menu of every fzf-lua picker |
| `<leader>ff` | n | Files |
| `<leader>fr` | n | Recent files (current directory only) |
| `<leader>fb` | n | Buffers, most recent first |
| `<leader>ft` | n | Tabs |
| `<leader>f"` | n | Registers |
| `<leader>fs` | n | Live grep |
| `<leader>fs` | x | Grep the selection |
| `<leader>fS` | n | Resume the last live grep |
| `<leader>fl` | n | Lines in the current buffer |
| `<leader>fq` | n | Grep within the quickfix list |
| `<leader>fa` | n | Argument list |
| `<leader>fj` / `<leader>f<C-o>` | n | Jump list |
| `gs` | n | Document symbols |
| `gS` | n | Workspace symbols (live) |
| `<leader>fd` | n | Document diagnostics |
| `<leader>fD` | n | Workspace diagnostics |
| `<leader>fg` | n | Git commits touching this buffer |
| `<leader>fc` | n | Commands |
| `<leader>fC` | n | Command history |
| `<leader>fh` | n | Help tags |
| `<leader>fk` | n | Keymaps |
| `<leader>fz` | n | Zoxide directories |

Inside a picker (custom action and keymap tables; both replace fzf-lua's
defaults wholesale, so binds not listed here, such as `<M-a>` select-all, are
absent, while fzf's own keys still work):

| Key | Action |
|---|---|
| `<Enter>` | Open (or send all to quickfix when multiple are selected) |
| `<C-o>` / `<C-v>` / `<C-t>` | Open in split / vsplit / tab (pickers that produce files) |
| `<C-g>` | Toggle `.gitignore` filtering |
| `<C-/>` (grep) | Switch between grep and live grep |
| `<F1>` / `<F2>` / `<F3>` / `<F4>` | Help, fullscreen, preview wrap, preview toggle |
| `<F5>` … `<F9>` | Rotate the preview, treesitter context (builtin previewer only; the default previewer is `bat`) |
| `<S-Down>` `<S-Up>` | Half a page down / up in the result list (custom; fzf-lua's default scrolls the preview) |
| `<Tab>` | Select multiple items (default) |

#### zoxide.vim (`99-zoxide.lua`)

Jump to frecent directories from inside Neovim.

| Key / command | Action |
|---|---|
| `:Z {query}` (`:z`) | `cd` to the best zoxide match |
| `:Zi` (`:zi`) / `<leader>zi` | Interactive pick with `vim.ui.select` (fzf-lua) |
| `:Lz` `:Tz` `:Lzi` `:Tzi` | Same, but `lcd` / `tcd` (no abbreviations) |

### Files, buffers, windows

#### mini.files (`99-mini.files.lua`)

Column-style file explorer with a preview pane that edits the filesystem like
a buffer: rename by editing a line, create by adding one, delete by deleting
one, then synchronise. Also replaces netrw for directory arguments.

| Key | Action |
|---|---|
| `\` | Open at the working directory, or close if open (custom) |
| `\|` | Open at the current file with the working-directory branch expanded, or close if open (custom) |

Inside the explorer (custom set, overrides the defaults shown in parentheses):

| Key | Action |
|---|---|
| `L` | Go into the directory / open file (default `l`) |
| `<CR>` | Go in; on a file, open it and close the explorer (default `L`) |
| `<BS>` | Go out to the parent (default `h`; the default `H` "go out plus" is unmapped) |
| `<C-o>` / `<C-v>` | Open the file in a horizontal / vertical split (custom) |
| `<leader>w` | Synchronise (apply) changes (default `=`) |
| `<F5>` | Reset (default `<BS>`) |
| `@` | Reveal the working directory |
| `M` / `'` | Set / go to a mark |
| `<` / `>` | Trim columns on the left / right |
| `g?` | Help |
| `q` | Close |

Deletion is permanent (no trash).

#### mini.bufremove (`99-mini.bufremove.lua`)

Delete buffers without closing their windows, plus the quit family built on
top of it. The bulk deletes (`:QuitHidden`, `:QuitOther`, `:QuitAll`) only
touch regular listed buffers, so hidden terminals and plugin buffers survive,
and modified buffers are skipped and reported unless the command gets a `!`.
`:QuitGit` is the opposite: it targets exactly the fugitive, flog and git
buffers and closes their windows.

| Key | Action |
|---|---|
| `<leader>w` / `<leader>W` | Write / write all |
| `<leader>x` / `<leader>qq` | Quit smart: close a floating window outright; otherwise close the window if the buffer is shown in another window or if every other buffer is already visible in this tab, else delete the buffer |
| `<leader>qe` / `<leader>qE` | Delete the buffer, keep the window (`:Bdelete` / `:Bdelete!`) |
| `<leader>qs` / `<leader>qS` | Close the window / keep only this window |
| `<leader>qt` | Close the tab |
| `<leader>qu` | Edit the alternate buffer |
| `<leader>qo` | Delete hidden buffers (`:QuitHidden`); the alternate buffer counts as hidden, so `<leader>qu` stops working right after |
| `<leader>qO` | Close other tabs and windows, then delete hidden buffers (`:QuitOther`) |
| `<leader>qa` / `<leader>qA` | Delete all buffers (`:QuitAll` / `:QuitAll!`) |
| `<leader>qg` | Delete git buffers and close their windows (`:QuitGit`) |

#### vim-eunuch (`99-eunuch.lua`)

Filesystem commands: `:Remove`/`:Delete`, `:Unlink`, `:Move`, `:Rename`,
`:Copy`, `:Duplicate`, `:Chmod`, `:Mkdir`, `:SudoWrite`, `:SudoEdit`, `:Wall`,
`:Cfind`, `:Lfind` and the rest of vim-eunuch's set. All of the plugin's own
mappings (`g:eunuch_no_maps`) are disabled.

#### nvim-fundo (`99-fundo.lua`) with promise-async

Makes persistent undo reliable across external changes to a file (it archives
undo files, capped at 512 MB). No mappings.

#### mini.cmdline (`99-mini.cmdline.lua`)

Only the "autopeek" feature is enabled: while typing a range on the command
line (`:42`, `:'<,'>`), a floating window shows the target lines with six lines
of context. Autocomplete and autocorrect are off. No mappings.

### Git

#### vim-fugitive (`99-fugitive.lua`) with vim-flog

Git inside Neovim. `:Git` (abbreviated `:g` / `:git`) runs any git command;
`:Git` alone opens the status buffer. vim-flog draws the commit graph. On
startup the working directory becomes the repository root.

| Key | Action |
|---|---|
| `<leader>gg` | Status buffer with the commit graph in a vertical split (then presses `i` to expand the first diff) |
| `<leader>gt` | Same, in a new tab |
| `<leader>go` | Same, as the only window |
| `<leader>gO` | Same, after deleting all buffers |
| `<leader>gb` | Blame (`:Git blame -s`) |
| `<leader>gl` / `<leader>gL` | Log graph for the current branch / all branches |
| `<leader>gr` | File revisions in the quickfix list (`:1,$GcLog!`); in visual mode, for the selection |
| `<leader>ge` | `:Gedit` (back to the working-tree version) |
| `<leader>gw` / `<leader>gW` | `:Gwrite` / `:Gwrite!` (stage, or overwrite) |
| `<leader>gp` / `<leader>gP` | Push / force push |

Inside fugitive buffers (custom additions on top of fugitive's defaults):

| Key | Buffer | Action |
|---|---|---|
| `q` | status, blame, graph | Close |
| `q` | git output | Close |
| `<CR>` | blame | Open the commit in a split |
| `O` | status | Open in a vertical split (default opens a tab) |
| `dt` | status | Diff the file under the cursor in a new tab |

Useful fugitive defaults in the status buffer: `s` / `u` stage / unstage, `-`
toggle, `=` inline diff, `cc` commit, `ca` amend, `dv` vertical diff, `X`
discard, `g?` help. In the flog graph: `<CR>` opens the commit, `a` toggles
all branches, `u` refreshes, `y<C-g>` yanks the hash, `gq` quits, `g?` help.

#### gitsigns.nvim (`99-gitsigns.lua`)

Change marks in the sign column and line numbers, hunk navigation and staging.

| Key | Mode | Action |
|---|---|---|
| `]c` / `[c` | n | Next / previous hunk with a preview (falls back to diff-mode `]c` in diffs) |
| `<leader>ghs` | n, x | Stage the hunk / selection |
| `<leader>ghr` | n, x | Reset the hunk / selection |
| `<leader>ghu` | n | Undo stage hunk |
| `<leader>ghp` | n | Preview the hunk |

All custom; gitsigns ships no mappings.

#### diffview.nvim (`99-diffview.lua`)

Side-by-side diffs for the working tree, revisions and file history, plus a
merge tool (`diff4_mixed` layout). The file panel is a flat list 25 columns
wide and is closed every time a view opens; `<C-\>` brings it back. This
config disables the plugin's default keymaps and declares its own full set;
the ones that differ from the defaults are marked.

| Key | Action |
|---|---|
| `<leader>gd` | `:DiffviewOpen` (working tree against index) |
| `<leader>gR` | `:DiffviewFileHistory %` (history of the current file) |

In the diff view and the panels (the staging, restore, log and refresh keys
exist only in the file panel; `X` and `L` also in the history panel):

| Key | Action |
|---|---|
| `]q` / `[q` (also `]a` / `[a` in the file panel) | Next / previous file (custom; default `<Tab>` / `<S-Tab>`) |
| `<C-\>` | Toggle the file panel (custom; default `<leader>b`) |
| `gf` | Open the file in a new tab (custom; default opens in place) |
| `[c` / `]c` | Previous / next conflict (custom; default `[x` / `]x`) |
| `<leader>co` `ct` `cb` `ca` | Choose ours / theirs / base / all for the conflict |
| `<leader>cO` `cT` `cB` `cA` | Same, for the whole file |
| `dx` / `dX` | Delete the conflict region / all conflict regions |
| `2do` / `3do` (`1do` in 4-way) | Take the hunk from ours / theirs (base) |
| `-` | Stage / unstage the entry |
| `X` | Restore the entry |
| `L` | Commit log |
| `<F5>` | Refresh (custom; default `R`) |
| `dt` (history panel) | Open the entry in a diffview |
| `y` (history panel) | Copy the commit hash |
| `g!` (history panel) | Options |
| `j`/`k`, `<CR>`/`o`/`l`, `h`, `zo`/`zc`/`za`/`zR`/`zM`, `<C-b>`/`<C-f>` | Move, open, collapse, fold, scroll |
| `g?` | Help for the current panel |

The default multi-select (`w`, `C`, `H`), staging (`s`, `S`, `U`), listing
style (`i`, `f`) and layout-cycling (`g<C-x>`) keys are intentionally not
bound.

#### conflict-marker.vim (`99-conflict-marker.lua`)

Highlights merge conflict markers. Its default mappings are disabled.

| Key | Action |
|---|---|
| `]x` / `[x` | Next / previous conflict (custom) |

`:ConflictMarkerOurselves`, `:ConflictMarkerThemselves`, `:ConflictMarkerBoth`
and `:ConflictMarkerNone` resolve the conflict under the cursor.

#### lazygit (snacks)

`<leader>lg` opens lazygit in a floating terminal; see snacks above.

### LSP, completion, formatting, syntax

#### nvim-lspconfig (`90-lspconfig.lua`)

Provides the server definitions; Neovim's own `vim.lsp.config` / `vim.lsp.enable`
start them. Servers must already be installed. Neovim's default LSP mappings
(`K` hover, `grn` rename, `gra` code action, `grr` references, `gri`
implementation, `grt` type definition, `gO` document symbols, insert-mode
`<C-s>` signature help) apply; the config routes the list-producing ones
through fzf-lua and adds `<leader>c` aliases. All are buffer-local and appear
in which-key with an `LSP:` prefix.

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Definitions (fzf-lua) |
| `gD` | n | Declaration |
| `grr` | n | References (fzf-lua) |
| `gri` / `gI` | n | Implementations (fzf-lua) |
| `gO` | n | Document symbols (fzf-lua); `gs` from `99-fzf.lua` is the same picker, `gS` the workspace one |
| `<C-s>` | n | Signature help |
| `<leader>cr` | n | Rename |
| `<leader>ca` | n, x | Code action |
| `<leader>cc` / `<leader>cC` | n | Run / refresh code lens |
| `<leader>cq` | n | Buffer diagnostics to the location list |
| `[d` / `]d` | n | Previous / next diagnostic, opening a float (unless `virtual_lines` is on; it is off) |
| `K` `grn` `gra` | n | Neovim defaults (hover, rename, code action) |

Symbol references under the cursor are highlighted after a short pause.
Diagnostics show as virtual text, sorted by severity, underlined from warning
level up.

Server notes: `basedpyright` runs in basic type-checking mode with several
noisy reports silenced; `ruff` has organise-imports off (basedpyright's is off
too); `gopls` enables staticcheck and gofumpt; `rust_analyzer` uses its
defaults; `typos_lsp` only attaches to markdown and text; `bashls` also covers
zsh; `stylua` is registered as a server (`stylua --lsp`) and is what formats
Lua, so `lua_ls` has formatting disabled; `tombi` serves TOML and formats it on
save.

#### blink.cmp (`99-blink.cmp.lua`)

Completion. Sources: LSP, file paths (relative to the working directory),
buffer words, and lazydev in Lua buffers. Nothing is preselected; the
documentation window appears after half a second; auto-brackets are off
(autopairs handles them); signature help shows while typing arguments.
Disabled in mini.files, Snacks picker prompts and fugitive buffers.

Insert mode (`default` preset plus custom `<Tab>` / `<CR>`):

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` or `<Down>` / `<Up>` | Next / previous item |
| `<CR>` | Accept the selected item (custom) |
| `<Tab>` | Accept if an item is selected, else jump forward in a snippet (custom) |
| `<S-Tab>` | Snippet backward |
| `<C-y>` | Select and accept |
| `<C-e>` | Cancel |
| `<C-Space>` | Show the menu / toggle documentation |
| `<C-b>` / `<C-f>` | Scroll documentation |
| `<C-k>` | Toggle signature help |

Command line (`cmdline` preset plus custom keys): the menu does not pop up on
its own, but ghost text previews the first match.

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Show and cycle completions |
| `<Down>` / `<Up>` | Next / previous (custom) |
| `<Left>` / `<Right>` | Move the cursor as usual (custom, no completion) |

`/` and `?` complete from buffer words; `:` completes commands.

#### conform.nvim (`99-conform.lua`)

Format on save. Every filetype runs the project's `treefmt` (found from
`.git`, `treefmt.toml` or `.treefmt.toml`, falling back to running it anyway),
except the filetypes listed in `lsp_formatted` at the top of the file, which
are formatted by their language server (currently Lua via `stylua --lsp` and
TOML via `tombi lsp`).
There is a 1 second timeout.

| Command | Action |
|---|---|
| `:ConformDisable` / `:ConformEnable` / `:ConformToggle` | Format on save for the current buffer |
| `:ConformInfo` | Show what would format this buffer (default) |

#### nvim-treesitter (`90-treesitter.lua`)

Syntax highlighting and indentation from treesitter parsers, using the
plugin's `main` branch API. A base set of parsers is installed at first start
(bash, c, css, go, html, json, lua, markdown, python, sql, typescript, yaml,
git filetypes and more); any other parser, `rust` included, is installed
automatically the first time its filetype is opened. `gitcommit` is left out
of the base set because its parser is very slow to compile, but it is not
excluded: the first commit buffer you open still triggers the build. Folds come
from nvim-ufo, not treesitter. No mappings. `:TSUpdate` runs automatically
after plugin updates.

#### lazydev.nvim (`ftplugin/lua_lazydev.lua`)

Loaded for Lua buffers only. Teaches `lua_ls` about the Neovim runtime and
`vim.uv` types lazily, so editing this config gets completions without a slow
workspace scan. Also feeds blink's `lazydev` source.

### Integrations

#### zellij.vim (`99-zellij.lua`)

Seamless `<C-hjkl>` navigation between Neovim windows and Zellij panes; when
there is no window in that direction the focus moves to the Zellij pane (or
tab, with the `move_focus_or_tab` setting on). Outside Zellij it falls back to
plain window navigation. Commands: `:ZellijNewPane`, `:ZellijNewPaneSplit`,
`:ZellijNewPaneVSplit`, `:ZellijNewTab`, `:ZellijNavigate{Up,Down,Left,Right}`.
Pair it with zellij-autolock so Zellij keybindings do not intercept Neovim's.

#### just.nvim (`99-just.lua`)

Runs [`just`](https://github.com/casey/just) recipes from the cwd (the git
root, via fugitive) with output streamed to the quickfix list, which opens on
failure or for a recipe named `run`. Recipe arguments are prompted for, except
the plugin's keyword arguments (`FILEPATH`, `CWD`, `DATE`, …) which are filled
in automatically. The picker is fzf-lua through `vim.ui.select`; no Telescope.
Only one task runs at a time.

| Key | Action |
|---|---|
| `<leader>jj` | Pick a recipe and run it (custom) |

### Filetype-specific

#### Markdown (`ftplugin/markdown.lua`)

**markdown-plus.nvim** replaces vim-markdown-toc, markdown-toggle.nvim and the
old hand-written link helper. Its default keymaps are off (they collide with
the `<leader>t` and `<leader>l` groups and `]b`, since `<localleader>` is also
`<Space>`); everything is mapped buffer-locally under `<localleader>m`, which
which-key shows as a group in markdown buffers.

Editing keys that act only in context and otherwise hand the key back to blink,
autopairs or the native behaviour: `<CR>` continues a list, `<Tab>`/`<S-Tab>`
indent and outdent an item, `<BS>` removes an empty marker, `<A-CR>` continues
the item's content on a new line, `o`/`O` open a new item, `<A-h/j/k/l>` move
between table cells in insert mode. `<C-t>` keeps its
insert-mode indent and `gd` belongs to the LSP.

| Keys | Action |
|---|---|
| `<localleader>mb` `mi` `mS` `` m` `` `m=` `mu` `mF` | toggle bold, italic, strikethrough, inline code, highlight, underline; clear formatting (normal and visual) |
| `<localleader>me` (visual) | escape / unescape markdown punctuation |
| `<localleader>mx` | toggle checkbox (normal and visual) |
| `<localleader>ml{u,t,n,N,l,L,p,P,c}` | set list type: `-`, task, `1.`, `1)`, `a.`, `A.`, `a)`, `A)`, clear |
| `<localleader>mr` | renumber ordered lists |
| `<localleader>m1`…`m6` `m+` `m-` `ms` | set heading level, promote, demote, toggle ATX/setext |
| `[[` `]]` | previous / next heading |
| `<localleader>mTg` `mTu` `mTo` | generate / update the TOC between `<!-- TOC -->` fences (as in this README, H2 and H3); open a navigable TOC window (`:Toc`, `:Toch`, `:Toct`) |
| `<localleader>mk` | insert a link (normal) or turn the selection into one (visual) |
| `<localleader>me` (normal) `ma` `mp` `mR` `mI` | edit link under cursor, auto-link a bare URL, paste the clipboard URL as a link (fetches the page title over HTTP), convert to reference / inline style |
| `<localleader>mg` `mG` `mA` | insert image / selection to image, edit image, toggle link ⇄ image |
| `<localleader>mc` `mC` `[f` `]f` | insert or wrap a fenced code block, change its language, jump between fences |
| `<localleader>mq` `mQ{i,t,c,b}` | toggle blockquote; insert callout, cycle its type, blockquote ⇄ callout |
| `<localleader>mh` `mH` | insert a horizontal rule, cycle its style |
| `<localleader>mf{i,e,d,g,r,n,p,l}` | footnotes: insert, edit, delete, go to definition / reference, next, previous, list |
| `<localleader>mt…` | tables: `c` create, `f` format, `n` normalize, `t` transpose, `e` edit cell in a popup, `a` cell alignment, `i{r,R,c,C}` insert row/column, `d{r,c}` delete, `m{h,j,k,l}` move, `s{a,d}` sort, `y{r,c}` duplicate, `v{i,x}` CSV in/out, `w`/`W`/`b`/`x` wrap, unwrap, `<br>`, clear cell |

#### Lua

lazydev, see above. Lua is formatted by the stylua language server rather than
treefmt.

### Libraries

Installed because another plugin requires them; no user-facing behaviour:
**nvim-web-devicons** (icons for fzf-lua, lualine, mini.files, tabby),
**plenary.nvim** (todo-comments, just.nvim), **promise-async** (ufo, fundo),
**mini.extra** (mini.ai's `ae`/`ie`), **nvim-ts-context-commentstring**
(mini.comment).

## User commands

| Command | Defined in | Action |
|---|---|---|
| `:Grep` `:LGrep` | init.lua | ripgrep into the quickfix / location list |
| `:Bdelete[!] [buf]` `:Bwipeout[!] [buf]` | mini.bufremove | Delete / wipe a buffer by number or name, keeping windows |
| `:QuitSmart[!]` `:QuitHidden[!]` `:QuitOther[!]` `:QuitAll[!]` `:QuitGit[!]` | mini.bufremove | See the quit family above |
| `:ConformEnable` `:ConformDisable` `:ConformToggle` | conform | Format on save for this buffer |
| `:Git` `:Gedit` `:Gwrite` `:Gdiffsplit` `:GcLog` … | fugitive | Git |
| `:Flog` `:Flogsplit` | flog | Commit graph |
| `:DiffviewOpen` `:DiffviewFileHistory` `:DiffviewClose` | diffview | Diffs |
| `:Z` `:Zi` `:Lz` `:Tz` … | zoxide | Change directory |
| `:TodoQuickFix` `:TodoLocList` | todo-comments | List `TODO:` comments |
| `:Toc` `:Toch` `:Toct` | markdown-plus (markdown buffers) | Navigable table of contents in a split / tab |
| `:ColorizerToggle` | colorizer | Colour preview |
| `:Remove` `:Move` `:Rename` `:Chmod` `:Mkdir` `:SudoWrite` … | eunuch | Filesystem |
| `:ZellijNewPane` `:ZellijNewTab` … | zellij.vim | Zellij panes |
| `:Just[!] [recipe]` `:JustSelect` `:JustStop` `:JustCreateTemplate` | just.nvim | Run `just` recipes |
| `:TSUpdate` `:TSInstall` | treesitter | Parsers |
| `:ConflictMarker*` | conflict-marker | Resolve conflicts |

Command-line abbreviations: `grep`, `lgrep`, `g`, `git`, `z`, `zi`.

## Extending the config

- **Add a plugin**: create `plugin/99-<name>.lua` with a `vim.pack.add` call
  and the configuration. List every plugin the file needs, even if another
  file also lists it. Give every mapping a `desc`, and register any new
  `<leader>` prefix in `plugin/99-which-key.lua`.
- **Add a language server**: add an entry to the `servers` table in
  `plugin/90-lspconfig.lua` and install the binary.
- **Let an LSP format a filetype** instead of treefmt: add it to
  `lsp_formatted` in `plugin/99-conform.lua`.
- **Add a build step** after install or update: extend the `PackChanged`
  autocmd at the bottom of `init.lua`.
- **Defer a plugin to a filetype**: put it in `ftplugin/<ft>.lua` (or
  `ftplugin/<ft>_<name>.lua` when the filetype already has a file) behind a
  `vim.g.loaded_<...>_config` guard, as `ftplugin/markdown.lua` and
  `ftplugin/lua_lazydev.lua` do.
- Before committing, run the check commands under [Install](#install) and
  `just format` from the dotfiles root.

`CLAUDE.md` documents the conventions and the deliberate deviations in more
depth.
