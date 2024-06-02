return { -- flash.nvim lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
  'https://github.com/folke/flash.nvim',
  version = 'v2',
  event = 'VeryLazy',
  -- stylua: ignore
  keys = {
    { "<leader><leader>", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Jump (Flash)" },
    -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote (Flash)" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  opts = {
    search = {
      ---@type Flash.Pattern.Mode
      -- Each mode will take ignorecase and smartcase into account.
      -- * exact: exact match
      -- * search: regular search
      -- * fuzzy: fuzzy search
      -- * fun(str): custom function that returns a pattern
      --   For example, to only match at the beginning of a word:
      --   mode = function(str)
      --     return "\\<" .. str
      --   end,
      mode = 'exact',
      -- behave like `incsearch`
      incremental = false,
    },
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = 'start', ---@type "start" | "end" | "range"
      -- add pattern to search history
      history = false,
      -- add pattern to search register
      register = false,
      -- clear highlight after jump
      nohlsearch = false,
      -- automatically jump when there is only one match
      autojump = false,
      -- You can force inclusive/exclusive jumps by setting the
      -- `inclusive` option. By default it will be automatically
      -- set based on the mode.
      inclusive = nil, ---@type boolean?
      -- jump position offset. Not used for range jumps.
      -- 0: default
      -- 1: when pos == "end" and pos < current position
      offset = nil, ---@type number
    },
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add a label for the first match in the current window.
      -- you can always jump to the first match with `<CR>`
      current = true,
      -- show the label after the match
      after = true, ---@type boolean|number[]
      -- show the label before the match
      before = false, ---@type boolean|number[]
      -- position of the label extmark
      -- style = 'overlay', ---@type "eol" | "overlay" | "right_align" | "inline"
      style = 'eol', ---@type "eol" | "overlay" | "right_align" | "inline"
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = 'lowercase', ---@type "lowercase" | "all" | "none"
      -- for the current window, label targets closer to the cursor first
      distance = true,
      -- minimum pattern length to show labels
      -- Ignored for custom labelers.
      min_pattern_length = 0,
      -- Enable this to use rainbow colors to highlight labels
      -- Can be useful for visualizing Treesitter ranges.
      rainbow = {
        enabled = true,
        -- number between 1 and 9
        shade = 5,
      },
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = true,
      -- Highlight the search matches
      matches = true,
    },
    -- When `true`, flash will try to continue the last search
    continue = false,
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        -- when `true`, flash will be activated during regular search by default.
        -- You can always toggle when searching with `require("flash").toggle()`
        enabled = false,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- `forward` will be automatically set to the search direction
          -- `mode` is always set to `search`
          -- `incremental` is set to `true` when `incsearch` is enabled
        },
      },
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = false,
        -- hide after jump when not using jump labels
        autohide = false,
        -- show jump labels
        jump_labels = false,
        -- set to `false` to use the current line only
        multi_line = true,
        -- by default all keymaps are enabled, but you can disable some of them,
        -- by removing them from the list.
        -- If you rather use another key, you can map them
        -- to something else, e.g., { [";"] = "L", [","] = H }
        keys = { 'f', 'F', 't', 'T', ';', ',' },
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = {
          register = false,
          -- when using jump labels, set to 'true' to automatically jump
          -- or execute a motion when there is only one match
          autojump = false,
        },
      },
      treesitter = {
        jump = { pos = 'range', autojump = true },
        search = { incremental = false },
        label = { before = true, after = true, style = 'inline' },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
      treesitter_search = {
        jump = { pos = 'range' },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = 'inline' },
      },
      -- options used for remote flash
      remote = {
        remote_op = { restore = true, motion = true },
      },
    },
    -- options for remote operator pending mode
    remote_op = {
      -- restore window views and cursor position
      -- after doing a remote operation
      restore = true,
      -- For `jump.pos = "range"`, this setting is ignored.
      -- `true`: always enter a new motion when doing a remote operation
      -- `false`: use the window's cursor position and jump target
      -- `nil`: act as `true` for remote windows, `false` for the current window
      motion = false,
    },
  },
}
