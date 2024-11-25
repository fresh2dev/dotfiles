return {
  {
    'https://github.com/akinsho/toggleterm.nvim',
    version = '*',
    lazy = false,
    keys = {
      [[<c-t>]],
      { '<leader>`', ':ToggleTerm<CR>', mode = 'n', desc = '[T]oggle [T]erminal' },
      { '<C-h>', [[<Cmd>wincmd h<CR>]], mode = 't' },
      { '<C-j>', [[<Cmd>wincmd j<CR>]], mode = 't' },
      { '<C-k>', [[<Cmd>wincmd k<CR>]], mode = 't' },
      { '<C-l>', [[<Cmd>wincmd l<CR>]], mode = 't' },
      { '<C-w>', [[<C-\><C-n><C-w>]], mode = 't' },
    },
    opts = {
      size = 20,
      direction = 'horizontal',
      -- open_mapping = [[<c-t>]],
      insert_mappings = false, -- whether or not the open mapping applies in insert mode
      terminal_mappings = false, -- whether or not the open mapping applies in the opened terminals
      start_in_insert = true,
      persist_size = true,
      persist_mode = false,
      close_on_exit = true,
      winbar = { enabled = false },
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)
    end,
  },
}
