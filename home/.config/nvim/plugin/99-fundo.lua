vim.pack.add({
  { src = "https://github.com/kevinhwang91/nvim-fundo" },
  { src = "https://github.com/kevinhwang91/promise-async" },
})

-- NOTE: 'undofile' is enabled in init.lua; fundo only makes it persistent.
local fundo = require("fundo")
fundo.install()
fundo.setup({
  -- Limit the archives directory size, unit is MB(megabyte), elder files will be removed based on their modified time
  limit_archives_size = 512,
})
