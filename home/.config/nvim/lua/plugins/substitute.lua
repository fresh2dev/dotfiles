return {
  'gbprod/substitute.nvim',
  keys = {
    { '-', "<cmd>lua require('substitute').operator()<CR>", mode = 'n', { noremap = true } },
    { '--', "<cmd>lua require('substitute').line()<CR>", mode = 'n', { noremap = true } },
    { '_', "<cmd>lua require('substitute').eol()<CR>", mode = 'n', { noremap = true } },
    { '-', "<cmd>lua require('substitute').visual()<CR>", mode = 'v', { noremap = true } },
    { 'cx', "<cmd>lua require('substitute.exchange').operator()<CR>", mode = 'n', { noremap = true } },
    { 'cxx', "<cmd>lua require('substitute.exchange').line()<CR>", mode = 'n', { noremap = true } },
    { 'X', "<cmd>lua require('substitute.exchange').visual()<CR>", mode = 'x', { noremap = true } },
    { 'cxc', "<cmd>lua require('substitute.exchange').cancel()<CR>", mode = 'n', { noremap = true } },
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
    -- range = {
    --   prefix = "s",
    --   prompt_current_text = false,
    --   confirm = false,
    --   complete_word = false,
    --   subject = nil,
    --   range = nil,
    --   suffix = "",
    --   auto_apply = false,
    --   cursor_position = "end",
    -- },
    exchange = {
      motion = false,
      use_esc_to_cancel = true,
      preserve_cursor_position = false,
    },
  },
}
