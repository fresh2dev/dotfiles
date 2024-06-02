return {
  'https://github.com/sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gD', ':DiffviewOpen<CR>', mode = 'n', desc = '[G]it [D]iff View' },
    -- { '<leader>gR', ':DiffviewFileHistory %<CR>', mode = 'n', desc = '[G]it [F]ile History for File or Selection' },
    { '<leader>gR', ':DiffviewFileHistory<CR>', mode = 'n', desc = '[G]it [F]ile History' },
  },
  opts = {
    keymaps = {
      file_panel = {
        {
          'n',
          'cc',
          '<Cmd>Git commit <bar> wincmd J<CR>',
          desc = 'Commit staged changes',
        },
        {
          'n',
          'ca',
          '<Cmd>Git commit --amend <bar> wincmd J<CR>',
          desc = 'Amend the last commit',
        },
      },
    },
  },
}
