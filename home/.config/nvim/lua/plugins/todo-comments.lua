-- Highlight todo, notes, etc in comments
return {
  'https://github.com/folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'https://github.com/nvim-lua/plenary.nvim' },
  opts = {
    signs = false,
    keywords = {
      TODO = { icon = ' ', color = 'test' },
    },
    search = {
      -- regex that will be used to match keywords.
      -- don't replace the (KEYWORDS) placeholder
      pattern = [[\bTODO:]], -- ripgrep regex
      -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
    },
  },
  keys = {
    {
      '<leader>ft',
      ':TodoFzfLua<CR>',
      desc = '[F]ZF [T]ODOs',
    },
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'Next todo comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous todo comment',
    },
  },
}
