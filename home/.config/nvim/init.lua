-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
--  See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Clipboard over SSH: OSC 52.
--
-- In an SSH session there is no X11/Wayland display, so Neovim finds no
-- clipboard tool (`:checkhealth vim.provider` warns) and yanks stay inside the
-- one instance. OSC 52 fixes that: the yank is sent to the terminal emulator as
-- an escape sequence and the terminal (Ghostty, kitty, WezTerm, foot, ...) puts
-- it on the *client's* system clipboard, through zellij/tmux, so it can be
-- pasted anywhere with the terminal's own paste (Cmd+V / Ctrl+Shift+V),
-- including into another Neovim instance. Neovim's own OSC 52 auto-detection
-- does not kick in here: multiplexers swallow its DA1/XTGETTCAP probe and it
-- refuses to enable itself while 'clipboard' is set (`:help clipboard-osc52`).
--
-- The clipboard is deliberately not read back through OSC 52: terminals and
-- multiplexers decline that by default and Neovim would stall on every `p`.
-- Instead every yank is also recorded in a per-user file on this host
-- (`stdpath("run")`, a private tmpfs), and `p` pastes the latest yank of any
-- Neovim instance here, so it works across SSH sessions and zellij panes. The
-- provider has to hand that back itself because Neovim empties the register
-- before asking it. Text copied on the client side comes in with Cmd+V.
--
-- Guarded so local sessions are untouched: only when nothing else would be
-- found (no display, not inside tmux, which has its own provider) and only if
-- `g:clipboard` has not been set already.
if
  vim.g.clipboard == nil
  and vim.env.SSH_TTY
  and not (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY or vim.env.TMUX)
then
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = {} -- reg -> { lines, regtype } of this instance's latest yank
  local store = vim.fs.joinpath(vim.fn.stdpath("run"), "clipboard.json")

  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      -- Neovim accepts a one-character regtype back; blockwise carries a width.
      last[reg] = { lines, regtype:sub(1, 1) }
      pcall(vim.fn.writefile, { vim.json.encode(last[reg]) }, store)
      send(lines, regtype)
    end
  end

  local function paste(reg)
    return function()
      local ok, shared = pcall(function()
        return vim.json.decode(vim.fn.readfile(store)[1])
      end)
      return ok and shared or last[reg] or {}
    end
  end

  vim.g.clipboard = {
    name = "OSC 52 (ssh)",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
  }
end

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- -- Decrease mapped sequence wait time
-- vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

vim.o.ruler = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Reload file when changed externally (autoread is on by default; this triggers the check)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  desc = "Check timestamps and reload file if changed outside Neovim",
  command = "silent! checktime",
})

-- Jumps (G, gg, %, CTRL-D/U/B/F, H/M/L, etc.) land on the first non-blank of the target line
vim.o.startofline = true

-- Don't redraw during macros and other untyped commands; speeds up large changes
vim.o.lazyredraw = true

-- Don't evaluate modelines; mitigates editor-config injection from untrusted files
vim.o.modeline = false

-- Briefly highlight the matching bracket when the cursor lands on one
vim.o.showmatch = true
vim.o.matchtime = 2

-- NOTE: 'foldcolumn', 'foldlevel' and 'fillchars' are set in plugin/99-ufo.lua

-- Don't auto-open folds on horizontal or jump-block motions (see `:help 'foldopen'`)
vim.opt.foldopen:remove({ "hor", "block" })

-- Most files live in version control; disable writebackup and swapfile
vim.o.writebackup = false
vim.o.swapfile = false

-- Tabs insert spaces; default indent width is 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- When wrap is on, break lines at word boundaries rather than mid-word
vim.o.linebreak = true

-- Disable line wrapping by default
vim.o.wrap = false

-- Show "1 of N" search counts (clear `S` from shortmess)
-- ref: https://vi.stackexchange.com/a/23296
vim.opt.shortmess:remove("S")

-- Use a dark background
vim.o.background = "dark"

-- 24-bit RGB colors, required by many fancy UI plugins
vim.o.termguicolors = true

-- Single global statusline shared across windows
vim.o.laststatus = 3

-- Rounded borders for floating windows (Neovim >= 0.11)
vim.o.winborder = "rounded"

