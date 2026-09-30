vim.pack.add({
  { src = "https://github.com/gbprod/cutlass.nvim" },
})

require("cutlass").setup({
  cut_key = nil,
  override_del = nil,
  -- Don't override `d` / `D`: they should keep cutting into the unnamed
  -- register (and the clipboard) in normal, visual and select mode.
  exclude = { "nd", "nD", "xd", "xD", "sd" },
  registers = {
    select = "s",
    delete = "d",
    change = "c",
  },
})
