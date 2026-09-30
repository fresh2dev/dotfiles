vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/rbong/vim-flog" },
})

vim.g.fugitive_no_maps = 1
vim.g.fugitive_legacy_commands = 0

vim.g.flog_permanent_default_opts = {
  -- date = 'short',
  format = "[%h]%d %s",
}

-- Open the fugitive status buffer with a Flog commit graph beside it, then
-- press fugitive's `i` in the status window to expand the first inline diff.
-- `layout.before` runs first; `layout.status` is `Git` (split) or `0Git` (take
-- over the window); `layout.graph` is the Flogsplit modifier.
local function git_status_with_graph(layout)
  return function()
    if layout.before then
      vim.cmd(layout.before)
    end
    vim.cmd(layout.status)
    vim.cmd(layout.graph .. " Flogsplit")
    vim.cmd.wincmd("p")
    vim.cmd.normal({ "i", bang = false }) -- fugitive buffer-local mapping
  end
end

vim.keymap.set(
  "n",
  "<leader>gg",
  git_status_with_graph({ status = "Git", graph = "vertical" }),
  { desc = "Open [G]it" }
)
vim.keymap.set(
  "n",
  "<leader>gt",
  git_status_with_graph({ before = "tabnew", status = "0Git", graph = "" }),
  { desc = "Open [G]it in new [T]ab" }
)
vim.keymap.set(
  "n",
  "<leader>go",
  git_status_with_graph({ before = "only", status = "0Git", graph = "" }),
  { desc = "Open [G]it as [O]nly Window" }
)
vim.keymap.set(
  "n",
  "<leader>gO",
  git_status_with_graph({ before = "%bd", status = "0Git", graph = "" }),
  { desc = "Open [G]it as [O]nly Buffer" }
)

vim.keymap.set(
  "n",
  "<leader>gb",
  "<Cmd>Git blame -s<CR>",
  { desc = "Open [G]it [B]lame" }
)

vim.keymap.set(
  "n",
  "<leader>gl",
  "<Cmd>0Git log --graph --oneline --decorate<CR>",
  { desc = "Open [G]it [L]og" }
)

vim.keymap.set(
  "n",
  "<leader>gL",
  "<Cmd>0Git log --graph --oneline --decorate --all<CR>",
  { desc = "Open [G]it [L]og (--all)" }
)

vim.keymap.set("n", "<leader>ge", "<Cmd>Gedit<CR>", { desc = "[G]it [E]dit" })
vim.keymap.set("n", "<leader>gw", "<Cmd>Gwrite<CR>", { desc = "[G]it [W]rite (stage)" })
vim.keymap.set(
  "n",
  "<leader>gW",
  "<Cmd>Gwrite!<CR>",
  { desc = "[G]it [W]rite (force)" }
)
-- NOTE: `<leader>gd` is owned by diffview (99-diffview.lua). For a fugitive
-- single-file diff use `:Gvdiffsplit` or `dt` inside the `:Git` status buffer.

vim.keymap.set(
  "n",
  "<leader>gr",
  "<Cmd>1,$GcLog!<CR>",
  { desc = "View [G]it File [R]evisions" }
)

-- `:` rather than `<Cmd>` so the `'<,'>` range is inserted and fugitive runs
-- `git log -L` for the selected lines instead of a whole-file log.
vim.keymap.set(
  "x",
  "<leader>gr",
  ":GcLog!<CR>",
  { silent = true, desc = "View [G]it File [R]evisions for Selection" }
)

vim.keymap.set("n", "<leader>gp", "<Cmd>Git push<CR>", { desc = "[G]it [P]ush" })

vim.keymap.set(
  "n",
  "<leader>gP",
  "<Cmd>Git push -f<CR>",
  { desc = "[G]it [P]ush (force)" }
)

-- Automatically `cd` to the git root on startup.
-- NOTE: this is global behaviour that other plugins inherit: fzf-lua
-- (`oldfiles.cwd_only`), `:Grep`, blink's path source (`get_cwd`) and Snacks
-- scratch (`filekey.cwd`) all operate relative to this cwd.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("silent! Gcd")
  end,
})

-- " Quit fugitive with `q`:
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive,fugitiveblame,floggraph",
  callback = function()
    vim.keymap.set("n", "q", "gq", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "git",
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = true })
  end,
})

-- " always delete hidden buffers of these types,
-- " so git never waits for them to close.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit,gitrebase",
  callback = function()
    vim.bo.bufhidden = "delete"
  end,
})

-- " `<CR>` opens blame in new split:
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitiveblame",
  callback = function()
    vim.keymap.set("n", "<CR>", "o", { buffer = true })
  end,
})

-- " `O` opens a vsplit in Fugitive (overrides opening in tab)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "O", "gO", { buffer = true })
  end,
})

-- `dt` opens a diff in vsplit in a new tab. The file under the cursor is
-- resolved by evaluating fugitive's `<Plug><cfile>` command-line mapping (the
-- same thing fugitive does internally); a `<Cmd>` mapping cannot expand it
-- because command-line mappings only apply to typed text.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "dt", function()
      local cfile = vim.fn.eval(vim.fn.maparg("<Plug><cfile>", "c"))
      vim.cmd("Gtabedit " .. cfile)
      vim.cmd("Gvdiffsplit")
      vim.cmd("wincmd l")
    end, { buffer = true, silent = true, desc = "Diff in new tab" })
  end,
})

-- Set `g`, `git` as an abbreviation for `Git` in command mode
require("util").cabbrev("g", "Git")
require("util").cabbrev("git", "Git")
