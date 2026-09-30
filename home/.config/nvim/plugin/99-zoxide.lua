vim.pack.add({
  { src = "https://github.com/nanotee/zoxide.vim" },
})

vim.g.zoxide_use_select = 1

-- Set `z` / `zi` as an abbreviation for `Z` / `Zi` in command mode
require("util").cabbrev("z", "Z")
require("util").cabbrev("zi", "Zi")

vim.keymap.set("n", "<leader>zi", "<Cmd>Zi<CR>", { desc = "[Z]oxide [I]nteractive cd" })
