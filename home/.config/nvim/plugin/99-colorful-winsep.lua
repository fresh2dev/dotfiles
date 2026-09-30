vim.pack.add({
  { src = "https://github.com/nvim-zh/colorful-winsep.nvim" },
})

require("colorful-winsep").setup({
  animate = {
    enabled = false,
  },
})
