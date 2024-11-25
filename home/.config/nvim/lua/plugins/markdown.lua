local file_types = { 'markdown', 'markdown.mdx' }

-- Takes the word under the cursor and puts it in the appropriate spot in a link.
-- If no word is under the cursor, insert the link syntax
-- derived from: https://github.com/ixru/nvim-markdown/blob/f8f8e4191677ccda257ad7ff73a8a36324e0a134/lua/markdown.lua#L533
local function create_link()
  local line = vim.fn.getline '.'
  local cursor = vim.api.nvim_win_get_cursor(0)
  local mode = vim.fn.mode '.'

  local new_line, new_cursor_pos
  if mode == 'v' then
    vim.cmd ':normal! ' -- Need to return to normal mode to set the below marks
    local start = vim.fn.getpos "'<"
    local stop = vim.fn.getpos "'>"

    -- Don't do anything if the visual selection spans multiple lines
    if start[2] ~= stop[2] then
      return
    else
      start = start[3]
      stop = stop[3]
    end

    local selection = line:sub(start, stop)
    if selection:match '/' or vim.fn.filereadable(selection) == 1 then
      new_line = line:sub(1, start - 1) .. '[]'
      new_cursor_pos = #new_line
      new_line = new_line .. '(' .. selection .. ')' .. line:sub(stop + 1)
    else
      new_line = line:sub(1, start - 1) .. '[' .. selection .. ']()'
      new_cursor_pos = #new_line
      new_line = new_line .. line:sub(stop + 1)
    end
  else
    return
  end

  vim.fn.setline('.', new_line)
  vim.fn.setpos('.', { 0, cursor[1], new_cursor_pos, 0 })
end
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = file_types,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>tmr',
        '<Cmd>RenderMarkdown toggle<CR>',
        mode = 'n',
        ft = file_types,
        desc = '[T]oggle [M]arkdown [R]endering',
      },
      -- These are not specific to this plugin,
      -- but I had to put 'em somewhere.
      {
        'p',
        function()
          create_link()
          vim.cmd 'normal! P'
        end,
        mode = 'x',
        desc = 'Create Markdown Link',
        ft = file_types,
      },
      -- {
      --   'gl',
      --   function()
      --     create_link()
      --     vim.cmd 'startinsert'
      --   end,
      --   ft = file_types,
      --   desc = 'Create Markdown Link',
      --   mode = 'x',
      -- },
    },
    config = function()
      require('render-markdown').setup {
        -- Whether Markdown should be rendered by default or not
        enabled = true,
        file_types = file_types,
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
    ft = file_types,
    dependencies = {
      {
        'https://github.com/gaoDean/autolist.nvim',
        ft = file_types,
        keys = {
          { '<tab>', '<cmd>AutolistTab<cr>', mode = 'i' },
          { '<s-tab>', '<cmd>AutolistShiftTab<cr>', mode = 'i' },

          { '<CR>', '<CR><cmd>AutolistNewBullet<cr>', mode = 'i' },
          { 'o', 'o<cmd>AutolistNewBullet<cr>', mode = 'n' },
          { 'O', 'O<cmd>AutolistNewBulletBefore<cr>', mode = 'n' },
          -- { '<CR>', '<cmd>AutolistToggleCheckbox<cr><CR>k', mode = 'n' },
          -- functions to recalculate list on edit
          { '>>', '>><cmd>AutolistRecalculate<cr>', mode = 'n' },
          { '<<', '<<<cmd>AutolistRecalculate<cr>', mode = 'n' },
          { 'dd', 'dd<cmd>AutolistRecalculate<cr>', mode = 'n' },
          { 'd', 'd<cmd>AutolistRecalculate<cr>', mode = 'v' },
        },
        config = function()
          local autolist = require 'autolist'

          autolist.setup {
            cycle = { '-', '1.' },
            colon = { -- if a line ends in a colon
              indent = false, -- if in list and line ends in `:` then create list
              indent_raw = false, -- above, but doesn't need to be in a list to work
            },
          }

          -- Dot-repeatable function to toggle type of existing list
          -- (requires that the list already exists in normal mode)
          vim.keymap.set('n', '<leader>t-', autolist.cycle_next_dr, { expr = true })
        end,
      },
    },
    config = function()
      local mdtoggle = require 'markdown-toggle'
      local autolist = require 'autolist'

      ---@diagnostic disable-next-line: missing-fields
      mdtoggle.setup {
        -- If true, the auto-setup for the default keymaps is enabled
        use_default_keymaps = false,
        -- The keymaps are valid only for these filetypes
        filetypes = file_types,

        -- The list marks table used in cycle-mode (list_table[1] is used as the default list-mark)
        list_table = { '-', '1.' },
        -- Cycle the marks in user-defined table when toggling lists
        cycle_list_table = true,

        -- The checkbox marks table used in cycle-mode (box_table[1] is used as the default checked-state)
        box_table = { 'x' },
        -- Cycle the marks in user-defined table when toggling checkboxes
        cycle_box_table = false,
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

          -- Cycle list type with `markdown-toggle` and recalculate with `autolist`
          -- (does not require that the list already exists in visual mode)
          vim.keymap.set({ 'x' }, '<leader>t-', function()
            mdtoggle.list()
            autolist.recalculate()
          end, opts)

          -- Toggle (or create) checkbox.
          vim.keymap.set('x', '<leader>t[', mdtoggle.checkbox_cycle, opts)
          vim.keymap.set('x', '<leader>t]', mdtoggle.checkbox_cycle, opts)
          opts.expr = true -- required for dot-repeat in Normal mode
          vim.keymap.set('n', '<leader>t[', mdtoggle.checkbox_cycle_dot, opts)
          vim.keymap.set('n', '<leader>t]', mdtoggle.checkbox_cycle_dot, opts)
        end,
      })
    end,
  },
  {
    'https://github.com/mzlogin/vim-markdown-toc',
    ft = file_types,
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
