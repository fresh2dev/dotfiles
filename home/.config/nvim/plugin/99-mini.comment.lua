vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.comment" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
})

require("ts_context_commentstring").setup({
  enable_autocmd = false,
})

require("mini.comment").setup({
  options = {
    -- Context-aware comment char (useful in Markdown docs)
    custom_commentstring = function()
      return require("ts_context_commentstring.internal").calculate_commentstring()
        or vim.bo.commentstring
    end,
  },
})
