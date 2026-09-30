vim.pack.add({
  { src = "https://github.com/kevinhwang91/nvim-hlslens" },
  { src = "https://github.com/haya14busa/vim-asterisk" },
})

require("hlslens").setup({
  auto_enable = true,
  enable_incsearch = true,
  calm_down = true,
  nearest_only = false,
  nearest_float_when = "never",
})

-- "Saner" n/N: `n` always searches forward and `N` always backward, regardless
-- of whether the last search was `/` or `?`, then refresh the hlslens lenses.
-- https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
local function search_motion(forward)
  return function()
    vim.schedule(require("hlslens").start)
    if (vim.v.searchforward == 1) == forward then
      return "n"
    end
    return "N"
  end
end
vim.keymap.set(
  { "n", "x", "o" },
  "n",
  search_motion(true),
  { expr = true, desc = "Jump to next match" }
)
vim.keymap.set(
  { "n", "x", "o" },
  "N",
  search_motion(false),
  { expr = true, desc = "Jump to previous match" }
)

-- Integrate with vim-asterisk. The `z` variants ("stay") set the search pattern
-- without jumping to the next match; hlslens then draws its lenses.
for _, m in ipairs({
  { "*", "z*", "Search for word under cursor" },
  { "#", "z#", "Search up for word under cursor" },
  { "g*", "gz*", "Search for subword under cursor" },
  { "g#", "gz#", "Search up for subword under cursor" },
}) do
  vim.keymap.set(
    { "n", "x" },
    m[1],
    "<Plug>(asterisk-" .. m[2] .. ")<Cmd>lua require('hlslens').start()<CR>",
    { desc = m[3] }
  )
end
