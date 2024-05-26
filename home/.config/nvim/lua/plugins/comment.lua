-- "gc" to comment visual regions/lines
return {
  'JoosepAlviste/nvim-ts-context-commentstring',  -- Sets a context-specific commentstring.
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        pre_hook = function()
          return vim.bo.commentstring
        end,
      }
    end,
  },
}
