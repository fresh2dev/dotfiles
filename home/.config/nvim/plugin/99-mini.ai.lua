vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/nvim-mini/mini.extra" },
})

local MiniExtra = require("mini.extra")
MiniExtra.setup({})

local ai = require("mini.ai")

ai.setup({
  -- Table with textobject id as fields, textobject specification as values.
  -- Also use this to disable builtin textobjects. See |MiniAi.config|.
  custom_textobjects = {
    -- Make `ae` / `ie` act on around/inside *e*ntire buffer
    e = MiniExtra.gen_ai_spec.buffer(),
    -- For more complicated textobjects that require structural awareness,
    -- use tree-sitter. This example makes `aF`/`iF` mean around/inside function
    -- definition (not call). See `:h MiniAi.gen_spec.treesitter()` for details.
    F = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
  },

  -- Number of lines within which textobject is searched
  n_lines = 500,

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Main textobject prefixes
    around = "a",
    inside = "i",
    -- Next/last variants
    around_next = "", -- 'an',
    inside_next = "", -- 'in',
    around_last = "", -- 'al',
    inside_last = "", -- 'il',
    -- Move cursor to corresponding edge of `a` textobject
    goto_left = "g[",
    goto_right = "g]",
  },
})
