return {
  'GeorgesAlkhouri/nvim-aider',
  dependencies = {
    'folke/snacks.nvim',
  },
  cmd = {
    'AiderTerminalToggle',
    'AiderHealth',
  },
  keys = {
    { '<leader>a`', '<cmd>AiderTerminalToggle<cr>', desc = 'Open Aider' },
    -- { '<leader>as', '<cmd>AiderTerminalSend<cr>', desc = 'Send to Aider', mode = { 'n', 'v' } },
    {
      '<leader>ai',
      function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
        vim.cmd 'AiderQuickAddFile'
      end,
      desc = 'Add to Aider',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aI',
      function()
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
        vim.cmd 'AiderTerminalSend /clear'
        vim.cmd 'AiderQuickAddFile'
        vim.cmd("AiderTerminalSend Address each TODO comment in the file '" .. filename .. "' and remove comment once addressed.")
      end,
      desc = 'Address TODOs in Aider',
      mode = { 'n', 'v' },
    },
    { '<leader>a/', '<cmd>AiderQuickSendCommand<cr>', desc = 'Send Command To Aider' },
    -- { '<leader>ab', '<cmd>AiderQuickSendBuffer<cr>', desc = 'Send Buffer To Aider' },
    { '<leader>aa', '<cmd>AiderQuickAddFile<cr>', desc = 'Add File to Aider' },
    { '<leader>ad', '<cmd>AiderQuickDropFile<cr>', desc = 'Drop File from Aider' },
    { '<leader>ar', '<cmd>AiderQuickReadOnlyFile<cr>', desc = 'Add File as Read-Only' },
    -- -- Example nvim-tree.lua integration if needed
    -- { '<leader>a+', '<cmd>AiderTreeAddFile<cr>', desc = 'Add File from Tree to Aider', ft = 'NvimTree' },
    -- { '<leader>a-', '<cmd>AiderTreeDropFile<cr>', desc = 'Drop File from Tree from Aider', ft = 'NvimTree' },
  },
  config = true,
}
