vim.pack.add({
  { src = "https://github.com/nguyenvukhang/nvim-toggler" },
})

require("nvim-toggler").setup({
  -- -- your own inverses
  -- inverses = {
  --   ['vim'] = 'emacs',
  -- },
  -- removes the default <leader>i keymap
  remove_default_keybinds = true,
  -- -- removes the default set of inverses
  -- remove_default_inverses = true,
  -- -- auto-selects the longest match when there are multiple matches
  -- autoselect_longest_match = false,
})

-- "Toggle Alternative"
vim.keymap.set(
  { "n", "v" },
  "<leader>ta",
  require("nvim-toggler").toggle,
  { desc = "[T]oggle [A]lternative word" }
)
