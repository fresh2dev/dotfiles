vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
})

vim.keymap.set("n", "[T", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Jump Up to Treesitter Context", silent = true })

require("treesitter-context").setup({
  mode = "cursor",
  -- mode = 'topline',
  separator = "_",
  max_lines = 1,
})
