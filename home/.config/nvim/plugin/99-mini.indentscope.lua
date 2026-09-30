vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.indentscope" },
})

local MiniIndentscope = require("mini.indentscope")

MiniIndentscope.setup({
  -- NOTE: `ii`/`ai` text objects are configured to behave like
  -- 'michaeljsmith/vim-indent-object' (which is not installed).
  -- Draw options
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    -- Animation rule for scope's first drawing. A function which, given
    -- next and total step numbers, returns wait time (in ms). See
    -- |MiniIndentscope.gen_animation| for builtin options. To disable
    -- animation, use `require('mini.indentscope').gen_animation.none()`.
    animation = MiniIndentscope.gen_animation.none(),
    -- Symbol priority. Increase to display on top of more symbols.
    priority = 2,
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = "ii",
    object_scope_with_border = "ai",
    -- Motions (jump to respective border line; if not present - body line)
    -- goto_top = '[i',
    -- goto_bottom = ']i',
    goto_top = "g<",
    goto_bottom = "g>",
  },
  -- Options which control scope computation
  options = {
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
    -- border = 'both',
    -- Whether to use cursor column when computing reference indent.
    -- Useful to see incremental scopes with horizontal cursor movements.
    indent_at_cursor = false,
    -- Whether to first check input line to be a border of adjacent scope.
    -- Use it if you want to place cursor on function header to get scope of
    -- its body.
    try_as_border = false,
  },
  -- Which character to use for drawing scope indicator
  symbol = "╎",
})
