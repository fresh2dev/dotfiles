return {  -- Cutlass overrides the delete operations to actually just delete and not affect the current yank.
  "gbprod/cutlass.nvim",
  lazy = false,
  opts = {
    cut_key = "m",
    override_del = true,
    exclude = {},
    registers = {
      select = "_",
      delete = "_",
      change = "_",
    },
  },
}
