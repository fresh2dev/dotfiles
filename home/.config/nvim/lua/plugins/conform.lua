-- Lightweight yet powerful formatter plugin
return {
  'https://github.com/stevearc/conform.nvim',
  version = 'v8',
  lazy = false,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo', 'FormatterEnable', 'FormatterDisable', 'FormatterToggle' },
  config = function()
    require('conform').setup {
      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_fix', 'ruff_format' },
        sh = { 'shfmt' },
        zsh = { 'shfmt' },
        rust = { 'rustfmt' },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        -- ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-s', '-i', '2' },
        },
        -- ruff_fix = {
        --   prepend_args = { '--fixable=COM,I001' },
        -- },
      },
    }

    vim.api.nvim_create_user_command('FormatterDisable', function()
      vim.b.disable_autoformat = true
    end, {
      desc = 'Disable Formatter',
    })

    vim.api.nvim_create_user_command('FormatterEnable', function()
      vim.b.disable_autoformat = false
    end, {
      desc = 'Enable Formatter',
    })

    vim.api.nvim_create_user_command('FormatterToggle', function()
      if vim.b.disable_autoformat then
        vim.cmd 'FormatterEnable'
      else
        vim.cmd 'FormatterDisable'
      end
    end, {
      desc = 'Toggle Formatter',
    })
  end,
}
