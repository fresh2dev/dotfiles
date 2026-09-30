vim.pack.add({
  { src = "https://github.com/haya14busa/vim-edgemotion" },
})

-- gj/gk: jump to the next edge (indent change or blank-line boundary) below/above
-- NOTE: plain `j`/`k` without a count already move by *visual* line (init.lua),
-- so the builtin `gj`/`gk` are free to be repurposed here.
vim.keymap.set(
  { "n", "x", "o" },
  "gj",
  "<Plug>(edgemotion-j)",
  { desc = "Next edge below" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "gk",
  "<Plug>(edgemotion-k)",
  { desc = "Next edge above" }
)
