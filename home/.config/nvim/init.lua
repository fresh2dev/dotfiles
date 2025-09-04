local myvimrc_path = os.getenv 'MYVYMRC' or '~/.vimrc'
vim.cmd('source ' .. myvimrc_path)

local enabled_in_vscode = {
  'dial.nvim',
  'flit.nvim',
  'lazy.nvim',
  'leap.nvim',
  'mini.basics',
  'mini.ai',
  'mini.comment',
  'mini.move',
  'mini.splitjoin',
  'mini.pairs',
  'mini.surround',
  'nvim-autopairs',
  'rainbow-delimiters.nvim',
  'nvim-treesitter',
  'nvim-treesitter-textobjects',
  'nvim-ts-context-commentstring',
  'snacks.nvim',
  'vim-textobj-user',
  'vim-textobj-entire',
  'vim-textobj-variable-segment',
  'substitute.nvim',
  'ts-comments.nvim',
  'vim-repeat',
  'yanky.nvim',
}

if vim.g.vscode then
  -- Add some vscode specific keymaps
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LazyVimKeymapsDefaults',
    callback = function()
      -- TODO: add file/grep related mappings
      -- -- VSCode-specific keymaps for search and navigation
      -- vim.keymap.set('n', '<leader><space>', '<cmd>Find<cr>')
      -- vim.keymap.set('n', '<leader>/', [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
      -- vim.keymap.set('n', '<leader>ss', [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

      -- Keep undo/redo lists in sync with VsCode
      vim.keymap.set('n', 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
      vim.keymap.set('n', '<C-r>', "<Cmd>call VSCodeNotify('redo')<CR>")

      -- -- Navigate VSCode tabs like lazyvim buffers
      -- vim.keymap.set('n', '<S-h>', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
      -- vim.keymap.set('n', '<S-l>', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
    end,
  })
end

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
  defaults = {
    -- Set this to `true` to have all your plugins lazy-loaded by default.
    -- Only do this if you know what you are doing, as it can lead to unexpected behavior.
    lazy = false, -- should plugins be lazy-loaded?
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = nil, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
    -- default `cond` you can use to globally disable a lot of plugins
    -- when running inside vscode for example
    cond = function(plugin)
      return not vim.g.vscode or plugin.vscode or vim.tbl_contains(enabled_in_vscode, plugin.name)
    end,
  },
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
    -- colorscheme = { 'catppuccin_macchiato' },
    colorscheme = { 'carbonfox' },
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
