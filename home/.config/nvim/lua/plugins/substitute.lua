local paste_modifiers = function(state)
  if state.vmode == 'char' then
    return { 'trim' }
  elseif state.vmode == 'line' then
    return { 'reindent' }
  end
end

local buffer_range_opts = { range = { motion = 'ie' } }
local complete_buffer_range = { complete_word = true, range = { motion = 'ie' } }

return {
  'https://github.com/gbprod/substitute.nvim',
  dependencies = {
    {
      -- Substitute text with variant-awareness
      'https://github.com/tpope/vim-abolish',
      version = 'dcbfe065297d31823561ba787f51056c147aa682',
    },
  },
  keys = {
    -- Paste with replacement
    {
      '<leader>p',
      function()
        require('substitute').operator { modifiers = paste_modifiers }
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      '<leader>pp',
      function()
        require('substitute').line { modifiers = paste_modifiers }
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      '<leader>P',
      function()
        require('substitute').eol { modifiers = paste_modifiers }
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      '<leader>p',
      function()
        require('substitute').visual { modifiers = paste_modifiers }
      end,
      mode = 'v',
      { noremap = true },
    },
    -- Sub / Replace across motion, with word boundaries
    {
      's',
      function()
        require('substitute.range').operator { complete_word = true }
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      's',
      function()
        require('substitute.range').visual { complete_word = true }
      end,
      mode = 'x',
      { noremap = true },
    },
    {
      'ss',
      function()
        require('substitute.range').word { complete_word = true }
      end,
      mode = 'n',
      { noremap = true },
    },
    -- Sub / Replace across entire buffer, with word boundaries
    {
      '<leader>s',
      function()
        require('substitute.range').operator(complete_buffer_range)
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      '<leader>s',
      function()
        require('substitute.range').visual(complete_buffer_range)
      end,
      mode = 'x',
      { noremap = true },
    },
    {
      '<leader>ss',
      function()
        require('substitute.range').word(complete_buffer_range)
      end,
      mode = 'n',
      { noremap = true },
    },
    -- Sub / Replace across motion
    {
      'gs',
      function()
        require('substitute.range').operator()
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      'gs',
      function()
        require('substitute.range').visual()
      end,
      mode = 'x',
      { noremap = true },
    },
    {
      'gss',
      function()
        require('substitute.range').word()
      end,
      mode = 'n',
      { noremap = true },
    },
    -- Sub / Replace across entire buffer
    {
      '<leader>gs',
      function()
        require('substitute.range').operator(buffer_range_opts)
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      '<leader>gs',
      function()
        require('substitute.range').visual(buffer_range_opts)
      end,
      mode = 'x',
      { noremap = true },
    },
    {
      '<leader>gss',
      function()
        require('substitute.range').word(buffer_range_opts)
      end,
      mode = 'n',
      { noremap = true },
    },
    -- Exchange mappings
    {
      'cx',
      function()
        require('substitute.exchange').operator()
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      'cxx',
      function()
        require('substitute.exchange').line()
      end,
      mode = 'n',
      { noremap = true },
    },
    {
      'X',
      function()
        require('substitute.exchange').visual()
      end,
      mode = 'x',
      { noremap = true },
    },
    {
      'cxc',
      function()
        require('substitute.exchange').cancel()
      end,
      mode = 'n',
      { noremap = true },
    },
  },
  opts = {
    on_substitute = nil,
    yank_substituted_text = false,
    preserve_cursor_position = false,
    modifiers = nil,
    highlight_substituted_text = {
      enabled = true,
      timer = 500,
    },
    range = {
      prefix = 's',
      prompt_current_text = false,
      confirm = true,
      complete_word = false,
      group_substituted_text = true,
      subject = nil,
      range = nil,
      suffix = '',
      auto_apply = false,
      cursor_position = 'end',
    },
    exchange = {
      motion = false,
      use_esc_to_cancel = true,
      preserve_cursor_position = false,
    },
  },
}