-- Don't shift `#`-prefixed lines to column 0 (preserves comment indent)
vim.o.cindent = true
vim.opt.cinkeys:remove("0#")

-- Disable Neovim's editorconfig integration; it conflicts with vim-symlink
-- ref: https://github.com/aymericbeaumet/vim-symlink/issues/14
vim.g.editorconfig = false

-- [[ Better grep via ripgrep ]]
-- Populates the quickfix / loclist from `:Grep` / `:LGrep`
-- https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
vim.o.grepprg = "rg --vimgrep --no-heading"
vim.opt.grepformat:append("%f:%l:%c:%m")

local function make_grep_cmd(list_letter)
  return function(opts)
    -- cgetexpr / lgetexpr evaluate a vimscript expression, so stash output on g: first
    vim.g._grep_output =
      vim.fn.system(vim.o.grepprg .. " " .. vim.fn.expandcmd(opts.args))
    vim.cmd(list_letter .. "getexpr g:_grep_output")
  end
end
vim.api.nvim_create_user_command(
  "Grep",
  make_grep_cmd("c"),
  { nargs = "+", complete = "file_in_path", bar = true }
)
vim.api.nvim_create_user_command(
  "LGrep",
  make_grep_cmd("l"),
  { nargs = "+", complete = "file_in_path", bar = true }
)

-- Auto-open quickfix after it is populated
local grep_qf = vim.api.nvim_create_augroup("grep-quickfix", { clear = true })
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = grep_qf,
  pattern = "cgetexpr",
  command = "cwindow",
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = grep_qf,
  pattern = "lgetexpr",
  command = "lwindow",
})

-- Route plain `:grep` / `:lgrep` through `:Grep` / `:LGrep`
require("util").cabbrev("grep", "Grep")
require("util").cabbrev("lgrep", "LGrep")

-- [[ netrw ]]
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 10
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_keepdir = 0

-- Free <C-hjkl> inside netrw so the window-navigation mappings (defined by
-- mini.basics in plugin/99-mini.basics.lua) still work there
vim.api.nvim_create_autocmd("FileType", {
  desc = "Remove netrw <C-hjkl> mappings to free them for window navigation",
  pattern = "netrw",
  callback = function()
    for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
      pcall(vim.keymap.del, "n", key, { buffer = true })
    end
  end,
})

-- Auto-balance splits when the host window is resized
vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto-resize splits when the host window changes size",
  command = "wincmd =",
})

