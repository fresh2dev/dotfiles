return { -- Highlight, edit, and navigate code
  {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'https://github.com/RRethy/nvim-treesitter-textsubjects',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          'bash',
          'c',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'vim',
          'vimdoc',
          'json',
          'jsonc',
          'yaml',
          'python',
        },
        matchup = {
          enable = true, -- mandatory, false will disable the whole extension
          disable_virtual_text = true,
        },
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            ['ac'] = 'textsubjects-container-outer',
            ['ic'] = { 'textsubjects-container-inner', desc = 'Select inside containers (classes, functions, etc.)' },
          },
        },
      }
    end,
  },
  {
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    enabled = true,
    dependencies = {
      'https://github.com/nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '[T',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Jump Up to Treesitter Context',
        { silent = true },
      },
      -- {
      --   '<leader>tp',
      --   function()
      --     require('treesitter-context').toggle()
      --   end,
      --   desc = '[T]oggle [P]arent Context (Treesitter Context)',
      --   { silent = true },
      -- },
    },
    config = function(_, opts)
      require('treesitter-context').setup {
        mode = 'cursor',
        -- mode = 'topline',
        separator = '_',
        max_lines = 1,
      }
    end,
  },
}
