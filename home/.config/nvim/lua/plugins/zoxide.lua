return {
  {
    'https://github.com/nanotee/zoxide.vim',
    cmd = { 'Z', 'Zi' },
    init = function()
      vim.g.zoxide_use_select = 1

      local cwd = vim.fn.getcwd()
      if vim.fn.argc() == 0 and (cwd == vim.fn.expand '~' or cwd == '/') then
        vim.defer_fn(function()
          vim.cmd 'Zi'
        end, 0)
      end
    end,
  },
}
