return { -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
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
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
          map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
          -- map('<leader>ee', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
          -- map('<leader>eq', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')
          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gK', vim.lsp.buf.signature_help, 'Signature Help')
          map('<leader>cc', vim.lsp.codelens.run, 'Run Codelens')
          map('<leader>cC', vim.lsp.codelens.refresh, 'Refresh & Display Codelens')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', ':FzfLua lsp_definitions<CR>', '[G]oto [D]efinition')
          map('<F12>', ':FzfLua lsp_definitions<CR>', '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', ':FzfLua lsp_references<CR>', '[G]oto [R]references')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', ':FzfLua lsp_implementations<CR>', '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', ':FzfLua lsp_typedefs<CR>', 'Type [D]efinition')
          --
          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', ':FzfLua lsp_document_symbols<CR>', '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', ':FzfLua lsp_live_workspace_symbols<CR>', '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename Symbol')
          map('<F2>', vim.lsp.buf.rename, 'Rename Symbol')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
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
        -- pyright,
        -- yamlls = {},
        -- clangd = {},
        -- gopls = {},
        -- tsserver = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        basedpyright = {
          filetypes = { 'python' },
        },
        ruff = {
          filetypes = { 'python' },
          init_options = {
            settings = {
              -- Any extra CLI arguments for `ruff` go here.
              args = {},
            },
          },
        },
        rust_analyzer = {
          filetypes = { 'rust' },
        },
        marksman = {
          filetypes = { 'markdown' },
        },
        -- lua_ls = {
        --   -- cmd = {...},
        --   -- filetypes = { ...},
        --   -- capabilities = {},
        --   settings = {
        --     Lua = {
        --       completion = {
        --         callSnippet = 'Replace',
        --       },
        --       -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        --       -- diagnostics = { disable = { 'missing-fields' } },
        --     },
        --   },
        -- },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      for name, config in pairs(servers) do
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for tsserver)
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        require('lspconfig')[name].setup(config)
      end
    end,
  },
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        dockerfile = { 'hadolint' },
        yaml = { 'yamllint' },
        sh = { 'shellcheck' },
        zsh = { 'shellcheck' },
        -- python = { "ruff" },
        -- json = { 'jsonlint' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
          -- Check all types for typos
          require('lint').try_lint 'typos'
        end,
      })
    end,
  },
  { -- Formatting
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', 'FormatEnable', 'FormatDisable' },
    opts = {},
    config = function()
      require('conform').setup {
        -- Set up format-on-save
        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_fallback = true }
        end,
        -- Define your formatters
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'ruff_format', 'isort' },
          sh = { 'shfmt' },
          zsh = { 'shfmt' },
          rust = { 'rustfmt' },
          -- Use the "_" filetype to run formatters on filetypes that don't
          -- have other formatters configured.
          ['_'] = { 'trim_whitespace', 'trim_newlines' },
        },
        -- Customize formatters
        formatters = {
          shfmt = {
            prepend_args = { '-s', '-i', '2' },
          },
        },
      }

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })
      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>ef',
        function()
          require('refactoring').refactor 'Extract Function'
        end,
        mode = 'x',
        desc = '[E]xtract [F]unction',
      },
      {
        '<leader>ev',
        function()
          require('refactoring').refactor 'Extract Variable'
        end,
        mode = 'x',
        desc = '[E]xtract [V]ariable',
      },
    },
    config = function()
      require('refactoring').setup()
    end,
  },
  {
    'folke/trouble.nvim',
    branch = 'dev', -- IMPORTANT to use v3 pre-release!
    cmd = 'Trouble',
    keys = {
      {
        '<leader>cd',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
  },
}
