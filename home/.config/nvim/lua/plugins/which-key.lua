-- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
return {
  'https://github.com/mrjones2014/legendary.nvim',
  version = 'v2.*',
  lazy = false,
  priority = 10000,
  dependencies = {
    'https://github.com/folke/which-key.nvim',
    lazy = false,
    keys = {
      {
        '<leader>tk',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
      {
        '<leader>tK',
        function()
          require('which-key').show { global = true }
        end,
        desc = 'Global Keymaps (which-key)',
      },
    },
    opts = {
      delay = function(ctx)
        return ctx.plugin and 0 or 1500
      end,
      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>f', group = '[F]ind' },
        { '<leader>g', group = '[G]it' },
        { '<leader>gh', group = '[G]it [H]unk' },
        { '<leader>q', group = '[Q]uit' },
        { '<leader>t', group = '[T]oggle' },
      },
    },
  },
  keys = {
    {
      '<C-p>',
      function()
        require('legendary').find {
          filters = { require('legendary.filters').current_mode() },
        }
      end,
      mode = 'n',
      desc = 'Find Commands and Keymaps',
    },
    {
      '<leader>fk',
      function()
        require('legendary').find {
          filters = {
            require('legendary.filters').current_mode(),
            require('legendary.filters').keymaps(),
          },
        }
      end,
      desc = '[F]ind [K]eymaps',
    },
    {
      '<leader>fc',
      function()
        require('legendary').find {
          filters = {
            require('legendary.filters').current_mode(),
            require('legendary.filters').commands(),
          },
        }
      end,
      desc = '[F]ind [C]ommands',
    },
  },
  config = function()
    require('legendary').setup {
      select_prompt = ' ',
      -- Include builtins by default, set to false to disable
      include_builtin = true,
      -- Include the commands that legendary.nvim creates itself
      -- in the legend by default, set to false to disable
      include_legendary_cmds = false,
      icons = {
        -- keymap items list the modes in which the keymap applies
        -- by default, you can show an icon instead by setting this to
        -- a non-nil icon
        keymap = nil,
        command = '>',
        fn = '󰡱',
        itemgroup = '',
      },
      extensions = {
        lazy_nvim = true,
        which_key = {
          auto_register = true,
          do_binding = false,
          use_groups = false,
        },
        diffview = true,
      },
    }
  end,
}
