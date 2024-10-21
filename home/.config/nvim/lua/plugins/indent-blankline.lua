return {
  { -- Add indentation guides even on blank lines
    'https://github.com/lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "mason",
          "notify",
        },
      },
    },
  },
}