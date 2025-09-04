return {
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
    start_enabled = false,
    always_center = true,
  },
}
