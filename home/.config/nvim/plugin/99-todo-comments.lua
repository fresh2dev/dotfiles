vim.pack.add({
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})

require("todo-comments").setup({
  signs = false,
  highlight = {
    pattern = ".*<(KEYWORDS):", -- pattern or table of patterns, used for highlighting (vim regex)
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = "fg", -- "fg" or "bg" or empty
  },
  keywords = {
    TODO = { icon = "☐ ", color = "warning" },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  gui_style = {
    fg = "NONE", -- The gui style to use for the fg highlight group.
    bg = "BOLD", -- The gui style to use for the bg highlight group.
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults

  search = {
    args = {
      "--color=never",
      "--case-sensitive",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- pattern = [[\bTODO(:|!)]], -- ripgrep regex
    -- Highlight various types, but only include 'TODO'
    -- in search results.
    pattern = [[\bTODO:]], -- ripgrep regex
  },
})
