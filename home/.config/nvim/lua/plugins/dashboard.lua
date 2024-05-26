return {
  'nvimdev/dashboard-nvim',
  -- event = 'VimEnter',
  lazy = false,
  keys = {
    { '<leader><leader>', ':Dashboard<CR>', desc = 'Dashboard' },
    -- { '<leader>sp', ':split | Dashboard<CR>',  desc = 'NeoTree split'  },
    -- { '<leader>vs', ':vsplit | Dashboard<CR>',  desc = 'NeoTree vsplit'  },
  },
  opts = function()
    local logo = [[

        Z
    Z    
 z       
    ]]

    local opts = {
      theme = 'doom',
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, '\n'),
        center = {
          {
            action = 'enew',
            desc = ' New Document',
            icon = ' ',
            -- key = '~',
          },
          {
            action = 'Neotree',
            desc = ' Explore Files',
            icon = ' ',
            key = '\\',
          },
          {
            action = 'Zi',
            desc = ' Open Directory',
            icon = ' ',
            key = '<leader>fz',
          },
          {
            action = 'FzfLua oldfiles',
            desc = ' Open Recent Files',
            icon = ' ',
            key = '<leader>fo',
          },
          {
            action = 'FzfLua files',
            desc = ' Find Files',
            icon = ' ',
            key = '<leader>ff',
          },
          {
            action = 'FzfLua live_grep',
            desc = ' Search Text',
            icon = ' ',
            key = '<leader>fs',
          },
          {
            action = "lua require('spectre').open()",
            desc = ' Search & Replace Text',
            icon = ' ',
            key = '<leader>fr',
          },
          {
            action = 'FzfLua git_status',
            desc = ' Git Status',
            icon = ' ',
            key = '<leader>fg',
          },
          {
            action = 'lua require("persistence").load()',
            desc = ' Restore Session',
            icon = ' ',
            key = 'r',
          },
          {
            action = 'Scratch',
            desc = ' ScratchPad',
            icon = ' ',
            key = '~',
          },
          {
            action = 'lua vim.cmd("Neotree position=float dir=".. vim.fn.stdpath("config"))',
            desc = ' Dotfiles',
            icon = ' ',
            key = '.',
          },
          {
            action = 'Lazy sync',
            desc = ' Update Plugins',
            icon = '󰒲 ',
            key = 'u',
          },
          {
            action = 'q',
            desc = ' Quit',
            icon = ' ',
            key = 'q',
          },
          -- { action = [[lua LazyVim.telescope.config_files()()]], desc = " Config",          icon = " ", key = "c" },
        },
        footer = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(' ', 33 - #button.desc)
      button.key_format = '  %s'
    end

    -- -- close Lazy and re-open when the dashboard is ready
    -- if vim.o.filetype == 'lazy' then
    --   vim.cmd.close()
    --   vim.api.nvim_create_autocmd('User', {
    --     pattern = 'DashboardLoaded',
    --     callback = function()
    --       require('lazy').show()
    --     end,
    --   })
    -- end

    return opts
  end,
  dependencies = {
    {
      'folke/persistence.nvim',
      event = 'BufReadPre',
      opts = { options = vim.opt.sessionoptions:get() },
      -- stylua: ignore
      -- keys = {
      --   { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      --   { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      --   { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
      -- },
    },
  },
}
