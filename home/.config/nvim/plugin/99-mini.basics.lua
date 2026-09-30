vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.basics" },
})

require("mini.basics").setup({
  options = {
    basic = false,
    extra_ui = false,
    win_borders = "bold",
  },
  mappings = {
    basic = false,
    option_toggle_prefix = "",
    move_with_alt = false,
    -- Create `<C-hjkl>` mappings for window navigation
    windows = true,
  },
  autocommands = {
    basic = false,
    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = true,
  },
  -- Whether to disable showing non-error feedback
  silent = true,
})
