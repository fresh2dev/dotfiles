return {
  'https://github.com/mikavilpas/yazi.nvim',
  cmd = { 'Yazi' },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    -- {
    --   -- Open in the current working directory
    --   '<C-\\>',
    --   '<cmd>Yazi cwd<cr>',
    --   desc = '[F]ile [E]xplorer (Yazi)',
    -- },
    {
      '<C-\\>',
      '<cmd>Yazi<cr>',
      desc = '[F]ile [E]xplorer (Yazi)',
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    open_multiple_tabs = false,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = 'none',
    highlight_hovered_buffers_in_same_directory = false,
    keymaps = {
      show_help = false,
      open_file_in_vertical_split = '<C-v>',
      open_file_in_horizontal_split = '<C-o>',
      open_file_in_tab = false,
      grep_in_directory = false,
      replace_in_directory = '<leader>fr',
      -- cycle_open_buffers = '<tab>',
      cycle_open_buffers = false,
      copy_relative_path_to_selected_files = '<c-y>',
      send_to_quickfix_list = '<C-q>',
      change_working_directory = false,
    },
    hooks = {
      yazi_opened_multiple_files = require('yazi.openers').send_files_to_quickfix_list,
    },
  },
}
