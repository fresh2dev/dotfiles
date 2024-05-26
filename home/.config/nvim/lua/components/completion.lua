return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    -- 'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    -- 'hrsh7th/cmp-cmdline',
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    -- See `:help cmp`
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' }, -- ,noselect

      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping.confirm { select = true },

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        ['<Tab>'] = cmp.mapping(function(fallback)
          local function previous_char_is_space()
            local col = vim.fn.col '.' - 1
            return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
          end
          if previous_char_is_space() then
            fallback()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- ['<CR>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.confirm { select = true }
        --   else
        --     fallback()
        --   end
        -- end),

        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    }

    -- -- Set configuration for specific filetype.
    -- cmp.setup.filetype('gitcommit', {
    --   sources = cmp.config.sources({
    --     { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    --   }, {
    --     { name = 'buffer' },
    --   }),
    -- })

    -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline({ '/', '?' }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = {
    --     { name = 'buffer' },
    --   },
    -- })

    -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    -- cmp.setup.cmdline(':', {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = 'path' }
    --   }, {
    --     { name = 'cmdline' }
    --   }),
    --   matching = { disallow_symbol_nonprefix_matching = false }
    -- })
  end,
}
