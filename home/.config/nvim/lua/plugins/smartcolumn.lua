-- Hide the colorcolumn when no line exceeds the length.
return {
  'm4xshen/smartcolumn.nvim',
  opts = {
    scope = 'file',
    colorcolumn = '0',
    custom_colorcolumn = {
      python = '88',
    },
  },
}
