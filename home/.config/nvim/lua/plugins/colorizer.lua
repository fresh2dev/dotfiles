-- A high-performance color highlighter for Neovim
return {
  'http://github.com/norcalli/nvim-colorizer.lua',
  lazy = true,
  keys = {
    { '<leader>thc', ':ColorizerToggle<CR>', mode = 'n', desc = '[T]oggle HTML [C]olorizer' },
  },
  cmd = { 'ColorizerToggle' },
}
