return {
  {
    -- A clean, dark Neovim theme
    'https://github.com/folke/tokyonight.nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    -- init = function()
    --   -- Like many other themes, this one has different styles, and you could load
    --   -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --   vim.cmd.colorscheme 'tokyonight-night'
    -- end,
    opts = {
      -- Make the window border color more apparent.
      -- ref: https://github.com/folke/tokyonight.nvim/issues/34#issuecomment-1347911154
      on_colors = function(colors)
        colors.border = '#565f89'
      end,
    },
  },
  {
    'EdenEast/nightfox.nvim',
    name = 'nightfox',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'carbonfox'
    end,
  },
  -- {
  --   -- Soothing pastel theme for (Neo)vim
  --   'https://github.com/catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   -- init = function()
  --   --   vim.cmd.colorscheme 'catppuccin-mocha'
  --   -- end,
  --   opts = {
  --     term_colors = true,
  --     transparent_background = false,
  --     -- color_overrides = {
  --     --   mocha = {
  --     --     base = '#000000',
  --     --     mantle = '#000000',
  --     --     crust = '#000000',
  --     --   },
  --     -- },
  --   },
  -- },
}
