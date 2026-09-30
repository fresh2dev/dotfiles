-- Adds indentation guides even on blank lines
vim.pack.add({
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
})

require("ibl").setup({})
