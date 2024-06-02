return {
  'https://github.com/MagicDuck/grug-far.nvim',
  keys = {
    {
      '<leader>fr',
      function()
        require('grug-far').open {}
      end,
      mode = { 'n' },
      desc = '[F]ind and [R]eplace',
    },
    {
      '<leader>fr',
      function()
        require('grug-far').open { startCursorRow = 4 } -- Start with cursor in in 'Replace' row.
      end,
      mode = { 'v' },
      desc = '[F]ind and [R]eplace Selection',
    },
    {
      '<leader>fR',
      function()
        require('grug-far').open { windowCreationCommand = 'tab split' }
      end,
      mode = { 'n' },
      desc = '[F]ind and [R]eplace in New Tab',
    },
    {
      '<leader>fR',
      function()
        require('grug-far').open { windowCreationCommand = 'tab split', startCursorRow = 4 } -- Start with cursor in in 'Replace' row.
      end,
      mode = { 'v' },
      desc = '[F]ind and [R]eplace in New Tab',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
      pattern = { 'grug-far' },
      callback = function()
        -- Go to entry and close Grug.
        vim.api.nvim_buf_set_keymap(0, 'n', 'gf', 'H<localleader>qq', {})
        -- Populate quickfix and close Grug.
        vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>l', '<localleader>L<localleader>qq', {})
      end,
    })

    -- -- Always move to bottom
    -- vim.api.nvim_create_autocmd('WinEnter', {
    --   pattern = '*',
    --   callback = function()
    --     if vim.bo.filetype == 'grug-far' then
    --       vim.cmd 'wincmd J'
    --     end
    --   end,
    -- })
  end,
  opts = {
    maxWorkers = 1,
    startInInsertMode = true,
    transient = true,
    -- normalModeSearch = true,
    windowCreationCommand = 'botright split',
    engines = {
      ripgrep = {
        -- ripgrep executable to use, can be a different path if you need to configure
        path = 'rg',
        -- whether to show diff of the match being replaced as opposed to just the
        -- replaced result. It usually makes it easier to understand the change being made
        -- Disabled because it showed inaccurate diffs (commit=f47594f05d10b0bedfc0ed78e488e7fd714d57be)
        showReplaceDiff = false,
      },
    },
    keymaps = {
      replace = { n = '<localleader>R' },
      qflist = { n = '<localleader>L' },
      syncLocations = false,
      syncLine = false,
      close = { n = '<localleader>qq' },
      historyOpen = { n = '<localleader>h' },
      historyAdd = { n = '<localleader>H' },
      refresh = { n = '<F5>' },
      openLocation = { n = 'H' },
      openNextLocation = { n = ']q' },
      openPrevLocation = { n = '[q' },
      gotoLocation = { n = '<enter>' },
      pickHistoryEntry = { n = '<enter>' },
      abort = { n = '<localleader>A' },
      help = { n = 'g?' },
      toggleShowCommand = { n = '<localleader>c' },
      swapEngine = false,
      previewLocation = { n = 'K' },
      swapReplacementInterpreter = false,
    },
  },
}
