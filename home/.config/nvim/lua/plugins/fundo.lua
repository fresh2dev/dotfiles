return {
  'kevinhwang91/nvim-fundo',
  requires = 'kevinhwang91/promise-async',
  config = function()
    vim.o.undofile = true
    local fundo = require 'fundo'
    fundo.install()
    fundo.setup()
  end,
}
