-- Highlight todo, notes, etc in comments
return {
  'https://github.com/folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'https://github.com/nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
    highlight = {
      pattern = '.*<(KEYWORDS):', -- pattern or table of patterns, used for highlighting (vim regex)
      before = 'fg', -- "fg" or "bg" or empty
      keyword = 'wide', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = 'fg', -- "fg" or "bg" or empty
    },
    keywords = {
      TODO = { icon = '☐ ', color = 'warning' },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    },
    gui_style = {
      fg = 'NONE', -- The gui style to use for the fg highlight group.
      bg = 'BOLD', -- The gui style to use for the bg highlight group.
    },
    merge_keywords = true, -- when true, custom keywords will be merged with the defaults

    search = {
      args = {
        '--color=never',
        '--case-sensitive',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
      },
      -- regex that will be used to match keywords.
      -- pattern = [[\bTODO(:|!)]], -- ripgrep regex
      -- Highlight various types, but only include 'TODO'
      -- in search results.
      pattern = [[\bTODO:]], -- ripgrep regex
    },
  },
  keys = {
    {
      '<leader>fm',
      '<Cmd>TodoFzfLua keywords=TODO<CR>',
      desc = '[F]ZF [M]arks (TODOs)',
    },
    {
      'gm',
      '<Cmd>TodoQuickFix keywords=TODO<CR>',
      desc = '[F]ZF [M]arks (TODOs)',
    },
    {
      'mc',
      'm`O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>',
      desc = 'Mark with TODO comment',
    },
    {
      'mm',
      'm`O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>TODO: <esc>``',
      desc = 'Mark with TODO comment',
    },
    {
      'mi',
      'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>TODO: ',
      desc = 'Mark with TODO comment',
    },
    {
      'mn',
      'O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>NOTE: ',
      desc = 'Mark with NOTE comment',
    },
    {
      'm.',
      function()
        require('todo-comments').jump_next { keywords = { 'TODO' } }
      end,
      desc = 'Next todo comment',
    },
    {
      'm,',
      function()
        require('todo-comments').jump_prev { keywords = { 'TODO' } }
      end,
      desc = 'Previous todo comment',
    },
  },
}
