return {
  'rbong/vim-flog',
  lazy = true,
  cmd = { 'Flog', 'Flogsplit', 'Floggit' },
  dependencies = {
    'tpope/vim-fugitive',
  },
  keys = {
    { '<leader>gg', ':Git | exec "vertical Flogsplit" | wincmd p | :5<CR>', desc = '' },
    { '<leader>gt', ':tabnew | 0Git | exec "Flogsplit" | wincmd p | :5<CR>"', desc = '' },
    { '<leader>go', ':only | 0Git | exec "Flogsplit" | wincmd p | :5<CR>', desc = '' },
    { '<leader>gO', ':%bd | 0Git | exec "Flogsplit" | wincmd p | :5<CR>', desc = '' },
  },
  init = function()
    vim.g.flog_permanent_default_opts = { date = 'short' }
  end,
}
