-- [[ LSP Configuration ]]

-- Useful status updates for LSP.
vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
  },
  {
    src = "https://github.com/j-hui/fidget.nvim",
  },
  {
    src = "https://github.com/Wansmer/symbol-usage.nvim",
  },
})

require("fidget").setup({})

-- Display reference / definition / implementation counts above symbols.
local SymbolKind = vim.lsp.protocol.SymbolKind
require("symbol-usage").setup({
  kinds = { SymbolKind.Class, SymbolKind.Method, SymbolKind.Function },
})

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("[d", function()
      local config = vim.diagnostic.config() or {}
      vim.diagnostic.jump({ count = -1, float = not config.virtual_lines })
    end, "Go to previous [D]iagnostic message")
    map("]d", function()
      local config = vim.diagnostic.config() or {}
      vim.diagnostic.jump({ count = 1, float = not config.virtual_lines })
    end, "Go to next [D]iagnostic message")
    -- NOTE: Neovim >= 0.11 already maps `K`, `grn`, `gra`, `grr`, `gri`, `grt`
    -- and `gO` in LSP buffers. Only the ones routed through fzf-lua (or given an
    -- extra `<leader>c*` alias) are declared here.

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map("gd", "<Cmd>FzfLua lsp_definitions<CR>", "[G]oto [D]efinition")

    -- Open signature help (normal mode; insert-mode <C-s> is a Neovim default)
    map("<C-s>", vim.lsp.buf.signature_help, "Signature Help")
    -- Find references for the word under your cursor.
    map("grr", "<Cmd>FzfLua lsp_references<CR>", "[G]oto [R]eferences")
    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map("gri", "<Cmd>FzfLua lsp_implementations<CR>", "[G]oto [I]mplementation")
    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    -- map('<leader>D', '<Cmd>FzfLua lsp_typedefs<CR>', 'Type [D]efinition')
    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("gO", "<Cmd>FzfLua lsp_document_symbols<CR>", "[D]ocument [S]ymbols")

    -- -- Fuzzy find all the symbols in your current workspace.
    -- --  Similar to document symbols, except searches over your entire project.
    -- map('<leader>ws', '<Cmd>FzfLua lsp_live_workspace_symbols<CR>', '[W]orkspace [S]ymbols')

    -- This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    -- NOTE: disabled in favor of `Snacks.toggle.diagnostics`
    -- -- Toggle diagnostics
    -- map('<leader>td', function()
    --   vim.diagnostic[vim.diagnostic.is_enabled() and 'disable' or 'enable']()
    -- end, '[T]oggle [D]iagnostics')

    -- Send code diagnostics to quickfix
    map(
      "<leader>cq",
      vim.diagnostic.setloclist,
      "[C]ode diagnostics to [Q]uickfix (Buffer)"
    )
    -- map('<leader>cQ', vim.diagnostic.setqflist, '[C]ode diagnostics to [Q]uickfix (Workspace)')

    -- NOTE: disabled in favor of `Snacks.toggle.inlay_hints()`
    -- -- The following autocommand is used to enable inlay hints in your
    -- -- code, if the language server you are using supports them
    -- --
    -- -- This may be unwanted, since they displace some of your code
    -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    --   map('<leader>th', function()
    --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    --   end, '[T]oggle Inlay [H]ints')
    --   -- if present, enable by default
    --   vim.lsp.inlay_hint.enable(true)
    -- end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
      client and client:supports_method("textDocument/documentHighlight", event.buf)
    then
      local highlight_augroup =
        vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({
            group = "kickstart-lsp-highlight",
            buffer = event2.buf,
          })
        end,
      })
    end

    -- -- NOTE: disabled in favor of `Snacks.toggle.inlay_hints()`
    -- -- The following code creates a keymap to toggle inlay hints in your
    -- -- code, if the language server you are using supports them
    -- --
    -- -- This may be unwanted, since they displace some of your code
    -- if client and client:supports_method('textDocument/inlayHint', event.buf) then
    --   map(
    --     '<leader>th',
    --     function()
    --       vim.lsp.inlay_hint.enable(
    --         not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
    --       )
    --     end,
    --     '[T]oggle Inlay [H]ints'
    --   )
    -- end
  end,
})

-- Language servers. There is no Mason: every server must already be on $PATH.
-- Add a server by adding an entry here; the loop at the bottom applies it with
-- `vim.lsp.config()` + `vim.lsp.enable()`.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
  basedpyright = {
    filetypes = { "python" },
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        disableTaggedHints = true,
        analysis = {
          typeCheckingMode = "basic",
          reportUnusedImport = "none",
          reportPrivateUsage = "none",
          reportImplicitOverride = "none",
          reportAttributeAccessIssue = "none",
          reportImportCycles = "error",
          reportUnnecessaryIsInstance = "warning",
          reportUnnecessaryCast = "warning",
          reportUnnecessaryComparison = "warning",
          reportUnnecessaryContains = "warning",
          reportUnnecessaryTypeIgnoreComment = "warning",
          reportShadowedImports = "warning",
        },
      },
    },
  },
  ruff = {
    filetypes = { "python" },
    init_options = {
      settings = {
        -- Server settings should go here
        -- logLevel = 'debug',
        -- logFile = '/tmp/ruff.log',
        organizeImports = false,
      },
    },
  },
  just = {
    filetypes = { "just" },
    init_options = {},
  },
  gopls = {
    filetypes = { "go", "gomod" },
    -- cmd = {...},
    -- capabilities = {},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  rust_analyzer = {
    filetypes = { "rust" },
  },
  typos_lsp = {
    filetypes = { "markdown", "text" },
  },
  -- tombi is both the TOML language server and the TOML formatter (see
  -- `lsp_formatted` in plugin/99-conform.lua).
  tombi = {
    filetypes = { "toml" },
  },
  bashls = {
    filetypes = { "sh", "bash", "zsh" },
  },
  -- marksman = {
  --   filetypes = { 'markdown' },
  -- },
  -- stylua's LSP mode is the Lua *formatter*: conform skips Lua (see
  -- `lsp_formatted` in plugin/99-conform.lua) and formats via this server.
  -- Diagnostics come from lua_ls; lua_ls formatting is disabled below.
  stylua = {
    filetypes = { "lua" },
  },

  -- Special Lua Config, as recommended by neovim help docs
  -- Workspace library / runtime settings for Neovim config work are injected
  -- lazily by lazydev (ftplugin/lua_lazydev.lua); don't duplicate them here.
  lua_ls = {
    on_init = function(client)
      -- Formatting is stylua's job (see the `stylua` entry above)
      client.server_capabilities.documentFormattingProvider = false
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false },
      },
    },
  },
}

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
