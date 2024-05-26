return { -- flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
  'folke/flash.nvim',
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  opts = {
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        -- when `true`, flash will be activated during regular search by default.
        -- You can always toggle when searching with `require("flash").toggle()`
        enabled = false,
      },
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = false,
      },
    },
  },
}
