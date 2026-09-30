vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.surround" },
})

require("mini.surround").setup({
  custom_surroundings = {
    -- Surround in triple backticks (markdown code block)
    c = { input = { "```\n().-()\n```" }, output = { left = "```\n", right = "\n```" } },
  },

  highlight_duration = 500,

  -- Map as is done in tpope/vim-surround
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",

    suffix_last = "",
    suffix_next = "",
  },

  -- Number of lines within which surrounding is searched
  n_lines = 25,

  -- Whether to respect selection type:
  -- - Place surroundings on separate lines in linewise mode.
  -- - Place surroundings on each line in blockwise mode.
  respect_selection_type = false,

  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
  -- see `:h MiniSurround.config`.
  search_method = "cover",

  -- Whether to disable showing non-error feedback
  silent = false,
})

-- Remap adding surrounding to Visual mode selection.
-- Must be a `:<C-u>` command mapping, not a Lua callback: the command leaves
-- Visual mode first, which is what updates the `'<`/`'>` marks that
-- `MiniSurround.add("visual")` reads. Calling it from a callback while still
-- in Visual mode reads the previous selection's marks (possibly out of range).
vim.keymap.del("x", "ys")
vim.keymap.set(
  "x",
  "S",
  [[:<C-u>lua MiniSurround.add("visual")<CR>]],
  { silent = true, desc = "Surround selection" }
)

-- Make special mapping for "add surrounding for line"
vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })
