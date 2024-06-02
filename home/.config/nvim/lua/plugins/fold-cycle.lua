return {
  {
    'https://github.com/jghauser/fold-cycle.nvim',
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
    'https://github.com/kevinhwang91/nvim-ufo',
    version = 'v1',
    lazy = false,
    keys = {
      { 'zc' },
      { 'zo' },
      { 'zC' },
      { 'zO' },
      { 'za' },
      { 'zA' },
      {
        'zr',
        function()
          require('ufo').openFoldsExceptKinds()
        end,
        desc = 'Open Folds Except Kinds',
      },
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open All Folds',
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close All Folds',
      },
      {
        'zm',
        function()
          require('ufo').closeFoldsWith()
        end,
        desc = 'Close Folds With',
      },
      {
        'zp',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = 'Peek Fold',
      },
    },
    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      }
    end,
    dependencies = {
      { 'https://github.com/kevinhwang91/promise-async' },
      {
        'https://github.com/luukvbaal/statuscol.nvim',
        lazy = false,
        opts = function()
          local builtin = require 'statuscol.builtin'
          return {
            ft_ignore = { 'help', 'vim', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'fugitive', 'toggleterm' },
            bt_ignore = nil, -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            -- Default segments (fold -> sign -> line number + separator), explained below
            segments = {
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          }
        end,
      },
    },
  },
}
