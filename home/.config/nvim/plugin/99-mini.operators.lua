vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.operators" },
})

local operators = require("mini.operators")

operators.setup({
  -- No need to copy this inside `setup()`. Will be used automatically.
  -- Each entry configures one operator.
  -- `prefix` defines keys mapped during `setup()`: in Normal mode
  -- to operate on textobject and line, in Visual - on selection.

  -- Evaluate text and replace with output
  evaluate = {
    prefix = "", -- DISABLE

    -- Function which does the evaluation
    func = nil,
  },

  -- Exchange text regions. Mapped manually below (`cx` in normal mode, `X` in
  -- visual mode) because a visual-mode `cx` makes `c` wait for 'timeoutlen'.
  exchange = {
    prefix = "",

    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },

  -- Multiply (duplicate) text
  multiply = {
    prefix = "gm",

    -- Function which can modify text before multiplying
    func = nil,
  },

  -- Replace text with register
  replace = {
    -- NOTE: Default `gr*` LSP mappings are removed
    prefix = "<leader>p",

    -- Whether to reindent new text to match previous indent
    reindent_linewise = true,
  },

  -- Sort text
  sort = {
    prefix = "", -- DISABLE

    -- Function which does the sort
    func = nil,
  },
})

-- Exchange: `cx{motion}` / `cxx` in normal mode, `X` on a visual selection.
-- Not `cx` in visual mode: cutlass maps visual `c`, so a visual `cx` would make
-- every visual `c` pause for 'timeoutlen' before changing the text. Visual `X`
-- shadows cutlass's linewise delete (`"dX`); use `D` or `d` for that instead.
operators.make_mappings("exchange", {
  textobject = "cx",
  line = "cxx",
  selection = "X",
})

-- Replace to end of line: `<leader>P` is to `<leader>p` what `D`/`C` are to `d`/`c`.
vim.keymap.set("n", "<leader>P", "<leader>p$", {
  remap = true,
  desc = "Replace to end of line",
})
