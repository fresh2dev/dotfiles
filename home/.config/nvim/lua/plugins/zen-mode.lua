return {
  {
    'https://github.com/folke/zen-mode.nvim',
    keys = {
      { '<leader>tz', ':ZenMode<CR>', mode = 'n', desc = '[T]oggle [Z]en-Mode' },
      { 'gz', ':ZenMode<CR>', mode = 'n', desc = '[G]o [Z]en' },
      { '<leader>tZ', ':setlocal nonumber | ZenMode | TwilightEnable<CR>', mode = 'n', desc = '[T]oggle more [Z]en-Mode' },
      { 'gZ', ':setlocal nonumber | ZenMode | TwilightEnable<CR>', mode = 'n', desc = '[G]o more [Z]en' },
    },
    cmd = {
      'ZenMode',
    },
    dependencies = {
      'https://github.com/folke/twilight.nvim',
      'https://github.com/b0o/incline.nvim',
    },
    opts = {
      on_open = function()
        -- require('incline').disable()
      end,
      on_close = function()
        vim.cmd 'setlocal number'
        vim.cmd 'TwilightDisable'
        -- require('incline').enable()
      end,
      plugins = {
        -- disable some global vim options (vim.o...)
        -- comment the lines to not apply the options
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 0, -- turn off the statusline in zen mode
        },
        twilight = { enabled = false },
        gitsigns = { enabled = false },
        todo = { enabled = true },
        alacritty = {
          enabled = true,
          font = '16', -- font size
        },
      },
    },
  },
  {
    'https://github.com/folke/twilight.nvim',
    -- keys = {
    --   { '<leader>tl', ':Twilight<CR>', mode = 'n', desc = '[T]oggle Twi[l]ight' },
    -- },
    opts = {
      dimming = {
        alpha = 0.50, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { 'Normal', '#ffffff' },
        term_bg = '#000000', -- if guibg=NONE, this will be used to calculate text color
        inactive = true, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 15, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
      -- treesitter is used to automatically expand the visible text,
      -- but you can further control the types of nodes that should always be fully expanded
      expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        'function',
        'method',
        'table',
        'if_statement',
      },
      exclude = {}, -- exclude these filetypes
    },
  },
  {
    'https://github.com/joshuadanpeterson/typewriter',
    keys = {
      { '<leader>zz', ':TWToggle<CR>', mode = 'n', desc = 'Toggle Typewriter Mode' },
    },
    cmd = {
      'TWEnable',
      'TWDisable',
      'TWToggle',
      'TWCenter',
      'TWTop',
      'TWBottom',
    },
    opts = {
      enable_with_zen_mode = false,
      enable_with_true_zen = false,
      keep_cursor_position = true,
      enable_notifications = true,
      enable_horizontal_scroll = false,
    },
  },
}
