---
name: nvim-drive
description: Start and drive a real Neovim instance (with the user's real config) over RPC, optionally rendered in a background Rex session for screen captures. Use to observe or test editor behaviour empirically - LSP features (diagnostics, hover, completion, code actions, rename), mappings, plugins, config changes - instead of reasoning about it.
---

# nvim-drive

`nvim-drive` (next to this file) starts one Neovim per name and drives it over its
RPC socket. `lib.lua` holds the helpers every Lua call receives.

```sh
ND=.claude/skills/nvim-drive/nvim-drive
export NVIM_DRIVE_NAME=<unique>           # see "Instances" below
$ND start --cwd DIR [-- NVIM_ARGS...]     # headless; prints the socket path
$ND start --ui --cwd DIR [-- ...]         # TUI in a background Rex session
$ND lua FILE | -e 'CODE' | -              # run Lua, print its return value as JSON
$ND keys '<Esc>gg'                        # type keys (nvim --remote-send syntax)
$ND screen [--ansi]                       # text of the --ui screen (--ansi: with escapes)
$ND status
$ND stop                                  # quit nvim, kill its Rex session
```

## Instances

- `NVIM_DRIVE_NAME` (default `main`) names an instance, and with it the socket
  (`$TMPDIR/nvim-drive/<name>.sock`) and the `--ui` Rex session
  (`nvim-drive-<name>`). **The socket is shared by every agent on the machine, in
  any repo.** `start` refuses a name that is running, and `stop` quits whatever
  answers on the socket, even another agent's instance. Set a unique name (for
  example `nd-$$` or the task name) and never `stop` a name you did not start.
- `NVIM_DRIVE_SIZE` (default `50x160`, `ROWSxCOLS`) sets the `--ui` terminal.
- Always `stop` when done. A leftover instance keeps its language servers running.

## Environment

- The instance loads the user's real config. Fugitive's `VimEnter` `:Gcd` moves the
  cwd to the git root of `--cwd`.
- `start` gives nvim the environment a shell in `DIR` would have: mise's tool
  `PATH` for `DIR`, and `DIR/.venv` as `VIRTUAL_ENV` if it exists. It never passes
  on the caller's virtualenv (Python servers would resolve the caller's
  site-packages) or the caller's `REX_SESSION` / `REX_BLOCK` (plugins would act on
  the caller's pane).

## The `--ui` Rex session

- `--ui` runs nvim directly (`--shell=none`) as the only block of a new Rex
  session. No client has to be attached, so nothing appears in the user's
  current session or tab. Rex sizes an unattached terminal 24x80, so `start`
  resizes the block to `NVIM_DRIVE_SIZE` with the block's `resize` method.
- `screen` is `rex capture` of that block. Its session and block IDs are kept in
  `$TMPDIR/nvim-drive/<name>.rex`.
- The user can watch: the session is listed in Rex.app and can be selected with
  `rex -C CLIENT do session.select session_id=...`. Their client then owns the
  size, and a resize from the script waits until they leave.
- Do not use `rex send` / `rex send-key` to type into it. `keys` goes through
  nvim's RPC, which does not depend on the terminal's modes or focus.

## Writing Lua calls

A file run by `lua` receives the helpers as `...` and returns any JSON-encodable
value. Errors come back as `{"error": "<traceback>"}`.

```lua
local D = ...
local t0 = vim.uv.hrtime()
D.open("src/pkg/mod.py")
local client, attach_ms = D.wait_client("ty")
local diag_ms = D.wait_diagnostics(10000, nil, t0) -- first publish since t0
D.at("def parse_duration", 1, 4)                 -- cursor on the name
local hover = D.request("textDocument/hover")      -- {client = {ms, result, error}}
return { attach_ms = attach_ms, diag_ms = diag_ms, hover = hover,
         diags = D.diagnostics(nil, "ty") }
```

Helpers (`lib.lua`): `open`, `wait_client`, `wait_diagnostics`, `diagnostics`
(optionally one client's), `at` (plain-text match, nth, column offset),
`request` (per-client results with round-trip ms; `params` may be a table or a
function that extends the position params), `capabilities`, `floats` (open
floating windows with their text), `exec` (captured `:command` output). State that
must survive between calls goes in `_G.nvim_drive`.

## Rules learned the hard way

- **Choose LSP servers before opening a file.** `-c` runs after the files on the
  command line are loaded, so their servers have already attached. Start with no
  file, switch servers in `-c`, then `D.open`:
  `$ND start --cwd DIR -- -c 'lua vim.lsp.enable("ty", false); vim.lsp.enable("zuban")'`
- **Trigger anything visual with `keys`, not from Lua.** A float opened inside an
  RPC call (for example `vim.lsp.buf.hover()`) never reaches the screen. Send `K`,
  wait, then `screen`. Use `D.floats()` for the float's text.
- **Use `D.request` for data.** It returns the raw LSP result per client, so ruff
  and the server under test are told apart. Mappings and pickers (fzf-lua) are for
  checking the user's actual experience.
- `D.wait_diagnostics` counts an empty publish as a publish. "No diagnostics" is
  only meaningful after it returns a number.
- Keep socket paths short: macOS limits Unix socket paths to 104 bytes. The script
  uses `$TMPDIR/nvim-drive/`. A long scratchpad path fails with "connection refused".
- Completion: send `keys` in insert mode (`ofoo`), wait about 1.5s, then read
  blink's menu with `D.floats()` (filetype `blink-cmp-menu`; items show their
  auto-import source, e.g. `OrderedDict (import collections)`). Accept with `<C-y>`
  in its **own** `keys` call, wait, then send `<Esc>`. Sending `<C-y><Esc>` in one
  batch leaves the window on blink's `blink-cmp-dot-repeat` scratch buffer.
- Read buffers by name (`vim.fn.bufnr(path)`) rather than `0` when keys have just
  run. A plugin may briefly have another buffer current.
