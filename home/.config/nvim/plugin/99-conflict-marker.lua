vim.pack.add({
  { src = "https://github.com/rhysd/conflict-marker.vim" },
})

vim.g.conflict_marker_enable_mappings = 0

vim.keymap.set("n", "]x", "<Cmd>ConflictMarkerNextHunk<CR>", { desc = "Next conflict" })
vim.keymap.set(
  "n",
  "[x",
  "<Cmd>ConflictMarkerPrevHunk<CR>",
  { desc = "Previous conflict" }
)
