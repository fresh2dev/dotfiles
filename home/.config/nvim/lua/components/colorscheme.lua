return {
  {
    -- A clean, dark Neovim theme
    'https://github.com/folke/tokyonight.nvim',
    version = 'v4',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
    opts = {
      -- Make the window border color more apparent.
      -- ref: https://github.com/folke/tokyonight.nvim/issues/34#issuecomment-1347911154
      on_colors = function(colors)
        colors.border = '#565f89'
      end,
    },
  },
  {
    -- Soothing pastel theme for (Neo)vim
    'https://github.com/catppuccin/nvim',
    version = 'v1',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    -- init = function()
    --   -- Load the colorscheme here.
    --   vim.cmd.colorscheme 'catppuccin-mocha'
    -- end,
    opts = {
      term_colors = true,
      transparent_background = false,
      color_overrides = {
        mocha = {
          base = '#000000',
          mantle = '#000000',
          crust = '#000000',
        },
      },
    },
  },
  {
    -- Neovim plugin to improve the default vim.ui interfaces
    'https://github.com/stevearc/dressing.nvim',
    opts = {},
  },
  {
    -- A fancy, configurable, notification manager for NeoVim
    'https://github.com/rcarriga/nvim-notify',
    version = 'v3',
    opts = {},
  },
}
