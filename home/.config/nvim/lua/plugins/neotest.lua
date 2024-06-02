-- return {}
return {
  {
    'https://github.com/nvim-neotest/neotest',
    lazy = false,
    -- stylua: ignore
    keys = {
      {"<leader>d", "", desc = "+debug"},
      { "<leader>df", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>dF", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
      { "<leader>dr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>dR", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
      { "<leader>dl", function() require("neotest").run.run_last() end, desc = "Run Last" },
      { "<leader>ds", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>do", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>dO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      -- { "<leader>dq", function() require("neotest").run.stop() end, desc = "Stop" },
      -- { "<leader>dw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
    },
    dependencies = {
      { 'https://github.com/nvim-neotest/nvim-nio' },
      { 'https://github.com/nvim-lua/plenary.nvim' },
      { 'https://github.com/antoinemadec/FixCursorHold.nvim' },
      { 'https://github.com/nvim-treesitter/nvim-treesitter' },
      { 'https://github.com/nvim-neotest/neotest-python' },
      { 'https://github.com/mfussenegger/nvim-dap' },
    },
    config = function()
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
            -- args = { '--log-level', 'DEBUG' },
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
      }
    end,
  },
}
