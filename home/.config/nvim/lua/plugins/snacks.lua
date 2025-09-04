return {
  'https://github.com/folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  -- stylua: ignore
  keys = {
    -- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    -- { "<leader>fr", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>f-", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "U", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>`",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { '<C-w>', [[<C-\><C-n><C-w>]], mode = 't' },
    { "<leader>tz", function() Snacks.zen.zoom() end, desc = "[T]oggle [Z]oom" },
    { "gz", function() Snacks.zen.zoom() end, desc = "[G]o [Z]oom" },
    { "<leader>tZ", function() Snacks.zen.zen(); vim.cmd 'setlocal nonumber' end, desc = "[T]oggle [Z]en-Mode" },
    { "gZ", function() Snacks.zen.zen(); vim.cmd 'setlocal nonumber' end, desc = "[G]o [Z]en" },
    { "<leader>0",  function() Snacks.scratch.open({ file = os.getenv("HOME") .. "/.scratch/global.md", name = "Global Scratch" }) end, desc = "Global Scratch Buffer" },
    { "<leader>1",  function() Snacks.scratch() end, desc = "Local Scratch Buffer" },
    { "<leader>f1",  function() Snacks.scratch.select() end, desc = "Local Scratch Buffer" },
    -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    -- { "<leader>fy", function() Snacks.picker.cliphist() end, desc = "Projects" },  -- Specific to Linux.
  },
  init = function()
    vim.g.snacks_animate = false

    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>ts'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
        -- Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>tL'
        Snacks.toggle.diagnostics():map '<leader>td'
        -- Snacks.toggle.line_number():map '<leader>tl'
        -- Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>tc'
        -- Snacks.toggle.treesitter():map '<leader>tT'
        -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>tb'
        Snacks.toggle.inlay_hints():map '<leader>th'
        Snacks.toggle.indent():map '<leader>ti'
        Snacks.toggle.dim():map '<leader>tD'
      end,
    })
  end,
  opts = {
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
      style = 'fancy', -- 'compact', 'fancy', 'minimal'
    },
    picker = { enabled = false }, -- Prefer `fzf-lua`
    quickfile = { enabled = false }, -- Doesn't make much of a difference.
    scratch = {
      enabled = true,
      root = os.getenv 'HOME' .. '/.scratch',
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
        style = 'zen',
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
          style = 'zen',
          backdrop = { transparent = false, blend = 0 },
          width = 0.8, -- full width
        },
      },
    },
  },
}
