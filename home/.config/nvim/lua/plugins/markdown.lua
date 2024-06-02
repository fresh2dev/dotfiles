return {
  {
    'https://github.com/OXY2DEV/markview.nvim',
    -- ft = 'markdown',
    dependencies = {
      'https://github.com/nvim-treesitter/nvim-treesitter',
      'https://github.com/nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>tmr', ':Markview<CR>', mode = 'n', desc = '[T]oggle [M]arkdown [R]endering' },
    },
    opts = {
      modes = { 'n', 'i', 'no', 'c' },
      hybrid_modes = { 'i' },

      headings = {
        shift_width = 0,
      },
      code_blocks = {
        pad_amount = 0,
      },
      list_items = {
        shift_width = 0,
      },
    },
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
