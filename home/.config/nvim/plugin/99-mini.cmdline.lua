vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.cmdline" },
})

require("mini.cmdline").setup({
  -- Autocompletion: show `:h 'wildmenu'` as you type
  autocomplete = {
    enable = false,
  },

  -- Autocorrection: adjust non-existing words (commands, options, etc.)
  autocorrect = {
    enable = false,
  },

  -- Autopeek: show command's target range in a floating window
  autopeek = {
    enable = true,

    -- Number of lines to show above and below range lines
    n_context = 6,

    -- Custom rule of when to show peek window
    predicate = nil,

    -- Window options
    window = {
      -- Floating window config
      config = {},

      -- Function to render statuscolumn
      statuscolumn = nil,
    },
  },
})
