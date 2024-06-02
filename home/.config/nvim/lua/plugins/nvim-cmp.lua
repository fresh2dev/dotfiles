return { -- Autocompletion
  'https://github.com/hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help',
    -- 'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-buffer',
    -- 'https://github.com/hrsh7th/cmp-cmdline',
    -- Snippet Engine & its associated nvim-cmp source
    'https://github.com/saadparwaiz1/cmp_luasnip',
    'https://github.com/L3MON4D3/LuaSnip',
  },
  config = function()
    -- See `:help cmp`
    local luasnip = require 'luasnip'
    local cmp = require 'cmp'
    luasnip.config.setup {}

    local function select_next_item(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      else
        fallback()
      end
    end

    local function select_prev_item(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
      else
        fallback()
      end
    end

    -- Scroll the documentation window [b]ack / [f]orward
    local function scroll_docs(direction, fallback)
      if cmp.visible() then
        cmp.scroll_docs(direction)
      else
        fallback()
      end
    end

    local function scroll_docs_down(fallback)
      scroll_docs(4, fallback)
    end

    local function scroll_docs_up(fallback)
      scroll_docs(-4, fallback)
    end

    local function accept_selection(fallback)
      if cmp.visible() then
        if not cmp.get_active_entry() then
          cmp.select_next_item()
        end
        cmp.confirm { select = true }
      else
        fallback()
      end
    end

    local function accept_if_selection(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm { select = true }
      else
        fallback()
      end
    end

    local function close(fallback)
      if not cmp.visible() then
        cmp.close()
      else
        fallback()
      end
    end

    local function jump_or_select_next(fallback)
      if luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        select_next_item(fallback)
      end
    end

    local function jump_or_select_prev(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        select_prev_item(fallback)
      end
    end

    local function jump_next_or_confirm(fallback)
      if luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        accept_selection(fallback)
      end
    end

    local function jump_back_or_close(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        close(fallback)
      end
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert,noselect' }, -- ,noselect

      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item

        ['<C-n>'] = cmp.mapping(select_next_item, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(select_prev_item, { 'i', 's' }),
        ['<C-y>'] = cmp.mapping(accept_selection, { 'i', 's' }),

        ['<C-Space>'] = cmp.mapping(accept_selection, { 'i', 's' }),
        ['<CR>'] = cmp.mapping(accept_if_selection, { 'i', 's' }),

        ['<C-j>'] = cmp.mapping(jump_or_select_next, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(jump_or_select_prev, { 'i', 's' }),

        ['<C-l>'] = cmp.mapping(jump_next_or_confirm, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(jump_back_or_close, { 'i', 's' }),

        ['<C-u>'] = cmp.mapping(scroll_docs_up, { 'i', 's' }),
        ['<C-d>'] = cmp.mapping(scroll_docs_down, { 'i', 's' }),

        -- -- Manually trigger a completion from nvim-cmp.
        -- --  Generally you don't need this, because nvim-cmp will display
        -- --  completions whenever it has completion options available.
        -- ['<C-Space>'] = cmp.mapping.complete {},

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
      },
      sources = cmp.config.sources({
        {
          name = 'lazydev',
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
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
