return {
  { -- You can easily change to a different colorscheme.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      -- Make the window border color more apparent.
      -- ref: https://github.com/folke/tokyonight.nvim/issues/34#issuecomment-1347911154
      on_colors = function(colors)
        colors.border = '#565f89'
      end,
    },
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'catppuccin/nvim',
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
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'tokyonight',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        ignore_focus = { 'dashboard', 'neo-tree' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'filetype' },
        lualine_c = {
          {
            'filename',
            path = 1,
            -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
          },
        },
        -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    opts = {
      theme = 'tokyonight-night',
      attach_navic = false,
      show_modified = true,
      include_buftypes = { '', 'nowrite' },
      exclude_filetypes = { 'netrw', 'toggleterm' },
      -- lead_custom_section = function()
      --   return '!!!'
      -- end,
    },
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      options = {
        -- diagnostics = 'nvim_lsp',
        mode = 'tabs',
        -- sort_by = 'insert_after_current',
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = 'slant',
        always_show_bufferline = false,
        close_command = false,
        right_mouse_command = false,
        -- left_mouse_command = false,
      },
    },
    config = function(_, opts)
      require('bufferline').setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    'rcarriga/nvim-notify',
    opts = {},
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    config = true,
    -- function()
    --   require('colorful-winsep').setup {
    --     -- highlight for Window separator
    --     hi = {
    --       bg = '#16161E',
    --       fg = '#1F3442',
    --     },
    --     -- This plugin will not be activated for filetype in the following table.
    --     no_exec_files = { 'neo-tree' },
    --     -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
    --     symbols = { '━', '┃', '┏', '┓', '┗', '┛' },
    --     -- Smooth moving switch
    --     smooth = true,
    --     exponential_smoothing = true,
    --   }
    -- end,
    event = { 'WinNew' },
  },
}
