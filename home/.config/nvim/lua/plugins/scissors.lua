return {
  'https://github.com/chrisgrieser/nvim-scissors',
  keys = {
    -- Add Snippet with `Y` during visual selection.
    {
      'Y',
      function()
        require('scissors').addNewSnippet()
      end,
      mode = { 'x' },
      desc = 'Add Snippet',
    },
    {
      '<leader>fY',
      function()
        require('scissors').editSnippet()
      end,
      mode = { 'n' },
      desc = 'Edit Snippet',
    },
  },
  config = function()
    require('scissors').setup {
      snippetDir = vim.fn.stdpath 'config' .. '/snippets',
      jsonFormatter = 'jq',
      editSnippetPopup = {
        height = 0.4, -- relative to the window, between 0-1
        width = 0.6,
        border = 'rounded',
        keymaps = {
          cancel = 'q',
          saveChanges = '<leader>w', -- alternatively, can also use `:w`
          goBackToSearch = '<BS>',
          deleteSnippet = '<C-BS>',
          duplicateSnippet = '<C-d>',
          openInFile = '<C-o>',
          insertNextPlaceholder = '<C-p>', -- insert & normal mode
        },
      },
    }
  end,
}