-- Restore last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to the last edit position when opening a file",
  callback = function()
    local last = vim.fn.line([['"]])
    if last > 1 and last <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Smarter cursorline: only the active window when not in insert mode
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#smarter-cursorline
local cursorline_group =
  vim.api.nvim_create_augroup("smarter-cursorline", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Start terminal buffers in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Start terminal buffers in insert mode",
  group = vim.api.nvim_create_augroup("TermOpenInsert", { clear = true }),
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd.startinsert()
    end
  end,
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Better up/down for wrapped lines: with no count, move by visual line (`gj`/`gk`),
-- but with a count, jump by logical lines so relative jumps still hit the right target
for _, lhs in ipairs({ "j", "<Down>" }) do
  vim.keymap.set({ "n", "x" }, lhs, function()
    return vim.v.count == 0 and "gj" or "j"
  end, { expr = true, silent = true })
end
for _, lhs in ipairs({ "k", "<Up>" }) do
  vim.keymap.set({ "n", "x" }, lhs, function()
    return vim.v.count == 0 and "gk" or "k"
  end, { expr = true, silent = true })
end

-- Search inside the current visual selection
vim.keymap.set("x", "g/", [[<esc>/\%V]], { desc = "Search inside selection" })

-- Exit terminal-insert mode with <C-u> for easier scrollback
vim.keymap.set("t", "<C-u>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- :ls then prompt for a buffer number
vim.keymap.set("n", "gb", ":ls<CR>:b<Space>", { desc = "List buffers and switch" })

-- Wrap a mapping so `.` replays the whole mapping (register and count included).
local function repeatable(lhs, fn)
  lhs = vim.keycode(lhs)
  return function()
    local reg, count = vim.v.register, vim.v.count
    fn(reg, count)
    vim.fn["repeat#setreg"](lhs, reg)
    vim.fn["repeat#set"](lhs, count) -- after the last change: keyed to b:changedtick
  end
end

-- Linewise paste helper (ported from tpope/vim-unimpaired). Forces the paste to
-- behave as linewise even when the register holds characterwise text, then
-- restores the original register type so subsequent pastes aren't affected.
local function putline(how)
  local body = vim.fn.getreg(vim.v.register)
  local rtype = vim.fn.getregtype(vim.v.register)
  if rtype == "V" then
    vim.cmd('normal! "' .. vim.v.register .. how)
  else
    vim.fn.setreg(vim.v.register, body, "l")
    vim.cmd('normal! "' .. vim.v.register .. how)
    vim.fn.setreg(vim.v.register, body, rtype)
  end
end

-- Builds the callback for the [p/]p family. With `post_op`, the count is folded
-- into the paste and `post_op` (a normal-mode command like `>']`) operates on
-- the just-pasted region.
local function put(lhs, how, post_op)
  return repeatable(lhs, function(_, count)
    putline((post_op and tostring(math.max(count, 1)) or "") .. how)
    if post_op then
      vim.cmd("normal! " .. post_op)
    end
  end)
end

-- Bracket-pair mappings: navigate lists and paste linewise
for _, m in ipairs({
  -- Argument list
  { "]a", "<Cmd>next<CR>", "Next argument" },
  { "[a", "<Cmd>prev<CR>", "Previous argument" },
  { "]A", "<Cmd>last<CR>", "Last argument" },
  { "[A", "<Cmd>first<CR>", "First argument" },
  -- Buffer list
  { "]b", "<Cmd>bnext<CR>", "Next buffer" },
  { "[b", "<Cmd>bprev<CR>", "Previous buffer" },
  { "]B", "<Cmd>blast<CR>", "Last buffer" },
  { "[B", "<Cmd>bfirst<CR>", "First buffer" },
  -- Quickfix list
  { "]q", "<Cmd>cnext<CR>", "Next quickfix entry" },
  { "[q", "<Cmd>cprev<CR>", "Previous quickfix entry" },
  { "]Q", "<Cmd>clast<CR>", "Last quickfix entry" },
  { "[Q", "<Cmd>cfirst<CR>", "First quickfix entry" },
  -- Location list
  { "]l", "<Cmd>lnext<CR>", "Next loclist entry" },
  { "[l", "<Cmd>lprev<CR>", "Previous loclist entry" },
  { "]L", "<Cmd>llast<CR>", "Last loclist entry" },
  { "[L", "<Cmd>lfirst<CR>", "First loclist entry" },
  -- Linewise paste (vim-unimpaired style)
  { "[p", put("[p", "[p"), "Paste linewise above" },
  { "]p", put("]p", "]p"), "Paste linewise below" },
  { "[P", put("[P", "[p"), "Paste linewise above" },
  { "]P", put("]P", "]p"), "Paste linewise below" },
  { ">P", put(">P", "[p", ">']"), "Paste linewise above, then shift right" },
  { ">p", put(">p", "]p", ">']"), "Paste linewise below, then shift right" },
  { "<P", put("<P", "[p", "<']"), "Paste linewise above, then shift left" },
  { "<p", put("<p", "]p", "<']"), "Paste linewise below, then shift left" },
  { "=P", put("=P", "[p", "=']"), "Paste linewise above, then reindent" },
  { "=p", put("=p", "]p", "=']"), "Paste linewise below, then reindent" },
}) do
  vim.keymap.set("n", m[1], m[2], { silent = true, desc = m[3] })
end

-- Move (i.e., "exchange") current line up / down (accepts a count)
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-move-current-line
vim.keymap.set(
  "n",
  "[e",
  repeatable("[e", function(_, count)
    vim.cmd("move -1-" .. math.max(count, 1))
  end),
  { desc = "Move line(s) up" }
)
vim.keymap.set(
  "n",
  "]e",
  repeatable("]e", function(_, count)
    vim.cmd("move +" .. math.max(count, 1))
  end),
  { desc = "Move line(s) down" }
)
-- Visual mode moves the selected lines as a block and reselects them. The
-- `'<`/`'>` marks are only set on leaving Visual mode, so exit first, `:move`
-- relative to those marks, then `gv` to reselect the (now shifted) block.
local function move_selection(direction)
  return function()
    local count = vim.v.count1
    vim.cmd("normal! \27") -- <Esc>: leave Visual mode, set '< and '>
    if direction == "up" then
      vim.cmd(("'<,'>move '<-%d"):format(count + 1))
    else
      vim.cmd(("'<,'>move '>+%d"):format(count))
    end
    vim.cmd("normal! gv")
  end
end
vim.keymap.set("x", "[e", move_selection("up"), { desc = "Move selection up" })
vim.keymap.set("x", "]e", move_selection("down"), { desc = "Move selection down" })

-- -- Navigate treesitter nodes in visual mode (BUILTIN NEOVIM >= 0.12)
-- vim.keymap.set({ 'x' }, '[n', function()
--   require 'vim.treesitter._select'.select_prev(vim.v.count1)
-- end, { desc = 'Select previous treesitter node' })
-- vim.keymap.set({ 'x' }, ']n', function()
--   require 'vim.treesitter._select'.select_next(vim.v.count1)
-- end, { desc = 'Select next treesitter node' })

-- Add [count] empty lines above / below without moving the cursor. Editing the
-- buffer directly sidesteps autoindent / indentexpr, so no 'paste' toggling.
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-add-empty-lines
local function add_blank_lines(where)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local at = where == "above" and row - 1 or row -- 0-based insertion index
    local blanks = {}
    for i = 1, vim.v.count1 do
      blanks[i] = ""
    end
    require("util").keep_cursor(function()
      vim.api.nvim_buf_set_lines(0, at, at, false, blanks)
    end)
  end
end
vim.keymap.set(
  "n",
  "]<space>",
  repeatable("]<space>", add_blank_lines("below")),
  { desc = "Add empty line below" }
)
vim.keymap.set(
  "n",
  "[<space>",
  repeatable("[<space>", add_blank_lines("above")),
  { desc = "Add empty line above" }
)

-- Open the current buffer in a new tab (like <C-w>T but preserves the original window)
vim.keymap.set("n", "<C-w>t", "<Cmd>tab split<CR>", { desc = "Buffer in new tab" })

-- NOTE: "saner" n/N (always forward / always backward) lives in
-- plugin/99-hlslens.lua because hlslens must wrap the same keys.

-- "Saner" command-line history: <C-n>/<C-p> traverse history when the wildmenu isn't open
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-command-line-history
vim.keymap.set("c", "<C-n>", function()
  return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>"
end, { expr = true, desc = "Next in history (or wildmenu)" })
vim.keymap.set("c", "<C-p>", function()
  return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>"
end, { expr = true, desc = "Previous in history (or wildmenu)" })

-- Paste over a selection without the replaced text taking over the register
vim.keymap.set("x", "p", "pgvy", { desc = "Paste over selection (keep register)" })

-- Visual select the last pasted text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Select last pasted text" })

-- Dot-repeat that keeps the cursor on the text it was on. A [count] is passed
-- through only when given, so a bare `.` still reuses the original count.
vim.keymap.set("n", ".", function()
  if vim.g.repeat_tick == vim.b.changedtick then -- a vim-repeat mapping is pending
    return vim.fn["repeat#run"](vim.v.count)
  end
  local count = vim.v.count > 0 and vim.v.count or ""
  require("util").keep_cursor(function()
    vim.cmd("normal! " .. count .. ".")
  end)
end, { desc = "Repeat (keep cursor)" })

-- Sticky yank: `y`/`Y` leave the cursor and the view where they were instead
-- of jumping to the start of the yanked text (`ygg` no longer scrolls away).
-- The operator only runs after the mapping returns, so the view is recorded
-- here and restored from TextYankPost. The record belongs to that one yank: it
-- is dropped once the command is over (yanked or cancelled with <Esc>), so
-- yanks that don't come through these keys (`:yank`, a plugin's `normal! y`)
-- are left alone.
-- Inspired by: https://nanotipsforvim.prose.sh/sticky-yank
do
  local pending -- { win, buf, view } of the mapped yank in progress

  local function sticky(keys)
    return function()
      local win = vim.api.nvim_get_current_win()
      pending = {
        win = win,
        buf = vim.api.nvim_win_get_buf(win),
        view = vim.fn.winsaveview(),
      }
      return keys
    end
  end
  vim.keymap.set(
    { "n", "x" },
    "y",
    sticky("y"),
    { expr = true, desc = "Yank (keep cursor)" }
  )
  vim.keymap.set(
    "n",
    "Y",
    sticky("y$"),
    { expr = true, desc = "Yank to end of line (keep cursor)" }
  )

  local group = vim.api.nvim_create_augroup("sticky-yank", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Restore the pre-yank cursor and view after a mapped yank",
    group = group,
    callback = function()
      local p = pending
      pending = nil
      if
        p
        and vim.v.event.operator == "y"
        and vim.api.nvim_get_current_win() == p.win
        and vim.api.nvim_get_current_buf() == p.buf
      then
        vim.fn.winrestview(p.view)
      end
    end,
  })
  -- Back in Normal mode means the yank is done or was cancelled (`y<Esc>`).
  -- Deferred, since this can fire before TextYankPost.
  vim.api.nvim_create_autocmd("ModeChanged", {
    desc = "Forget the pre-yank view once the yank is over",
    group = group,
    pattern = "*:n*",
    callback = function()
      vim.schedule(function()
        pending = nil
      end)
    end,
  })
end

-- Add a comment line above / below the current line and start inserting into
-- it. mini.comment decides the comment leader (it is context-aware, e.g. for
-- Lua inside Markdown), so insert a placeholder line at the current indent,
-- let it comment that, then remove the placeholder and put the cursor there.
local function add_comment_line(where)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local indent = vim.api.nvim_get_current_line():match("^%s*")
    local at = where == "above" and row - 1 or row -- 0-based insertion index
    local placeholder = "\1" -- a byte that cannot already be in the comment
    vim.api.nvim_buf_set_lines(0, at, at, false, { indent .. placeholder })
    local new_row = at + 1
    require("mini.comment").toggle_lines(new_row, new_row)
    local line = vim.api.nvim_buf_get_lines(0, at, new_row, false)[1]
    local col = assert(line:find(placeholder, 1, true)) -- 1-based
    line = line:sub(1, col - 1) .. line:sub(col + 1)
    vim.api.nvim_buf_set_lines(0, at, new_row, false, { line })
    vim.api.nvim_win_set_cursor(0, { new_row, col - 1 })
    if col > #line then
      vim.cmd("startinsert!") -- placeholder was at the end of the line: append
    else
      vim.cmd("startinsert") -- inside a block comment: insert before the closer
    end
  end
end
vim.keymap.set(
  "n",
  "gco",
  add_comment_line("below"),
  { desc = "Add comment line below" }
)
vim.keymap.set(
  "n",
  "gcO",
  add_comment_line("above"),
  { desc = "Add comment line above" }
)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  },
})

