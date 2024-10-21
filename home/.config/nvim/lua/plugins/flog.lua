return {
  'rbong/vim-flog',
  lazy = true,
  cmd = { 'Flog', 'Flogsplit', 'Floggit' },
  dependencies = {
    'tpope/vim-fugitive',
  },
  keys = {
    { '<leader>gg', ':Git | exec "vertical Flogsplit" | wincmd p | normal i<CR>', desc = '' },
    { '<leader>gt', ':tabnew | 0Git | exec "Flogsplit" | wincmd p | normal i<CR>"', desc = '' },
    { '<leader>go', ':only | 0Git | exec "Flogsplit" | wincmd p | normal i<CR>', desc = '' },
    { '<leader>gO', ':%bd | 0Git | exec "Flogsplit" | wincmd p | normal i<CR>', desc = '' },
  },
  init = function()
    vim.g.flog_permanent_default_opts = {
      -- date = 'short',
      format = '[%h]%d %s',
    }
  end,
}
