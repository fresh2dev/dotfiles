vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.map" },
})

local MiniMap = require("mini.map")
MiniMap.setup({
  width = 5,
  integrations = {
    MiniMap.gen_integration.builtin_search(),
    MiniMap.gen_integration.diff(),
    -- MiniMap.gen_integration.diagnostic(),
  },
  symbols = {
    encode = MiniMap.gen_encode_symbols.dot("4x2"),
  },
})

vim.api.nvim_create_autocmd({ "WinEnter", "FileType" }, {
  pattern = "*",
  callback = function()
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local excluded_filetypes =
      { "help", "quickfix", "nofile", "terminal", "ministarter" }

    if buftype == "" and not vim.tbl_contains(excluded_filetypes, filetype) then
      MiniMap.open()
    else
      MiniMap.close()
    end
  end,
})

vim.api.nvim_create_autocmd("WinClosed", {
  callback = MiniMap.refresh,
})

-- Auto-close minimap if cursor is near the edge
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local width = vim.api.nvim_win_get_width(0)
    if width - col < 20 then
      MiniMap.close()
    else
      MiniMap.open()
    end
  end,
})
