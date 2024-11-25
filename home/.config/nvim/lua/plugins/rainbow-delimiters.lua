return {
  'https://github.com/hiphish/rainbow-delimiters.nvim',
  lazy = false,
  config = function()
    require('rainbow-delimiters.setup').setup {}
  end,
}
