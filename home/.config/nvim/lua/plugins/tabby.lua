-- Simple tabline, customized to only show tab #.
return {
  'nanozuki/tabby.nvim',
  lazy = false,
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bg = 'black'

    local theme = {
      current = { fg = '#cad3f5', bg = bg, style = 'bold' },
      not_current = { fg = '#5b6078', bg = bg },

      fill = { bg = bg },
    }

    require('tabby.tabline').set(function(line)
      return {
        hl = theme.fill,
        line.spacer(),
        line.tabs().foreach(function(tab)
          local hl = tab.is_current() and theme.current or theme.not_current
          return {
            line.sep(' ', hl, theme.fill),
            tab.number(),
            line.sep(' ', hl, theme.fill),
            hl = hl,
          }
        end),
        line.spacer(),
      }
    end)
  end,
}
