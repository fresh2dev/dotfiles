vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
})

-- Filetypes whose formatting is owned by an LSP server rather than treefmt.
-- Add a filetype here when its server formats better than the project's treefmt
-- pipeline, and make sure that server is enabled in plugin/90-lspconfig.lua.
local lsp_formatted = {
  lua = true, -- stylua --lsp (lua_ls formatting is disabled)
  toml = true, -- tombi lsp
}

require("conform").setup({
  -- Set up format-on-save
  format_on_save = function(bufnr)
    -- Disable with a buffer-local variable (see :ConformToggle below)
    if vim.b[bufnr].disable_autoformat then
      return
    end
    if lsp_formatted[vim.bo[bufnr].filetype] then
      -- Empty formatter list + "prefer" → conform runs only the LSP formatter.
      return { timeout_ms = 1000, async = false, lsp_format = "prefer", formatters = {} }
    end
    return {
      timeout_ms = 1000,
      async = false,
      lsp_format = "never", -- 'never' 'prefer' 'fallback'
    }
  end,
  -- Define your formatters. Everything goes through the project's treefmt;
  -- filetypes listed in `lsp_formatted` above bypass this table entirely.
  formatters_by_ft = {
    ["_"] = { "treefmt" },
    -- python = { 'ruff_fix', 'ruff_format' },
    -- lua = { 'stylua' },
    -- rust = { 'rustfmt' },
    -- markdown = { 'rumdl' },
    -- sql = { 'sqruff' },
    -- go = { 'gofmt' },
    -- gomod = { 'gofmt' },
    -- just = { 'just' },
    -- sh = { 'beautysh', 'shfmt' },
    -- bash = { 'beautysh', 'shfmt' },
    -- zsh = { 'beautysh', 'shfmt' },
    -- yaml = { 'yamlfix' },
    -- toml = { 'tombi' },
    -- Use the "_" filetype to run formatters on filetypes that don't
    -- have other formatters configured.
    -- ['_'] = { 'trim_whitespace', 'trim_newlines' },
  },
  -- Customize formatters
  formatters = {
    treefmt = {
      inherit = true,
      command = "treefmt",
      -- args = { "--stdin", "$FILENAME" },
      -- stdin = true,
      cwd = require("conform.util").root_file({
        ".git",
        "treefmt.toml",
        ".treefmt.toml",
      }),
      require_cwd = false,
    },
    -- ruff_fix = {
    --   append_args = { '--select=E,W,COM,I001', '--fixable=E,W,COM,I001' },
    -- },
    -- shfmt = {
    --   prepend_args = { '-i', '2' },
    -- },
    -- beautysh = {
    --   prepend_args = { '-i', '2', '--variable-style', 'braces' },
    -- },
  },
})

vim.api.nvim_create_user_command("ConformDisable", function()
  vim.b.disable_autoformat = true
end, {
  desc = "Disable Formatter",
})

vim.api.nvim_create_user_command("ConformEnable", function()
  vim.b.disable_autoformat = false
end, {
  desc = "Enable Formatter",
})

vim.api.nvim_create_user_command("ConformToggle", function()
  if vim.b.disable_autoformat then
    vim.cmd("ConformEnable")
  else
    vim.cmd("ConformDisable")
  end
end, {
  desc = "Toggle Formatter",
})
