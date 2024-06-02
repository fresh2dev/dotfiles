return {
  'https://github.com/ThePrimeagen/refactoring.nvim',
  dependencies = {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>cev',
      function()
        require('refactoring').refactor 'Extract Variable'
      end,
      mode = 'x',
      desc = '[C]ode: [E]xtract [V]ariable',
    },
    {
      '<leader>cef',
      function()
        require('refactoring').refactor 'Extract Function'
      end,
      mode = 'x',
      desc = '[C]ode: [E]xtract [F]unction',
    },
    -- {
    --   '<leader>rr',
    --   function()
    --     require('refactoring').select_refactor()
    --   end,
    --   mode = { 'n', 'x' },
    --   desc = '[R]efactor',
    -- },
  },
  opts = {},
}
