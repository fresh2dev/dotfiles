return {
  {
    'jghauser/fold-cycle.nvim',
    event = 'BufEnter',
    keys = {
      { 'zl', "<cmd>lua require('fold-cycle').open()<CR>", mode = 'n', { silent = true } },
      -- { 'zj', "<cmd>lua require('fold-cycle').open()<CR>", mode = 'n', { silent = true } },
      { 'zh', "<cmd>lua require('fold-cycle').close()<CR>", mode = 'n', { silent = true } },
      -- { 'zk', "<cmd>lua require('fold-cycle').close()<CR>", mode = 'n', { silent = true } },
    },
    opts = {
      open_if_max_closed = false, -- closing a fully closed fold will open it
      close_if_max_opened = false, -- opening a fully open fold will close it
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    lazy = false,
    dependencies = {
      { 'kevinhwang91/promise-async' },
    },
    config = function()
      vim.o.foldcolumn = '3' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
  },
}
