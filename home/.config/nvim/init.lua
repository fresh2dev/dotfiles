vim.cmd 'source ~/.vimrc'

local pythonpath = vim.fn.stdpath 'data' .. '/python'
vim.g.python3_host_prog = pythonpath .. '/bin/python'

if not (vim.uv or vim.loop).fs_stat(pythonpath) then
  print 'Setting up Python environment...'
  vim.fn.system {
    'python',
    '-m',
    'venv',
    pythonpath,
  }
  print 'Installing Python packages...'
  vim.fn.system {
    vim.g.python3_host_prog,
    '-m',
    'pip',
    'install',
    'pynvim',
  }
end

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=v10.20.3', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

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

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = 'multispace:·,lead:·,trail:·,tab:»·,extends:→,precedes:←,nbsp:␣'
-- ,eol:↲
vim.opt.list = true

-- Require 24-bit colors (required by "fancy" UI plugins)
vim.opt.termguicolors = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Disable nvim "editorconfig" feature to resolve this issue
-- that it introduces with `vim-symlink`.
-- ref: https://github.com/aymericbeaumet/vim-symlink/issues/14
vim.g.editorconfig = false

-- Open terminal in insert-mode.
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function()
    if vim.opt.buftype:get() == 'terminal' then
      vim.cmd ':startinsert'
    end
  end,
})

-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = 'Visual', timeout = 500 }
  end,
})
