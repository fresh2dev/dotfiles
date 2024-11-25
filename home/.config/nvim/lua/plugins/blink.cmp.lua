return {
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = {
      -- { 'https://github.com/niuiic/blink-cmp-rg.nvim' },
      -- { 'https://github.com/mikavilpas/blink-ripgrep.nvim' },
      {
        'https://github.com/L3MON4D3/LuaSnip',
        version = 'v2.*',
      },
      {
        'https://github.com/rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    version = 'v0.*',
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { 'sources.completion.enabled_providers' },
    config = function()
      local cmp = require 'blink.cmp'
      local luasnip = require 'luasnip'

      local function previous_char_is_space()
        local col = vim.fn.col '.' - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
      end

      cmp.setup {
        -- TODO:
        -- 'default' for mappings similar to built-in completion
        -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
        -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
        -- see the "default configuration" section below for full documentation on how to define
        -- your own keymap.
        keymap = {
          preset = 'default',
          -- ['<C-e>'] = { 'hide', 'fallback' },
          -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
          -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
          -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          -- ['<Up>'] = { 'select_prev', 'fallback' },
          -- ['<Down>'] = { 'select_next', 'fallback' },
          -- ['<C-p>'] = { 'select_prev', 'fallback' },
          -- ['<C-n>'] = { 'select_next', 'fallback' },
          --
          ['<Tab>'] = {
            function(_cmp)
              if _cmp.is_in_snippet() then
                return _cmp.accept()
              elseif require('blink.cmp.windows.autocomplete').get_selected_item() then
                -- Only accept on tab if an item is selected.
                return _cmp.accept()
              end
            end,
            'snippet_forward',
            'fallback',
          },
          ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

          -- -- Accept selection or next item is nothing is selected.
          ['<C-space>'] = { 'select_and_accept', 'fallback' },
          -- Accept if an item is selected.
          ['<CR>'] = { 'accept', 'fallback' },
          -- Accept if an item is selected, else snippet_forward, or fallback.
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<C-j>'] = { 'select_next', 'fallback' },

          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
        },

        -- experimental auto-brackets support
        accept = {
          auto_brackets = { enabled = true },
          expand_snippet = luasnip.lsp_expand,
        },

        -- experimental signature help support
        trigger = {
          completion = { show_in_snippet = false },
          signature_help = { enabled = true },
        },

        fuzzy = {
          use_typo_resistance = false,
        },

        sources = {
          -- list of enabled providers
          completion = {
            enabled_providers = { 'lsp', 'path', 'snippets', 'buffer' },
          },

          -- table of providers to configure
          providers = {
            lsp = {
              name = 'LSP',
              module = 'blink.cmp.sources.lsp',
            },
            path = {
              name = 'Path',
              module = 'blink.cmp.sources.path',
              score_offset = 3,
            },
            snippets = {
              name = 'Snippets',
              module = 'blink.cmp.sources.snippets',
              score_offset = -3,
            },
            buffer = {
              name = 'Buffer',
              module = 'blink.cmp.sources.buffer',
              fallback_for = { 'lsp' },
            },
            -- ripgrep = {
            --   name = 'Ripgrep',
            --   -- module = 'blink-cmp-rg',
            --   module = 'blink-ripgrep',
            --   opts = {
            --     prefix_min_len = 3,
            --     context_size = 3,
            --     -- get_command = function(context, prefix)
            --     --   return {
            --     --     'rg',
            --     --     '--no-config',
            --     --     '--json',
            --     --     '--word-regexp',
            --     --     '--ignore-case',
            --     --     '--',
            --     --     prefix .. '[\\w_-]+',
            --     --     vim.fs.root(0, '.git') or vim.fn.getcwd(),
            --     --   }
            --     -- end,
            --     -- get_prefix = function(context)
            --     --   local col = vim.api.nvim_win_get_cursor(0)[2]
            --     --   local line = vim.api.nvim_get_current_line()
            --     --   local prefix = line:sub(1, col):match '[%w_-]+$' or ''
            --     --   return prefix
            --     -- end,
            --   },
            -- },
          },
        },

        windows = {
          autocomplete = {
            auto_show = true,
            selection = 'manual',
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 300,
            update_delay_ms = 50,
          },
          ghost_text = {
            enabled = false,
          },
        },
      }
    end,
  },
}
