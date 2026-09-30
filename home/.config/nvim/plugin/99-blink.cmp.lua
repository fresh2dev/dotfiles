vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
})

-- DOCS: https://cmp.saghen.dev
require("blink.cmp").setup({
  keymap = {
    -- https://cmp.saghen.dev/configuration/keymap.html#super-tab
    preset = "default",
    -- ['<C-e>'] = { 'hide', 'fallback' },
    -- ['<C-y>'] = { 'select_and_accept', 'fallback' },
    -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    -- ['<C-p>'] = { 'select_prev', 'fallback' },
    -- ['<C-n>'] = { 'select_next', 'fallback' },
    --
    ["<Tab>"] = {
      function(_cmp)
        if require("blink.cmp.completion.list").get_selected_item() then
          -- Only accept on tab if an item is selected.
          return _cmp.accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = "mono",
  },
  cmdline = {
    enabled = true,
    keymap = {
      preset = "cmdline",
      ["<down>"] = { "select_next", "fallback" },
      ["<up>"] = { "select_prev", "fallback" },
      ["<left>"] = { "fallback" },
      ["<right>"] = { "fallback" },
    },
    sources = function()
      local type = vim.fn.getcmdtype()
      -- Search forward and backward
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      -- Commands
      if type == ":" or type == "@" then
        return { "cmdline" }
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
    -- Disable in prompt / explorer buffers
    local filetype = vim.bo[0].filetype
    if
      filetype == "minifiles"
      or filetype == "snacks_picker_input"
      or filetype == "fugitive"
    then
      return false
    end
    return true
  end,
  completion = {
    keyword = { range = "full" },

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
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" },
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
  -- Shows a signature help window while you type arguments for a function
  signature = {
    enabled = true,
    window = {
      show_documentation = false,
    },
  },
  sources = {
    -- list of enabled providers. `lazydev` is only added for Lua buffers, where
    -- ftplugin/lua_lazydev.lua has already installed and configured it.
    default = function()
      local sources = { "lsp", "path", "buffer" }
      if vim.bo.filetype == "lua" then
        table.insert(sources, 1, "lazydev")
      end
      return sources
    end,

    -- table of providers to configure
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority
        score_offset = 100,
      },

      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
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
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})
