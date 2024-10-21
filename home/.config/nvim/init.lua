-- TODO: make the vimrc file path variable.
local myvimrc_path = os.getenv 'MYVYMRC' or '~/.vimrc'
vim.cmd 'source ~/.vimrc'

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  { import = 'components/' },
  { import = 'plugins/' },
}, {
  root = vim.fn.stdpath 'data' .. '/lazy', -- directory where plugins will be installed
  lockfile = vim.fn.stdpath 'config' .. '/lazy-lock.json', -- lockfile generated after running update.
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.fn.stdpath 'data' .. '/plugged',
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { 'catppuccin_macchiato' },
  },
  ui = {
    custom_keys = {
      -- You can define custom key maps here. If present, the description will
      -- be shown in the help menu.
      -- To disable one of the defaults, set it to false.
      ['<localleader>l'] = false,
      ['<localleader>t'] = false,
    },
  },
})
