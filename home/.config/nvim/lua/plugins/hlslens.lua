-- Show virtual text next to search matches.
return {
  'https://github.com/kevinhwang91/nvim-hlslens',
  lazy = false,
  keys = {
    { 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], desc = 'Jump to next match' },
    { 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], desc = 'Jump to prev match' },
    -- Integrate with vim-asterisk
    { '*', [[<Plug>(asterisk-*)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search for word under cursor', mode = { 'n', 'x' } },
    { '#', [[<Plug>(asterisk-#)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search up for word under cursor', mode = { 'n', 'x' } },
    { 'g*', [[<Plug>(asterisk-g*)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search for subword under cursor', mode = { 'n', 'x' } },
    { 'g#', [[<Plug>(asterisk-g#)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search up for subword under cursor', mode = { 'n', 'x' } },
    { 'z*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search for word under cursor', mode = { 'n', 'x' } },
    { 'gz*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search for subword under cursor', mode = { 'n', 'x' } },
    { 'z#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search up for word under cursor', mode = { 'n', 'x' } },
    { 'gz#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], desc = 'Search up for subword under cursor', mode = { 'n', 'x' } },
  },
  config = function()
    require('hlslens').setup {
      auto_enable = true,
      enable_incsearch = true,
      calm_down = true,
      nearest_only = false,
      nearest_float_when = 'never',
    }
  end,
}
