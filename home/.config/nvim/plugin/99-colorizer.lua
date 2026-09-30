vim.pack.add({
  { src = "https://github.com/catgoose/nvim-colorizer.lua" },
})
-- The above is a fork of the original, unmaintained: norcalli/nvim-colorizer.lua

require("colorizer").setup({
  filetypes = {
    "css",
    "javascript",
    html = {
      mode = "foreground",
    },
  },
})

vim.keymap.set(
  "n",
  "<leader>tc",
  "<Cmd>ColorizerToggle<CR>",
  { desc = "[T]oggle HTML [C]olorizer" }
)
