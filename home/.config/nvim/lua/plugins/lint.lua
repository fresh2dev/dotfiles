-- An asynchronous linter plugin
return {
  'https://github.com/mfussenegger/nvim-lint',
  lazy = false,
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      -- markdown = { 'typos' },
      -- dockerfile = { 'hadolint' },
      -- yaml = { 'yamllint' },
      -- sh = { 'shellcheck' },
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
