vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    relative = "cursor",
    anchor = "NW",
    row = -5,
    col = 1,
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next", { preview = true, target = "all" })
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev", { preview = true, target = "all" })
      end
    end)

    -- Hunk actions live under the `<leader>gh` group (see 99-which-key.lua) so
    -- they don't shadow the global fugitive `<leader>g*` maps.
    map("n", "<leader>ghs", gitsigns.stage_hunk, { desc = "[G]it [H]unk [S]tage" })
    map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "[G]it [H]unk [R]eset" })
    map(
      "n",
      "<leader>ghu",
      gitsigns.undo_stage_hunk,
      { desc = "[G]it [H]unk [U]ndo stage" }
    )
    map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "[G]it [H]unk [P]review" })
    map("x", "<leader>ghs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "[G]it [H]unk [S]tage selection" })
    map("x", "<leader>ghr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "[G]it [H]unk [R]eset selection" })
  end,
})
