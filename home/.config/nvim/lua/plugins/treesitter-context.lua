return {
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
  enabled = true,
  keys = {
    {
      '[T',
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      desc = 'Jump Up to Treesitter Context',
      { silent = true },
    },
    {
      '<leader>tp',
      function()
        require('treesitter-context').toggle()
      end,
      desc = '[T]oggle [P]arent Context (Treesitter Context)',
      { silent = true },
    },
  },
  opts = {
    mode = 'cursor',
    -- mode = 'topline',
    separator = '_',
    max_lines = 1,
  },
  config = function(_, opts)
    require('treesitter-context').setup(opts)
  end,
}
