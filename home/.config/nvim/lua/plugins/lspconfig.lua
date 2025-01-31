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

          map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
          map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
          map('<leader>ce', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
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
          -- NOTE: <C-s> is for snippets instead
          -- -- Open signature help
          -- map('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')
          -- Find references for the word under your cursor.
          map('grr', ':FzfLua lsp_references<CR>', '[G]oto [R]eferences')
          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, 'Rename Symbol')
          map('<F2>', vim.lsp.buf.rename, 'Rename Symbol')
          map('<leader>cr', vim.lsp.buf.rename, 'Rename Symbol')
          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'x' })
          map('<C-Space>', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'x' })
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

          -- Toggle diagnostics
          map('<leader>td', function()
            vim.diagnostic[vim.diagnostic.is_enabled() and 'disable' or 'enable']()
          end, '[T]oggle [D]iagnostics')

          -- Send code diagnostics to quickfix
          map('<leader>cq', vim.diagnostic.setloclist, '[C]ode diagnostics to [Q]uickfix (Buffer)')
          -- map('<leader>cQ', vim.diagnostic.setqflist, '[C]ode diagnostics to [Q]uickfix (Workspace)')

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
            -- if present, enable by default
            vim.lsp.inlay_hint.enable(true)
          end

          -- setup Markdown Oxide daily note commands
          -- if client and client.name == 'markdown_oxide' then
          --   vim.api.nvim_create_user_command('Daily', function(args)
          --     local input = args.args
          --
          --     vim.lsp.buf.execute_command { command = 'jump', arguments = { input } }
          --   end, { desc = 'Open daily note', nargs = '*' })
          -- end
        end,
      })

      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   callback = function(args)
      --     require('lsp_signature').on_attach({
      --       bind = true,
      --       handler_opts = {
      --         border = 'rounded',
      --       },
      --     }, args.buf)
      --   end,
      -- })

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
            pyright = {
              disableOrganizeImports = true,
              disableTaggedHints = true,
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

      for name, config in pairs(servers) do
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, require('blink.cmp').get_lsp_capabilities(config.capabilities or {}))
        require('lspconfig')[name].setup(config)
      end
    end,
  },
  -- {
  --   'rachartier/tiny-inline-diagnostic.nvim',
  --   event = 'LspAttach',
  --   priority = 1000, -- needs to be loaded in first
  --   keys = {
  --     {
  --       '<leader>td',
  --       function()
  --         if vim.diagnostic.is_enabled() then
  --           vim.diagnostic.enable(false)
  --           require('tiny-inline-diagnostic').disable()
  --         else
  --           vim.diagnostic.enable(true)
  --           require('tiny-inline-diagnostic').enable()
  --         end
  --       end,
  --       desc = '[T]oggle [D]iagnostics',
  --     },
  --     {
  --       '[d',
  --       function()
  --         vim.diagnostic.goto_prev { float = false }
  --       end,
  --       desc = 'Go to previous [D]iagnostic message',
  --     },
  --     {
  --       ']d',
  --       function()
  --         vim.diagnostic.goto_next { float = false }
  --       end,
  --       desc = 'Go to previous [D]iagnostic message',
  --     },
  --   },
  --   config = function()
  --     vim.diagnostic.config { virtual_text = false }
  --
  --     require('tiny-inline-diagnostic').setup {
  --       options = {
  --         -- Format the diagnostic message.
  --         format = function(diagnostic)
  --           if not diagnostic.code or diagnostic.code == '' then
  --             return diagnostic.message .. ' [' .. diagnostic.source .. ']'
  --           else
  --             return diagnostic.message .. ' [' .. diagnostic.source .. ': ' .. diagnostic.code .. ']'
  --           end
  --         end,
  --
  --         -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
  --         -- You can increase it if you have performance issues.
  --         -- Or set it to 0 to have better visuals.
  --         throttle = 20,
  --
  --         -- The minimum length of the message, otherwise it will be on a new line.
  --         softwrap = 15,
  --
  --         -- If multiple diagnostics are under the cursor, display all of them.
  --         multiple_diag_under_cursor = true,
  --
  --         -- Enable diagnostic message on all lines.
  --         multilines = true,
  --
  --         -- Show all diagnostics on the cursor line.
  --         show_all_diags_on_cursorline = true,
  --
  --         -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
  --         enable_on_insert = false,
  --
  --         overflow = {
  --           -- Manage the overflow of the message.
  --           --    - wrap: when the message is too long, it is then displayed on multiple lines.
  --           --    - none: the message will not be truncated.
  --           --    - oneline: message will be displayed entirely on one line.
  --           mode = 'wrap',
  --         },
  --
  --         --- Enable it if you want to always have message with `after` characters length.
  --         break_line = {
  --           enabled = false,
  --           after = 30,
  --         },
  --
  --         virt_texts = {
  --           priority = 2048,
  --         },
  --       },
  --     }
  --   end,
  -- },
  -- Disabled in favor of `tiny-inline-diagnostic.nvim`
  -- {
  --   'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
  --   event = 'LspAttach',
  --   keys = {
  --     {
  --       '<Leader>td',
  --       function()
  --         require('lsp_lines').toggle()
  --         -- local new_value = require('lsp_lines').toggle()
  --         -- vim.diagnostic.config { virtual_text = not new_value }
  --       end,
  --       mode = 'n',
  --       desc = 'Toggle lsp_lines hints',
  --     },
  --   },
  --   config = function()
  --     require('lsp_lines').setup()
  --
  --     -- local function fmt(diagnostic)
  --     --   if diagnostic.code then
  --     --     return ('[%s] %s'):format(diagnostic.code, diagnostic.message)
  --     --   end
  --     --   return diagnostic.message
  --     -- end
  --     -- Start disabled.
  --     vim.diagnostic.config {
  --       virtual_text = false,
  --       virtual_lines = true,
  --       float = {
  --         source = true,
  --         show_header = false,
  --         -- format = fmt,
  --       },
  --     }
  --   end,
  -- },
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
  -- {
  --   -- Enables VSCode-like pictograms in completion menu
  --   'https://github.com/onsails/lspkind.nvim',
  --   event = 'LspAttach',
  --   config = function()
  --     require('lspkind').setup {}
  --   end,
  -- },
}
