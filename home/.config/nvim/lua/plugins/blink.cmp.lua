---@diagnostic disable: missing-fields
return {
  {
    'https://github.com/saghen/blink.cmp',
    version = 'v0.7.*',
    lazy = false, -- lazy loading handled internally
    dependencies = {
      -- 'https://github.com/fresh2dev/friendly-snippets',
      { 'https://github.com/ibhagwan/fzf-lua' },
      {
        'https://github.com/chrisgrieser/nvim-scissors',
        keys = {
          -- Add Snippet with `Y` during visual selection.
          {
            'Y',
            function()
              require('scissors').addNewSnippet()
            end,
            mode = { 'x' },
            desc = 'Add Snippet',
          },
          {
            '<leader>fI',
            function()
              require('scissors').editSnippet()
            end,
            mode = { 'n' },
            desc = 'Edit Snippet',
          },
        },
        config = function()
          require('scissors').setup {
            snippetDir = vim.fn.stdpath 'config' .. '/snippets',
            jsonFormatter = 'jq',
            editSnippetPopup = {
              height = 0.4, -- relative to the window, between 0-1
              width = 0.6,
              border = 'rounded',
              keymaps = {
                cancel = 'q',
                saveChanges = '<leader>w', -- alternatively, can also use `:w`
                goBackToSearch = '<BS>',
                deleteSnippet = '<C-BS>',
                duplicateSnippet = '<C-d>',
                openInFile = '<C-o>',
                insertNextPlaceholder = '<C-p>', -- insert & normal mode
              },
            },
          }
        end,
      },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { 'sources.completion.enabled_providers' },
    opts = {
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
            if require('blink.cmp.completion.list').get_selected_item() then
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

      -- Disables keymaps, completions and signature help for these filetypes
      blocked_filetypes = {},

      snippets = {
        -- Function to use when expanding LSP provided snippets
        expand = function(snippet)
          vim.snippet.expand(snippet)
        end,
        -- Function to use when checking if a snippet is active
        active = function(filter)
          return vim.snippet.active(filter)
        end,
        -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
        jump = function(direction)
          vim.snippet.jump(direction)
        end,
      },

      completion = {
        -- keyword = {
        --   -- 'prefix' will fuzzy match on the text before the cursor
        --   -- 'full' will fuzzy match on the text before *and* after the cursor
        --   -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        --   range = 'prefix',
        --   -- Regex used to get the text when fuzzy matching
        --   regex = '[-_]\\|\\k',
        --   -- After matching with regex, any characters matching this regex at the prefix will be excluded
        --   exclude_from_prefix_regex = '[\\-]',
        -- },

        trigger = {
          -- When false, will not show the completion window automatically when in a snippet
          show_in_snippet = false,
        },

        list = {
          -- Maximum number of items to display
          max_items = 200,
          -- Controls if completion items will be selected automatically,
          -- and whether selection automatically inserts
          selection = 'manual',
        },

        accept = {
          -- Experimental auto-brackets support
          auto_brackets = {
            -- Whether to auto-insert brackets for functions
            enabled = true,
          },
        },

        menu = {
          enabled = true,

          -- Whether to automatically show the window when new completion items are available
          auto_show = true,

          -- Controls how the completion items are rendered on the popup window
          draw = {
            -- Components to render, grouped by column
            -- columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 } },
            -- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind', gap = 1 } },
          },
        },

        documentation = {
          -- Controls whether the documentation window will automatically show when selecting a completion item
          auto_show = true,
          -- Delay before showing the documentation window
          auto_show_delay_ms = 300,
          -- Delay before updating the documentation window when selecting a new item,
          -- while an existing item is still visible
          update_delay_ms = 50,
        },
        -- Displays a preview of the selected item on the current line
        ghost_text = {
          enabled = false,
        },
      },

      -- Experimental signature help support
      signature = {
        enabled = true,
      },

      fuzzy = {
        -- when enabled, allows for a number of typos relative to the length of the query
        -- disabling this matches the behavior of fzf
        use_typo_resistance = false,
        -- frencency tracks the most recently/frequently used items and boosts the score of the item
        use_frecency = true,
        -- proximity bonus boosts the score of items matching nearby words
        use_proximity = true,
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
              friendly_snippets = false,
              search_paths = { vim.fn.stdpath 'config' .. '/snippets' },
              -- global_snippets = { 'all' },
              ignored_filetypes = {},
              -- extended_filetypes = {
              --   markdown = { 'html' },
              -- },
            },
          },
        },
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)

      -- Snippet integration with `fzf-lua`, from:
      -- https://github.com/towry/nvim/blob/e0dc02c216467bf0609024ba8c60501003daf087/lua/userlib/snippets/init.lua#L12
      local snippet_registry = require('blink.cmp.sources.snippets.registry').new(opts['sources']['providers']['snippets']['opts'])

      local function get_snippet_info_desc(description)
        if type(description) == 'string' then
          return description
        elseif type(description) == 'table' then
          return description[1]
        end
        return ''
      end

      local function get_available_snippets()
        -- local snippet_registry = require 'snippets'
        local snippets_flatten = {}

        --- { [snippet_name] = { body = 'string', description = 'string', prefix =
        --- 'string' }
        -- snippet_registry.get_snippets_for_ft(vim.bo.filetype)
        -- local availables = snippet_registry.get_loaded_snippets() or {}
        local global_snippets = snippet_registry:get_global_snippets()
        local extended_snippets = snippet_registry:get_extended_snippets(vim.bo.filetype)
        local ft_snippets = snippet_registry:get_snippets_for_ft(vim.bo.filetype)
        local snips = vim.list_extend({}, global_snippets)
        vim.list_extend(snips, extended_snippets)
        vim.list_extend(snips, ft_snippets)

        for snippet_name, snippet_definition in pairs(snips) do
          table.insert(snippets_flatten, {
            name = snippet_name,
            description = get_snippet_info_desc(snippet_definition.description),
            body = snippet_definition.body,
            trigger = snippet_definition.prefix,
          })
        end

        return snippets_flatten
      end

      local function fzf_complete_snippet()
        local snippets = get_available_snippets()

        if #snippets <= 0 then
          vim.notify('No snippets found', vim.log.levels.WARN)
          return
        end

        local fzf_opts = {}
        fzf_opts.winopts = {
          fullscreen = false,
        }

        fzf_opts.actions = {
          ['default'] = function(selected, _opts)
            local select = selected[1]
            --- extract index from select by pattern index: ...
            local index = select:match '^%d+'
            local sp = snippets[tonumber(index)]
            if not sp then
              vim.notify('No snippets selected', vim.log.levels.WARN)
              return
            end

            if not sp.body then
              return
            end

            local body = type(sp.body) == 'string' and sp.body or table.concat(sp.body, '\n')

            -- vim.defer_fn(function()
            --   vim.cmd.startinsert()
            --   vim.snippet.expand(body)
            -- end, 1)
            vim.cmd 'normal! o'
            vim.cmd.startinsert()
            vim.snippet.expand(body)
          end,
        }

        local contents = vim
          .iter(ipairs(snippets))
          :map(function(i, snip)
            return string.format('%s: `%s`\t~ %s', i, snip.trigger, snip.description)
          end)
          :totable()

        fzf_opts.fzf_opts = {
          -- ['--preview'] = 'echo {}',
          ['--preview-window'] = 'nohidden,down,50%',
        }

        fzf_opts.prompt = 'Snippets> '
        -- fzf_opts.previewer = 'builtin'
        local builtin = require 'fzf-lua.previewer.builtin'

        -- Inherit from "base" instead of "buffer_or_file"
        local MyPreviewer = builtin.base:extend()

        function MyPreviewer:new(o, fzf_opts, fzf_win)
          MyPreviewer.super.new(self, o, fzf_opts, fzf_win)
          setmetatable(self, MyPreviewer)
          return self
        end

        function MyPreviewer:populate_preview_buf(entry_str)
          local tmpbuf = self:get_tmp_buffer()

          local index = entry_str:match '^%d+'
          local sp = snippets[tonumber(index)]
          if not sp or not sp.body then
            return ''
          end

          vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, type(sp.body) == 'string' and { sp.body } or sp.body)

          self:set_preview_buf(tmpbuf)
          self.win:update_scrollbar()
        end

        -- Disable line numbering and word wrap
        function MyPreviewer:gen_winopts()
          local new_winopts = { wrap = false, number = false }
          return vim.tbl_extend('force', self.winopts, new_winopts)
        end --
        fzf_opts.previewer = MyPreviewer

        return require('fzf-lua').fzf_exec(contents, fzf_opts)
      end

      vim.keymap.set('n', '<leader>fi', function()
        fzf_complete_snippet()
      end, { desc = '[F]ind Snippets' })
    end,
  },
}
