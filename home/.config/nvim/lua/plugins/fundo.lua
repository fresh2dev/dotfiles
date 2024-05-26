return { -- Forever Undo
  'kevinhwang91/nvim-fundo',
  event = 'BufEnter',
  dependencies = {
    { 'kevinhwang91/promise-async' },
  },
  build = function()
    require('fundo').install()
  end,
  config = function()
    vim.o.undofile = true
    require('fundo').setup()
  end,
}
