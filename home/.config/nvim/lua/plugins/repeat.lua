return {
  { 'tpope/vim-repeat', lazy = false, opt = {} },
  { 'tpope/vim-sensible', lazy = false, opt = {} },
  { 'tpope/vim-unimpaired', lazy = false, opt = {} },
  { 'tpope/vim-eunuch', lazy = false, opt = {} },
  {
    'rbong/vim-flog',
    lazy = false,
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
    keys = {
      { '<leader>gd', ':DiffviewOpen<CR>', mode = 'n', desc = '[G]it [D]iff View' },
      { '<leader>gg', ":exec 'Flog' | topleft Git<CR>", mode = 'n', desc = '[G]it' },
      { '<leader>gs', ':Git<CR>', mode = 'n', desc = '[G]it [S]status' },
      { '<leader>gl', ':Flogsplit<CR>', mode = 'n', desc = '[G]it [L]og' },
      { '<leader>gh', ':DiffviewFileHistory %<CR>', mode = 'n', desc = '[G]it [H]istory for File or Selection' },
    },
    dependencies = {
      {
        -- 'junegunn/gv.vim',
        -- cmd = 'GV',
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
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
              {
                'n',
                'c<space>',
                ':Git commit ',
                desc = 'Populate command line with ":Git commit "',
              },
            },
          },
        },
        dependencies = {
          'tpope/vim-fugitive',
          cmd = {
            'G',
            'Git',
          },
          config = function()
            vim.g.fugitive_no_maps = 1
            vim.g.fugitive_legacy_commands = 0
          end,
        },
      },
    },
  },
}
