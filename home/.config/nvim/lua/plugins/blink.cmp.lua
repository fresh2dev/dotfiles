return {
  {
    'https://github.com/saghen/blink.cmp',
    version = '*',
    lazy = false, -- lazy loading handled internally
    dependencies = {
      'https://github.com/fresh2dev/friendly-snippets',
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { 'sources.completion.enabled_providers' },
    config = function()
      local cmp = require 'blink.cmp'

      -- local function previous_char_is_space()
      --   local col = vim.fn.col '.' - 1
      --   return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
      -- end

      cmp.setup {
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
              if require('blink.cmp.windows.autocomplete').get_selected_item() then
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
            enabled_providers = { 'lsp', 'path', 'buffer', 'snippets' },
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
            buffer = {
              name = 'Buffer',
              module = 'blink.cmp.sources.buffer',
              fallback_for = { 'lsp' },
            },
            snippets = {
              name = 'Snippets',
              module = 'blink.cmp.sources.snippets',
              score_offset = -3,
              opts = {
                -- NOTE: these should be similar to what is defined
                -- for `nvim-snippets` in `snippets.lua`.
                friendly_snippets = true,
                -- search_paths = { '/Users/donald/.vim/snippets' },
                global_snippets = { 'all' },
                ignored_filetypes = {},
                extended_filetypes = {
                  markdown = { 'html' },
                },
              },
            },
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
