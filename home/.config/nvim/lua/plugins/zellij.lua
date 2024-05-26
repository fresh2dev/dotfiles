return {
  'https://gitea.local.hostbutter.net/fresh2dev/zellij.vim.git',
  lazy = false,
  keys = {
    { '<leader>tt', ':ZellijNewPane<CR>', mode = { 'n' }, { noremap = true } },
    { '<M-f>', ':ZellijNewPane<CR>', mode = { 'n', 'i' }, { noremap = true } },
    { '<M-t>', ':ZellijNewPaneSplit<CR>', mode = { 'n', 'i' }, { noremap = true } },
    { '<M-v>', ':ZellijNewPaneVSplit<CR>', mode = { 'n', 'i' }, { noremap = true } },
  },
  init = function()
    -- Automatically name the current Zellij tab after the current working directory (lua)
    vim.api.nvim_create_autocmd({ 'DirChanged', 'WinEnter', 'BufEnter' }, {
      pattern = '*',
      callback = function()
        vim.fn.system('zellij action rename-tab "' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. '"')
      end,
    })
  end,
}
