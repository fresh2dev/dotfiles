---@diagnostic disable: missing-fields

-- NOTE: Specify the trigger character(s) used for snippets
-- from: https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/plugins/blink-cmp.lua
local snippet_trigger_text = '`'

return {
  {
    'https://github.com/saghen/blink.cmp',
    version = '*',
    lazy = false, -- lazy loading handled internally
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { 'sources.completion.enabled_providers' },
    opts = {
      keymap = {
        -- https://cmp.saghen.dev/configuration/keymap.html#super-tab
        preset = 'default',
        -- ['<C-e>'] = { 'hide', 'fallback' },
        -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
        -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        -- ['<C-p>'] = { 'select_prev', 'fallback' },
        -- ['<C-n>'] = { 'select_next', 'fallback' },
        --
        ['<Tab>'] = {
          function(_cmp)
            if require('blink.cmp.completion.list').get_selected_item() then
              -- Only accept on tab if an item is selected.
              return _cmp.accept()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-space>'] = { 'select_and_accept', 'fallback' },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = 'cmdline',
          ['<down>'] = { 'select_next', 'fallback' },
          ['<up>'] = { 'select_prev', 'fallback' },
          ['<left>'] = { 'fallback' },
          ['<right>'] = { 'fallback' },
          ['<C-space>'] = { 'select_accept_and_enter' },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          -- Commands
          if type == ':' or type == '@' then
            return { 'cmdline' }
          end
          return {}
        end,
        completion = {
          trigger = {
            show_on_blocked_trigger_characters = {},
            show_on_x_blocked_trigger_characters = {},
          },
          list = {
            selection = {
              -- When `true`, will automatically select the first item in the completion list
              preselect = false,
              -- When `true`, inserts the completion item automatically when selecting it
              auto_insert = true,
            },
          },
          -- Whether to automatically show the window when new completion items are available
          menu = { auto_show = false },
          -- Displays a preview of the selected item on the current line
          ghost_text = { enabled = true },
        },
      },

      enabled = function()
        -- Get the current buffer's filetype
        local filetype = vim.bo[0].filetype
        -- Disable for Telescope buffers
        if filetype == 'TelescopePrompt' or filetype == 'minifiles' or filetype == 'snacks_picker_input' or filetype == 'fugitive' then
          return false
        end
        return true
      end,

      completion = {
        keyword = { range = 'full' },

        -- When false, will not show the completion window automatically when in a snippet
        trigger = { show_in_snippet = false },

        list = {
          -- Controls if completion items will be selected automatically,
          -- and whether selection automatically inserts
          selection = { preselect = false, auto_insert = false },
        },

        -- Disable auto brackets
        -- NOTE: some LSPs may add auto brackets themselves anyway
        accept = { auto_brackets = { enabled = false } },

        menu = {
          enabled = true,

          -- Whether to automatically show the window when new completion items are available
          auto_show = true,

          -- nvim-cmp style menu
          draw = {
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
        },

        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 500,
        },

        -- Displays a preview of the selected item on the current line
        ghost_text = { enabled = false },
      },

      -- Experimental signature help support
      signature = {
        enabled = true,
        window = {
          show_documentation = false,
        },
      },

      sources = {
        -- list of enabled providers
        -- default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
        default = {
          'avante',
          'lsp',
          'path',
          'snippets',
          'buffer',
        },

        -- table of providers to configure
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
            opts = {
              -- options for blink-cmp-avante
            },
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 3,
            opts = {
              -- Path completion from cwd instead of
              -- current buffer's directory
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          -- snippets = {
          --   name = 'Snippets',
          --   module = 'blink.cmp.sources.snippets',
          --   score_offset = -3,
          --   opts = {
          --     -- NOTE: these should be similar to what is defined
          --     -- for `nvim-snippets` in `snippets.lua`.
          --     friendly_snippets = false,
          --     search_paths = { vim.fn.stdpath 'config' .. '/snippets' },
          --     -- global_snippets = { 'all' },
          --     ignored_filetypes = {},
          --     -- extended_filetypes = {
          --     --   markdown = { 'html' },
          --     -- },
          --   },
          -- },
          -- snippets = {
          --   enabled = true,
          --   name = 'Snippets',
          --   max_items = 50,
          --   min_keyword_length = 0,
          --   module = 'blink.cmp.sources.snippets',
          --   score_offset = 100, -- the higher the number, the higher the priority
          --   -- Only show snippets if I type the trigger_text characters, so
          --   -- to expand the "bash" snippet, if the trigger_text is ";" I have to
          --   should_show_items = function()
          --     local col = vim.api.nvim_win_get_cursor(0)[2]
          --     local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          --     -- NOTE: remember that `snippet_trigger_text` is modified at the top of the file
          --     return before_cursor:match(snippet_trigger_text .. '%w*$') ~= nil
          --   end,
          --   -- After accepting the completion, delete the snippet_trigger_text characters
          --   -- from the final inserted text
          --   transform_items = function(_, items)
          --     local col = vim.api.nvim_win_get_cursor(0)[2]
          --     local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
          --     local trigger_pos = before_cursor:find(snippet_trigger_text .. '[^' .. snippet_trigger_text .. ']*$')
          --     if trigger_pos then
          --       for _, item in ipairs(items) do
          --         item.textEdit = {
          --           newText = item.insertText or item.label,
          --           range = {
          --             start = { line = vim.fn.line '.' - 1, character = trigger_pos - 1 },
          --             ['end'] = { line = vim.fn.line '.' - 1, character = col },
          --           },
          --         }
          --       end
          --     end
          --     -- NOTE: After the transformation, I have to reload the luasnip source
          --     -- Otherwise really crazy shit happens and I spent way too much time
          --     -- figurig this out
          --     vim.schedule(function()
          --       require('blink.cmp').reload 'snippets'
          --     end)
          --     return items
          --   end,
          -- },
        },
      },
    },
  },
}
