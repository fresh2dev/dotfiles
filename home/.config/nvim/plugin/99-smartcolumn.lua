-- Hides the colorcolumn when unneeded.
vim.pack.add({
  { src = "https://github.com/m4xshen/smartcolumn.nvim" },
})

require("smartcolumn").setup({
  scope = "file",
  colorcolumn = "0",
  custom_colorcolumn = {
    python = "88",
  },
})
