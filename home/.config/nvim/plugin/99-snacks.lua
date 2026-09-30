vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" },
})

-- TODO: deleteme
Snacks = require("snacks")

Snacks.setup({
  animate = { enabled = false },
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  lazygit = {
    enabled = true,
    -- automatically configure lazygit to use the current colorscheme
    -- and integrate edit with the current neovim instance
    configure = false,
  },
  notifier = {
    enabled = true,
    timeout = 8000,
    style = "fancy", -- 'compact', 'fancy', 'minimal'
  },
  -- fzf-lua is the picker for everything it has a provider for; `Snacks.picker`
  -- is only called directly (below) for `undo` and `projects`, which fzf-lua
  -- lacks. Disabling it here keeps fzf-lua as the `vim.ui.select` handler.
  picker = { enabled = false },
  quickfile = { enabled = false }, -- Doesn't make much of a difference.
  scratch = {
    enabled = true,
    root = vim.fs.joinpath(vim.env.HOME, ".scratch"),
    filekey = {
      cwd = true, -- use current working directory
      branch = false, -- use current branch name
      count = false, -- use vim.v.count1
    },
  },
  scroll = { enabled = false }, -- Still buggy.
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  words = { enabled = true },
  zen = {
    enabled = true,
    toggles = {
      dim = false,
      git_signs = false,
      mini_diff_signs = false,
      diagnostics = false,
      inlay_hints = false,
    },
    show = {
      statusline = true, -- can only be shown when using the global statusline
      tabline = false,
    },
    win = {
      style = "zen",
      backdrop = { transparent = false, blend = 0 },
      width = 0.8,
    },
    zoom = {
      toggles = {},
      show = {
        statusline = true,
        tabline = true,
      },
      win = {
        style = "zen",
        backdrop = { transparent = false, blend = 0 },
        width = 0.8, -- full width
      },
    },
  },
})

vim.g.snacks_animate = false

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
-- Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tL'
Snacks.toggle.diagnostics():map("<leader>td")
-- Snacks.toggle.line_number():map '<leader>tl'
-- Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'
-- Snacks.toggle.treesitter():map '<leader>tT'
-- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tb'
Snacks.toggle.inlay_hints():map("<leader>th")
Snacks.toggle.indent():map("<leader>ti")
-- Snacks.toggle.dim():map("<leader>tD")

-- vim.keymap.set({ 'n', 'x' }, '<leader>gB', Snacks.gitbrowse, { desc = "Git Browse" })
-- vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent({ filter = { cwd = true } }) end,
--   { desc = "Recent (cwd)" })
vim.keymap.set("n", "<leader>fp", function()
  Snacks.picker.projects()
end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fu", function()
  Snacks.picker.undo()
end, { desc = "Undotree" })
vim.keymap.set("n", "<leader>f-", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })
vim.keymap.set("n", "U", function()
  Snacks.picker.undo()
end, { desc = "Undotree" })

-- Make it easier to get out of terminal mode using Ctrl-w
vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Window Navigation" })

vim.keymap.set("n", "<leader>tz", function()
  Snacks.zen.zoom()
  vim.cmd("setlocal nonumber")
end, { desc = "[T]oggle [Z]oom" })

vim.keymap.set("n", "gz", function()
  Snacks.zen.zoom()
  vim.cmd("setlocal nonumber")
end, { desc = "[G]o [Z]oom" })

vim.keymap.set("n", "<leader>tZ", function()
  Snacks.zen.zen()
  vim.cmd("setlocal nonumber")
end, { desc = "[T]oggle [Z]en-Mode" })

vim.keymap.set("n", "gZ", function()
  Snacks.zen.zen()
  vim.cmd("setlocal nonumber")
end, { desc = "[G]o [Z]en" })

--------------------------------------------------------------------------------
--- Terminals
--------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>`", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<leader>lg", function()
  Snacks.lazygit()
end, { desc = "[L]azy[G]it" })

vim.keymap.set("n", "<leader>ghd", function()
  Snacks.terminal({ "hunk", "diff" })
end, { desc = "[H]unk [D]iff" })

vim.keymap.set("n", "<leader>J", function()
  Snacks.terminal({ "just" }, { auto_close = false })
end, { desc = "[J]ust Command Runner" })

-- # TODO: add commands `:LazyGit [<args>]` `:HunkDiff [<args>]` `:HunkShow [<args>]` `:Just [<args>]`, `:J [<args>]`
-- # TODO: somewhat feature parity with Zed configs
