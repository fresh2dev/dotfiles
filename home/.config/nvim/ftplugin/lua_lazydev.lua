-- Runs for every Lua buffer; the install + setup below must only happen once.
if vim.g.loaded_lazydev_config then
  return
end
vim.g.loaded_lazydev_config = true

vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

require("lazydev").setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
