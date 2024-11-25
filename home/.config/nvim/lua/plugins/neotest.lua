-- return {}
return {
  {
    'https://github.com/nvim-neotest/neotest',
    event = 'LspAttach',
    -- stylua: ignore
    keys = {
      {"<leader>d", "", desc = "+debug"},
      { "<leader>df", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>dF", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
      { "<leader>da", function() require("neotest").run.attach() end, desc = "Attach to Nearest" },
      { "<leader>dr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>dR", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
      { "<leader>dl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ds", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>do", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>dO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>dq", function() require("neotest").run.stop() end, desc = "Stop" },
      -- { "<leader>dw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    },
    dependencies = {
      { 'https://github.com/nvim-neotest/nvim-nio' },
      { 'https://github.com/nvim-lua/plenary.nvim' },
      { 'https://github.com/antoinemadec/FixCursorHold.nvim' },
      { 'https://github.com/nvim-treesitter/nvim-treesitter' },
      { 'https://github.com/nvim-neotest/neotest-python' },
      { 'https://github.com/mfussenegger/nvim-dap' },
      -- {
      --   'https://github.com/vim-test/vim-test',
      --   init = function()
      --     vim.g['test#strategy'] = 'neovim'
      --     vim.g['test#neovim#term_position'] = 'botright 30'
      --     vim.g['test#python#runner'] = 'pytest'
      --     vim.g['test#python#pytest#options'] = '--capture=no'
      --   end,
      -- },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = {
              justMyCode = false,
              console = 'integratedTerminal',
            },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { '--capture=no' },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = 'pytest',
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            -- python = '.venv/bin/python',
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = true,
          },
        },
        summary = {
          animated = true,
          count = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = 'a',
            clear_marked = 'X',
            clear_target = 'T',
            debug = 'd',
            debug_marked = 'D',
            expand = { 'l' },
            expand_all = 'zR',
            help = '?',
            jumpto = '<CR>',
            mark = 'x',
            next_failed = ']]',
            output = 'o',
            prev_failed = '[[',
            run = 'r',
            run_marked = 'R',
            short = 'O',
            stop = 'q',
            target = 't',
            watch = 'w',
          },
          open = 'botright vsplit | vertical resize 40',
        },
      }
    end,
  },
}
