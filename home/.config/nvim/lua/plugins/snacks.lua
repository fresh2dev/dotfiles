return {
  'https://github.com/folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- stylua: ignore
  keys = {
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fy", function() Snacks.picker.cliphist() end, desc = "Projects" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undotree" },
    -- { "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" }},
  },
  init = function()
    vim.g.snacks_animate = true
  end,
  opts = {
    animate = {},
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    indent = { enabled = false }, -- Prefer `mini.indentscope`
    input = { enabled = true },
    notifier = { enabled = true },
    picker = { enabled = false }, -- Prefer `fzf-lua`
    quickfile = { enabled = false }, -- Doesn't make much of a difference.
    scroll = { enabled = false }, -- Still buggy.
    statuscolumn = { enabled = true },
    words = { enabled = false },
  },
}