-- NOTE: diagnostics-to-loclist is `<leader>cq` (plugin/90-lspconfig.lua)

-- Exit terminal mode with a double <Esc> (the builtin is <C-\><C-n>)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- NOTE: <C-hjkl> window navigation and <C-Arrow> window resizing are provided
-- by mini.basics (plugin/99-mini.basics.lua).

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ============================================================
-- SECTION 2: PLUGIN MANAGER HOOKS
-- vim.pack build hooks
-- ============================================================
do
  -- [[ Intro to `vim.pack` ]]
  -- `vim.pack` is a new plugin manager built into Neovim,
  --  which provides a Lua interface for installing and managing plugins.
  --
  --  See `:help vim.pack`, `:help vim.pack-examples` or the
  --  excellent blog post from the creator of vim.pack and mini.nvim:
  --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
  --
  --  To inspect plugin state and pending updates, run
  --    :lua vim.pack.update(nil, { offline = true })
  --
  --  To update plugins, run
  --    :lua vim.pack.update()

  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ""
      local stdout = result.stdout or ""
      local output = stderr ~= "" and stderr or stdout
      if output == "" then
        output = "No output from build command."
      end
      vim.notify(
        ("Build failed for %s:\n%s"):format(name, output),
        vim.log.levels.ERROR
      )
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= "install" and kind ~= "update" then
        return
      end

      -- if name == 'LuaSnip' then
      --   if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
      --     run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
      --   end
      --   return
      -- end

      if name == "nvim-treesitter" then
        if not ev.data.active then
          vim.cmd.packadd("nvim-treesitter")
        end
        vim.cmd("TSUpdate")
        return
      end
    end,
  })
end
