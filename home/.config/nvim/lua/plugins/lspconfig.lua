return { -- LSP Configuration & Plugins
  {
    'https://github.com/neovim/nvim-lspconfig',
    dependencies = {
      -- -- Prettier signature completion.
      -- -- (Removed in favor of blink.cmp's experimental signature help)
      -- { 'ray-x/lsp_signature.nvim' },
      -- Completion engine.
      { 'saghen/blink.cmp' },
      -- Useful status updates for LSP.
      { 'https://github.com/j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('[d', function()
            local config = vim.diagnostic.config() or {}
            vim.diagnostic.jump { count = -1, float = not config.virtual_lines }
          end, 'Go to previous [D]iagnostic message')
          map(']d', function()
            local config = vim.diagnostic.config() or {}
            vim.diagnostic.jump { count = 1, float = not config.virtual_lines }
          end, 'Go to next [D]iagnostic message')
          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>cc', vim.lsp.codelens.run, 'Run Codelens')
          map('<leader>cC', vim.lsp.codelens.refresh, 'Refresh & Display Codelens')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', ':FzfLua lsp_definitions<CR>', '[G]oto [D]efinition')

          -- Accept defaults introduced in this PR:
          -- https://github.com/neovim/neovim/pull/28650
          -- which are scheduled to be included in Neovim 0.11
          -- Open signature help
          map('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')
          -- Find references for the word under your cursor.
          map('grr', ':FzfLua lsp_references<CR>', '[G]oto [R]eferences')
          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, 'Rename Symbol')
          -- map('<F2>', vim.lsp.buf.rename, 'Rename Symbol')
          map('<leader>cr', vim.lsp.buf.rename, 'Rename Symbol')
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'x' })
          -- map('<C-Space>', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'x' })
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'x' })
          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', ':FzfLua lsp_implementations<CR>', '[G]oto [I]mplementation')
          map('gI', ':FzfLua lsp_implementations<CR>', '[G]oto [I]mplementation')
          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          -- map('<leader>D', ':FzfLua lsp_typedefs<CR>', 'Type [D]efinition')
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', ':FzfLua lsp_document_symbols<CR>', '[D]ocument [S]ymbols')

          -- -- Fuzzy find all the symbols in your current workspace.
          -- --  Similar to document symbols, except searches over your entire project.
          -- map('<leader>ws', ':FzfLua lsp_live_workspace_symbols<CR>', '[W]orkspace [S]ymbols')

          -- This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- NOTE: disabled in favor of `Snacks.toggle.diagnostics`
          -- -- Toggle diagnostics
          -- map('<leader>td', function()
          --   vim.diagnostic[vim.diagnostic.is_enabled() and 'disable' or 'enable']()
          -- end, '[T]oggle [D]iagnostics')

          -- Send code diagnostics to quickfix
          map('<leader>cq', vim.diagnostic.setloclist, '[C]ode diagnostics to [Q]uickfix (Buffer)')
          -- map('<leader>cQ', vim.diagnostic.setqflist, '[C]ode diagnostics to [Q]uickfix (Workspace)')

          -- NOTE: disabled in favor of `Snacks.toggle.inlay_hints()`
          -- -- The following autocommand is used to enable inlay hints in your
          -- -- code, if the language server you are using supports them
          -- --
          -- -- This may be unwanted, since they displace some of your code
          -- local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          --   map('<leader>th', function()
          --     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          --   end, '[T]oggle Inlay [H]ints')
          --   -- if present, enable by default
          --   vim.lsp.inlay_hint.enable(true)
          -- end

          vim.diagnostic.config {
            virtual_text = true,
            virtual_lines = false,
            -- virtual_lines = {
            --   -- Only show virtual line diagnostics for the current cursor line
            --   current_line = true,
            -- },
          }
        end,
      })

      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      --
      local servers = {
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        basedpyright = {
          filetypes = { 'python' },
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              disableTaggedHints = true,
              analysis = {
                typeCheckingMode = 'basic',
                reportUnusedImport = 'none',
                reportPrivateUsage = 'none',
                reportImplicitOverride = 'none',
                reportAttributeAccessIssue = 'none',
                reportImportCycles = 'error',
                reportUnnecessaryIsInstance = 'warning',
                reportUnnecessaryCast = 'warning',
                reportUnnecessaryComparison = 'warning',
                reportUnnecessaryContains = 'warning',
                reportUnnecessaryTypeIgnoreComment = 'warning',
                reportShadowedImports = 'warning',
              },
            },
          },
        },
        ruff = {
          filetypes = { 'python' },
          init_options = {
            settings = {
              -- Server settings should go here
              -- logLevel = 'debug',
              -- logFile = '/tmp/ruff.log',
              organizeImports = false,
            },
          },
        },
        rust_analyzer = {
          filetypes = { 'rust' },
        },
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        gopls = {
          -- cmd = {...},
          filetypes = { 'go', 'gomod' },
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
        -- marksman = {
        --   filetypes = { 'markdown' },
        -- },
        markdown_oxide = {
          filetypes = { 'markdown' },
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local lsp_config = require 'lspconfig'
      for name, config in pairs(servers) do
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, require('blink.cmp').get_lsp_capabilities(config.capabilities or {}))
        lsp_config[name].setup(config)
      end
    end,
  },
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function()
      local SymbolKind = vim.lsp.protocol.SymbolKind
      require('symbol-usage').setup {
        kinds = { SymbolKind.Class, SymbolKind.Method, SymbolKind.Function },
      }
    end,
  },
}
