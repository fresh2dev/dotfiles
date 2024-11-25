return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>tmr', '<Cmd>RenderMarkdown toggle<CR>', mode = 'n', desc = '[T]oggle [M]arkdown [R]endering' },
    },
    config = function()
      require('render-markdown').setup {
        -- Whether Markdown should be rendered by default or not
        enabled = true,
        file_types = { 'markdown' },
        heading = {
          -- Turn on / off heading icon & background rendering
          enabled = true,
          -- Turn on / off any sign column related rendering
          sign = false,
          -- Determines how icons fill the available space:
          --  inline:  underlying '#'s are concealed resulting in a left aligned icon
          --  overlay: result is left padded with spaces to hide any additional '#'
          position = 'overlay',
          -- Replaces '#+' of 'atx_h._marker'
          -- The number of '#' in the heading determines the 'level'
          -- The 'level' is used to index into the list using a cycle
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
          -- icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
          -- Width of the heading background:
          --  block: width of the heading text
          --  full:  full width of the window
          -- Can also be a list of the above values in which case the 'level' is used
          -- to index into the list using a clamp
          width = { 'full', 'full', 'block', 'block', 'block', 'block' },
          -- Amount of padding to add to the right of headings when width is 'block'
          -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
          -- Can also be a list of numbers in which case the 'level' is used to index into the list using a clamp
          right_pad = { 0, 0, 2, 3, 4, 5 },
          -- Minimum width to use for headings when width is 'block'
          -- Can also be a list of integers in which case the 'level' is used to index into the list using a clamp
          min_width = 0,
          -- Determines if a border is added above and below headings
          border = true,
          -- Always use virtual lines for heading borders instead of attempting to use empty lines
          border_virtual = true,
          -- Highlight the start of the border using the foreground highlight
          border_prefix = false,
        },
        code = {
          -- Turn on / off code block & inline code rendering
          enabled = true,
          -- Turn on / off any sign column related rendering
          sign = false,
          -- Determines how code blocks & inline code are rendered:
          --  none:     disables all rendering
          --  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
          --  language: adds language icon to sign column if enabled and icon + name above code blocks
          --  full:     normal + language
          style = 'full',
          -- Determines where language icon is rendered:
          --  right: right side of code block
          --  left:  left side of code block
          position = 'left',
          -- Amount of padding to add around the language
          -- If a floating point value < 1 is provided it is treated as a percentage of the available window space
          language_pad = 0,
          -- Whether to include the language name next to the icon
          language_name = true,
          -- A list of language names for which background highlighting will be disabled
          -- Likely because that language has background highlights itself
          -- Or a boolean to make behavior apply to all languages
          -- Borders above & below blocks will continue to be rendered
          disable_background = { 'diff' },
          -- Width of the code block background:
          --  block: width of the code block
          --  full:  full width of the window
          width = 'block',
          right_pad = 1,
          -- Minimum width to use for code blocks when width is 'block'
          min_width = 0,
        },
        sign = {
          -- Turn on / off sign rendering
          enabled = false,
        },
        -- Window options to use that change between rendered and raw view
        win_options = {
          -- See :h 'conceallevel'
          conceallevel = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value('conceallevel', {}),
            -- Used when being rendered, concealed text is completely hidden
            rendered = 3,
          },
          -- See :h 'concealcursor'
          concealcursor = {
            -- Used when not being rendered, get user setting
            default = vim.api.nvim_get_option_value('concealcursor', {}),
            -- Used when being rendered, disable concealing text in all modes
            rendered = '',
          },
        },
        -- More granular configuration mechanism, allows different aspects of buffers
        -- to have their own behavior. Values default to the top level configuration
        -- if no override is provided. Supports the following fields:
        --   enabled, max_file_size, debounce, render_modes, anti_conceal, padding,
        --   heading, paragraph, code, dash, bullet, checkbox, quote, pipe_table,
        --   callout, link, sign, indent, win_options
        overrides = {
          -- Overrides for different buftypes, see :h 'buftype'
          buftype = {
            nofile = {
              padding = { highlight = 'NormalFloat' },
              sign = { enabled = false },
            },
          },
          -- Overrides for different filetypes, see :h 'filetype'
          filetype = {},
        },
      }
    end,
  },
  {
    'https://github.com/roodolv/markdown-toggle.nvim',
    ft = 'markdown',
    config = function()
      local file_types = { 'markdown', 'markdown.mdx', 'Avante' }
      ---@diagnostic disable-next-line: missing-fields
      require('markdown-toggle').setup {
        -- If true, the auto-setup for the default keymaps is enabled
        use_default_keymaps = false,
        -- The keymaps are valid only for these filetypes
        filetypes = file_types,

        -- The list marks table used in cycle-mode (list_table[1] is used as the default list-mark)
        list_table = { '-', '+', '*', '=' },
        -- Cycle the marks in user-defined table when toggling lists
        cycle_list_table = false,

        -- The checkbox marks table used in cycle-mode (box_table[1] is used as the default checked-state)
        box_table = { 'x', '-' },
        -- Cycle the marks in user-defined table when toggling checkboxes
        cycle_box_table = true,
        -- A bullet list is toggled before turning into a checkbox (similar to how it works in Obsidian).
        list_before_box = false,

        -- Skip blank lines and headings in Visual mode (except for `quote()`)
        enable_blankhead_skip = true,
        -- Insert an indented quote for new lines within quoted text
        enable_inner_indent = false,
        -- Toggle only unmarked lines first
        enable_unmarked_only = true,
        -- Automatically continue lists on new lines
        enable_autolist = true,
        -- Maintain checkbox state when continuing lists
        enable_auto_samestate = false,
        -- Dot-repeat for toggle functions in Normal mode
        enable_dot_repeat = true,
      }

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'markdown-toggle.nvim keymaps',
        pattern = file_types,
        callback = function(args)
          local opts = { silent = true, noremap = true, buffer = args.buf }
          local toggle = require 'markdown-toggle'

          -- Keymap configurations will be added here for each feature
          vim.keymap.set('n', 'O', toggle.autolist_up, opts)
          vim.keymap.set('n', 'o', toggle.autolist_down, opts)
          vim.keymap.set('i', '<CR>', toggle.autolist_cr, opts)

          opts.expr = true -- required for dot-repeat in Normal mode
          -- vim.keymap.set('n', '<leader>t1', toggle.olist_dot, opts)
          vim.keymap.set('n', '<leader>t-', toggle.list_dot, opts)
          vim.keymap.set('n', '<leader>t[', toggle.checkbox_cycle_dot, opts)
          vim.keymap.set('n', '<leader>t]', toggle.checkbox_cycle_dot, opts)

          opts.expr = false -- required for Visual mode
          -- vim.keymap.set('x', '<C-n>', toggle.olist, opts)
          -- vim.keymap.set('x', '<leader>t1', toggle.olist, opts)
          vim.keymap.set('x', '<leader>t-', toggle.list, opts)
          vim.keymap.set('x', '<leader>t[', toggle.checkbox_cycle, opts)
          vim.keymap.set('x', '<leader>t]', toggle.checkbox_cycle, opts)
        end,
      })
    end,
  },
  {
    'https://github.com/preservim/vim-markdown',
    ft = 'markdown',
    init = function()
      vim.g.vim_markdown_no_default_key_mappings = 1
      -- vim.g.vim_markdown_folding_level = 1
      -- vim.g.vim_markdown_folding_style_pythonic = 1
      vim.g.vim_markdown_folding_disabled = 0
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_new_list_item_indent = 4
    end,
    dependencies = {
      { 'https://github.com/godlygeek/tabular', cmd = 'TableFormat' },
    },
  },
  {
    'https://github.com/mzlogin/vim-markdown-toc',
    ft = 'markdown',
    cmd = { 'GenTocGFM', 'UpdateToc' },
    init = function()
      vim.g.vmt_auto_update_on_save = 0
      vim.g.vmt_fence_text = 'TOC'
      vim.g.vmt_fence_closing_text = '/TOC'
      vim.g.vmt_fence_hidden_markdown_style = 'GFM'
      vim.g.vmt_list_item_char = '*'
    end,
  },
}
