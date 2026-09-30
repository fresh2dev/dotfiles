-- Simple tabline, customized to only show tab #.
vim.pack.add({
  { src = "https://github.com/nanozuki/tabby.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

-- Colours come from the active colorscheme's tabline groups.
local theme = {
  current = "TabLineSel",
  not_current = "TabLine",
  fill = "TabLineFill",
}

require("tabby.tabline").set(function(line)
  return {
    hl = theme.fill,
    line.spacer(),
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current or theme.not_current
      return {
        line.sep(" ", hl, theme.fill),
        tab.number(),
        line.sep(" ", hl, theme.fill),
        hl = hl,
      }
    end),
    line.spacer(),
  }
end)
