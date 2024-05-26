return {
  -- {
  --   'lukas-reineke/headlines.nvim',
  --   ft = 'markdown', -- loads plugin for markdown files only
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   config = true,
  -- },
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup {
        -- Configure whether Markdown should be rendered by default or not
        start_enabled = true,
        -- Maximum file size (in MB) that this plugin will attempt to render
        -- Any file larger than this will effectively be ignored
        max_file_size = 1.5,
        -- The level of logs to write to file: vim.fn.stdpath('state') .. '/render-markdown.log'
        -- Only intended to be used for plugin development / debugging
        log_level = 'error',
        -- Filetypes this plugin will run on
        file_types = { 'markdown' },
        -- Vim modes that will show a rendered view of the markdown file
        -- All other modes will be uneffected by this plugin
        render_modes = { 'n', 'c' },
        -- Characters that will replace the # at the start of headings
        headings = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        -- Character to use for the horizontal break
        dash = '—',
        -- Character to use for the bullet points in lists
        bullets = { '●', '○', '◆', '◇' },
        checkbox = {
          -- Character that will replace the [ ] in unchecked checkboxes
          unchecked = '󰄱 ',
          -- Character that will replace the [x] in checked checkboxes
          checked = ' ',
        },
        -- Character that will replace the > at the start of block quotes
        quote = '┃',
        -- Symbol / text to use for different callouts
        callout = {
          note = '  Note',
          tip = '  Tip',
          important = '󰅾  Important',
          warning = '  Warning',
          caution = '󰳦  Caution',
        },
        -- See :h 'conceallevel' for more information about meaning of values
        conceal = {
          -- conceallevel used for buffer when not being rendered, get user setting
          default = vim.opt.conceallevel:get(),
          -- conceallevel used for buffer when being rendered
          rendered = 3,
        },
        -- Determines how tables are rendered
        --  full: adds a line above and below tables + normal behavior
        --  normal: renders the rows of tables
        --  none: disables rendering, use this if you prefer having cell highlights
        table_style = 'full',
        -- Define the highlight groups to use when rendering various components
        highlights = {
          heading = {
            -- Background of heading line
            backgrounds = { 'DiffAdd', 'DiffChange' },
            -- Foreground of heading character only
            foregrounds = {
              'markdownH1',
              'markdownH2',
              'markdownH3',
              'markdownH4',
              'markdownH5',
              'markdownH6',
            },
          },
          -- Horizontal break
          dash = 'LineNr',
          -- Code blocks
          code = 'ColorColumn',
          -- Bullet points in list
          bullet = 'Normal',
          -- Highlights to use for different callouts
          callout = {
            note = 'DiagnosticInfo',
            tip = 'DiagnosticOk',
            important = 'DiagnosticHint',
            warning = 'DiagnosticWarn',
            caution = 'DiagnosticError',
          },
        },
      }
    end,
  },
  {
    'preservim/vim-markdown',
    ft = 'markdown',
    config = function()
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
      'godlygeek/tabular',
      cmd = 'TableFormat',
    },
  },
  {
    'mzlogin/vim-markdown-toc',
    ft = 'markdown',
    cmd = { 'GenTocGFM', 'UpdateToc' },
    config = function()
      vim.g.vmt_auto_update_on_save = 0
      vim.g.vmt_fence_text = 'TOC'
      vim.g.vmt_fence_closing_text = '/TOC'
      vim.g.vmt_fence_hidden_markdown_style = 'GFM'
      vim.g.vmt_list_item_char = '*'
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}
