return {
  {
    'https://github.com/echasnovski/mini.basics',
    version = '*',
    lazy = false,
    config = true,
    opts = {
      options = { basic = false, extra_ui = false, win_borders = 'double' },
      mappings = { basic = false, option_toggle_prefix = '', windows = false, move_with_alt = false },
      autocommands = {
        basic = false,
        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = true,
      },
      -- Whether to disable showing non-error feedback
      silent = true,
    },
  },
  {
    'https://github.com/echasnovski/mini.cursorword',
    version = '*',
    lazy = false,
    opts = {},
    config = function(_, opts)
      require('mini.cursorword').setup { opts }
      vim.cmd 'hi! link MiniCursorword Visual'
      vim.cmd 'hi! link MiniCursorwordCurrent CursorLine'
    end,
  },
  {
    'https://github.com/echasnovski/mini.operators',
    version = '*',
    lazy = false,
    config = function()
      require('mini.operators').setup {
        -- Each entry configures one operator.
        -- `prefix` defines keys mapped during `setup()`: in Normal mode
        -- to operate on textobject and line, in Visual - on selection.

        -- Evaluate text and replace with output
        evaluate = {
          prefix = '',
          -- Function which does the evaluation
          func = nil,
        },

        -- Exchange text regions
        exchange = {
          prefix = '',
          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Multiply (duplicate) text
        multiply = {
          prefix = '',
          -- Function which can modify text before multiplying
          func = nil,
        },

        -- Replace text with register
        replace = {
          prefix = '',
          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Sort text
        sort = {
          prefix = 'gs',
          -- Function which does the sort
          func = nil,
        },
      }
    end,
  },
  -- {
  --   'https://github.com/echasnovski/mini.visits',
  --   version = '*',
  --   lazy = false,
  --   config = true,
  --   keys = {
  --     {
  --       '<leader>fo',
  --       function()
  --         require('mini.visits').select_path()
  --       end,
  --       desc = '[F]ind [V]isits',
  --     },
  --   },
  -- },
  {
    'https://github.com/echasnovski/mini.diff',
    version = '*',
    lazy = false,
    -- No need to copy this inside `setup()`. Will be used automatically.
    keys = {
      {
        '<leader>tg',
        function()
          require('mini.diff').toggle_overlay(0)
        end,
        desc = '[T]oggle [G]it Overlay',
      },
    },
    opts = {
      -- Delays (in ms) defining asynchronous processes
      delay = {
        -- How much to wait before update following every text change
        text_change = 200,
      },

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Apply hunks inside a visual/operator region
        apply = '<leader>ga',

        -- Reset hunks inside a visual/operator region
        reset = '<leader>gA',

        -- Hunk range textobject to be used inside operator
        -- Works also in Visual mode if mapping differs from apply and reset
        textobject = 'gd',

        -- Go to hunk range in corresponding direction
        goto_first = '[H',
        goto_prev = '[h',
        goto_next = ']h',
        goto_last = ']H',
      },
    },
    config = function(_, opts)
      require('mini.diff').setup(opts)
      vim.cmd 'hi! link MiniDiffOverChange CurSearch'
      vim.cmd 'hi! link MiniDiffOverContext MiniDiffOverDelete'
    end,
  },
  {
    'https://github.com/echasnovski/mini.files',
    -- version = '*',
    lazy = false,
    dependencies = {
      'https://github.com/nvim-tree/nvim-web-devicons', -- optional dependency
    },
    keys = {
      {
        '\\',
        function()
          local MiniFiles = require 'mini.files'
          if not MiniFiles.close() then
            MiniFiles.open(nil, false)
          end
        end,
        mode = 'n',
        desc = 'Show File Explorer',
      },
      {
        '|',
        function()
          local MiniFiles = require 'mini.files'
          if not MiniFiles.close() then
            MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
            MiniFiles.reveal_cwd()
          end
        end,
        mode = 'n',
        desc = 'Show File Explorer',
      },
    },
    config = function()
      local MiniFiles = require 'mini.files'
      MiniFiles.setup {
        -- Customization of shown content
        content = {
          -- Predicate for which file system entries to show
          filter = nil,
          -- What prefix to show to the left of file system entry
          prefix = nil,
          -- In which order to show file system entries
          sort = nil,
        },

        -- Module mappings created only inside explorer.
        -- Use `''` (empty string) to not create one.
        mappings = {
          close = 'q',
          go_in = 'L',
          go_in_plus = '<CR>',
          go_out = '<BS>',
          go_out_plus = '',
          mark_goto = '',
          mark_set = '',
          reset = '<F5>',
          reveal_cwd = '@',
          show_help = 'g?',
          synchronize = '<leader>w',
          trim_left = '<',
          trim_right = '>',
        },

        -- General options
        options = {
          -- Whether to delete permanently or move into module-specific trash
          permanent_delete = true,
          -- Whether to use for editing directories
          use_as_default_explorer = true,
        },

        -- Customization of explorer windows
        windows = {
          -- Maximum number of windows to show side by side
          max_number = math.huge,
          -- Whether to show preview of file/directory under cursor
          preview = false,
          -- Width of focused window
          width_focus = 50,
          -- Width of non-focused window
          width_nofocus = 15,
          -- Width of preview window
          width_preview = 25,
        },
      }

      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. ' split')
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)

          -- After splitting window, open the file.
          MiniFiles.go_in { close_on_file = true }
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          local buf_id = args.data.buf_id
          -- Tweak keys to your liking
          map_split(buf_id, '<C-o>', 'belowright horizontal')
          map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
      })
    end,
  },
  {
    'https://github.com/echasnovski/mini.ai',
    version = '*',
    lazy = false,
    config = true,
    opts = {
      -- Table with textobject id as fields, textobject specification as values.
      -- Also use this to disable builtin textobjects. See |MiniAi.config|.
      custom_textobjects = nil,

      -- Number of lines within which textobject is searched
      n_lines = 500,

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- Main textobject prefixes
        around = '', -- Disabled in favor of targets.nvim
        inside = '', -- Disabled in favor of targets.nvim

        -- Next/last variants
        around_next = '', -- Disabled in favor of targets.nvim
        inside_next = '', -- Disabled in favor of targets.nvim
        around_last = '', -- Disabled in favor of targets.nvim
        inside_last = '', -- Disabled in favor of targets.nvim

        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
      },
    },
  },
  {
    'https://github.com/echasnovski/mini.splitjoin',
    version = '*',
    lazy = false,
    config = true,
    opts = {
      -- Module mappings. Use `''` (empty string) to disable one.
      -- Created for both Normal and Visual modes.
      mappings = {
        toggle = 'gS',
        split = '',
        join = '',
      },
    },
  },
  {
    'https://github.com/echasnovski/mini.comment',
    version = '*',
    lazy = false,
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = { enable_autocmd = false },
      },
    },
    config = true,
    opts = {
      options = {
        -- Context-aware comment char (useful in Markdown docs)
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  {
    'https://github.com/echasnovski/mini.surround',
    version = '*',
    lazy = false,
    config = function()
      require('mini.surround').setup {
        highlight_duration = 500,
        -- Map as is done in tpope/vim-surround
        mappings = {
          add = 'ys',
          delete = 'ds',
          find = '',
          find_left = '',
          highlight = '',
          replace = 'cs',
          update_n_lines = '',

          suffix_last = '',
          suffix_next = '',
        },

        -- Number of lines within which surrounding is searched
        n_lines = 50,

        -- Whether to respect selection type:
        -- - Place surroundings on separate lines in linewise mode.
        -- - Place surroundings on each line in blockwise mode.
        respect_selection_type = false,

        -- How to search for surrounding (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
        -- see `:h MiniSurround.config`.
        search_method = 'cover',

        -- Whether to disable showing non-error feedback
        silent = false,
      }

      -- Remap adding surrounding to Visual mode selection
      vim.keymap.del('x', 'ys')
      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

      -- Make special mapping for "add surrounding for line"
      vim.keymap.set('n', 'yss', 'ys_', { remap = true })

      -- Disable builtin `s`
      -- vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
      -- vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
      -- vim.keymap.set('n', 'ss', 'sa_', { remap = true })
    end,
  },
  {
    'https://github.com/echasnovski/mini.pairs',
    -- version = '*',
    lazy = false,
    config = true,
    opts = {
      -- In which modes mappings from this `config` should be created
      -- modes = { insert = true, command = false, terminal = false },

      -- Global mappings. Each right hand side should be a pair information, a
      -- table with at least these fields (see more in |MiniPairs.map|):
      -- - <action> - one of 'open', 'close', 'closeopen'.
      -- - <pair> - two character string for pair to be used.
      -- By default pair is not inserted after `\`, quotes are not recognized by
      -- `<CR>`, `'` does not insert pair after a letter.
      -- Only parts of tables can be tweaked (others will use these defaults).
      -- mappings = {
      --   ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      --   ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      --   ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
      --
      --   [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      --   [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      --   ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
      --
      --   ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      --   ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      --   ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
      -- },
    },
  },
  {
    'https://github.com/echasnovski/mini.indentscope',
    version = '*',
    lazy = false,
    config = function()
      require('mini.indentscope').setup {
        -- NOTE: configured to behave as 'michaeljsmith/vim-indent-object'
        -- Draw options
        draw = {
          -- Delay (in ms) between event and start of drawing scope indicator
          delay = 100,
          -- Animation rule for scope's first drawing. A function which, given
          -- next and total step numbers, returns wait time (in ms). See
          -- |MiniIndentscope.gen_animation| for builtin options. To disable
          -- animation, use `require('mini.indentscope').gen_animation.none()`.
          animation = require('mini.indentscope').gen_animation.none(),
          -- Symbol priority. Increase to display on top of more symbols.
          priority = 2,
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Textobjects
          -- Disabled in favor of 'michaeljsmith/vim-indent-object'
          object_scope = '',
          object_scope_with_border = '',
          -- Motions (jump to respective border line; if not present - body line)
          goto_top = '[i',
          goto_bottom = ']i',
        },
        -- Options which control scope computation
        options = {
          -- Type of scope's border: which line(s) with smaller indent to
          -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
          -- border = 'both',
          -- Whether to use cursor column when computing reference indent.
          -- Useful to see incremental scopes with horizontal cursor movements.
          indent_at_cursor = false,
          -- Whether to first check input line to be a border of adjacent scope.
          -- Use it if you want to place cursor on function header to get scope of
          -- its body.
          try_as_border = false,
        },
        -- Which character to use for drawing scope indicator
        symbol = '╎',
      }
    end,
  },
  -- {
  --   'https://github.com/echasnovski/mini.move',
  --   version = '*',
  --   lazy = false,
  --   config = true,
  --   opts = {
  --     -- Module mappings. Use `''` (empty string) to disable one.
  --     mappings = {
  --       -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
  --       left = 'gh',
  --       right = 'gl',
  --       down = 'gj',
  --       up = 'gk',
  --
  --       -- Move current line in Normal mode
  --       line_left = 'gh',
  --       line_right = 'gl',
  --       line_down = 'gj',
  --       line_up = 'gk',
  --     },
  --
  --     -- Options which control moving behavior
  --     options = {
  --       -- Automatically reindent selection during linewise vertical move
  --       reindent_linewise = true,
  --     },
  --   },
  -- },
  -- {
  --   'https://github.com/echasnovski/mini.tabline',
  --   version = '*',
  --   lazy = false,
  --   config = true,
  --   dependencies = { 'https://github.com/nvim-tree/nvim-web-devicons' },
  --   opts = {
  --     -- Whether to show file icons (requires 'mini.icons')
  --     show_icons = true,
  --
  --     -- Function which formats the tab label
  --     -- By default surrounds with space and possibly prepends with icon
  --     format = nil,
  --
  --     -- Whether to set Vim's settings for tabline (make it always shown and
  --     -- allow hidden buffers)
  --     set_vim_settings = true,
  --
  --     -- Where to show tabpage section in case of multiple vim tabpages.
  --     -- One of 'left', 'right', 'none'.
  --     tabpage_section = 'left',
  --   },
  -- },
  -- {
  --   'https://github.com/echasnovski/mini.map',
  --   version = '*',
  --   lazy = false,
  --   keys = {
  --     -- { '<Leader>mc', MiniMap.close, mode = 'n', desc = '...' },
  --     -- { '<Leader>mf', MiniMap.toggle_focus, mode = 'n', desc = '...' },
  --     { 'gm', ':lua MiniMap.toggle_focus()<CR>', mode = 'n', desc = '...' },
  --     -- { '<Leader>mr', MiniMap.refresh, mode = 'n', desc = '...' },
  --     -- { '<Leader>ms', MiniMap.toggle_side, mode = 'n', desc = '...' },
  --     { '<Leader>tm', ':lua MiniMap.toggle()<CR>', mode = 'n', desc = '...' },
  --   },
  --   config = function()
  --     local map = require 'mini.map'
  --
  --     map.setup {
  --       integrations = {
  --         map.gen_integration.builtin_search(),
  --         map.gen_integration.diff(),
  --         map.gen_integration.diagnostic(),
  --       },
  --       symbols = {
  --         -- Scrollbar parts for view and line. Use empty string to disable any.
  --         -- scroll_line = '█',
  --         -- scroll_view = '┃',
  --         scroll_line = '',
  --         scroll_view = '',
  --       },
  --       -- Window options
  --       window = {
  --         -- Whether window is focusable in normal way (with `wincmd` or mouse)
  --         focusable = true,
  --         -- Side to stick ('left' or 'right')
  --         side = 'right',
  --         -- Whether to show count of multiple integration highlights
  --         show_integration_count = true,
  --         -- Total width
  --         width = 5,
  --         -- Value of 'winblend' option
  --         winblend = 50,
  --         -- Z-index
  --         zindex = 10,
  --       },
  --     }
  --
  --     -- vim.api.nvim_create_user_command('MinimapFocus', function()
  --     --   MiniMap.open()
  --     --   for _, win in ipairs(vim.api.nvim_list_wins()) do
  --     --     if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'filetype') == 'minimap' then
  --     --       vim.api.nvim_set_current_win(win)
  --     --       break
  --     --     end
  --     --   end
  --     -- end, {})
  --   end,
  -- },
  -- {
  --   'https://github.com/echasnovski/mini.animate',
  --   lazy = false,
  --   config = true,
  --   opts = function()
  --     -- don't use animate when scrolling with the mouse
  --     local mouse_scrolled = false
  --     for _, scroll in ipairs { 'Up', 'Down' } do
  --       local key = '<ScrollWheel' .. scroll .. '>'
  --       vim.keymap.set({ '', 'i' }, key, function()
  --         mouse_scrolled = true
  --         return key
  --       end, { expr = true })
  --     end
  --
  --     vim.api.nvim_create_autocmd('FileType', {
  --       pattern = 'grug-far',
  --       callback = function()
  --         vim.b.minianimate_disable = true
  --       end,
  --     })
  --
  --     local animate = require 'mini.animate'
  --     return {
  --       resize = {
  --         timing = animate.gen_timing.linear { duration = 100, unit = 'total' },
  --       },
  --       scroll = {
  --         timing = animate.gen_timing.linear { duration = 125, unit = 'total' },
  --         subscroll = animate.gen_subscroll.equal {
  --           predicate = function(total_scroll)
  --             if mouse_scrolled then
  --               mouse_scrolled = false
  --               return false
  --             end
  --             return total_scroll > 1
  --           end,
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    'https://github.com/echasnovski/mini.starter',
    version = '*',
    lazy = false,
    opts = {
      evaluate_single = true,
      query_updaters = '',
      header = table.concat({
        '██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z',
        '██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    ',
        '██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       ',
        '██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         ',
        '███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           ',
        '╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           ',
      }, '\n'),
      items = {
        { name = ' F  ~ Find', action = 'normal 1 F', section = '' },
        { name = ' fo ~ Recent files', action = 'normal 1 fo', section = '' },
        { name = ' ff ~ Find file', action = 'normal 1 ff', section = '' },
        { name = ' fs ~ Find text', action = 'normal 1 fs', section = '' },
        { name = ' ft ~ Find TODOs', action = 'normal 1 ft', section = '' },
        { name = ' fm ~ Find Bookmarks', action = 'normal 1 fm', section = '' },
        { name = ' gt ~ Git Fugitive', action = 'normal 1 gt', section = '' },
        { name = ' gh ~ GitHub Actions', action = 'normal 1 gh', section = '' },
        { name = ' gB ~ GitHub in Browser', action = 'normal 1 gB', section = '' },
        { name = ' gI ~ GitHub Issues', action = 'normal 1 gB', section = '' },
        { name = ' qq ~ Quit', action = 'quit', section = '' },
      },
    },
    config = function(_, opts)
      local starter = require 'mini.starter'
      starter.setup(opts)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniStarterOpened',
        callback = function(ev)
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          -- local pad_footer = string.rep(' ', 8)
          starter.config.footer = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          -- INFO: based on @echasnovski's recommendation (thanks a lot!!!)
          if vim.bo[ev.buf].filetype == 'ministarter' then
            pcall(starter.refresh)
          end
        end,
      })
    end,
  },
}
