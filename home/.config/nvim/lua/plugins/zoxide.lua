return {
  {
    'nanotee/zoxide.vim',
    cmd = { 'Z', 'Zi' },
    keys = {
      { '<leader>fz', ':Zi<CR>', desc = '[F]ZF [Z]oxide CD' },
    },
    init = function()
      vim.g.zoxide_use_select = 1

      -- If no args are given to Neovim,
      -- open `Zi` on launch.
      if vim.fn.argc() == 0 then
        vim.defer_fn(function()
          vim.cmd 'Zi'
        end, 0)
      end
    end,
  },
}
