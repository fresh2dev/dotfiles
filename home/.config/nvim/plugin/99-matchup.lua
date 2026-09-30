vim.pack.add({
  { src = "https://github.com/andymass/vim-matchup" },
})

vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_hi_surround_always = 1
vim.g.matchup_motion_override_Npercent = 100
vim.g.matchup_treesitter_disable_virtual_text = true

require("match-up").setup({})
