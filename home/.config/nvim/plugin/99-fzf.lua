vim.pack.add({
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local actions = require("fzf-lua.actions")
local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    preview = {
      default = "bat",
      layout = "vertical",
      vertical = "down:60%",
    },
  },
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      ["<F1>"] = "toggle-help",
      ["<F2>"] = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"] = "toggle-preview-wrap",
      ["<F4>"] = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"] = "toggle-preview-ccw",
      ["<F6>"] = "toggle-preview-cw",
      -- `ts-ctx` binds require `nvim-treesitter-context`
      ["<F7>"] = "toggle-preview-ts-ctx",
      ["<F8>"] = "preview-ts-ctx-dec",
      ["<F9>"] = "preview-ts-ctx-inc",
      ["<S-down>"] = "preview-page-down",
      ["<S-up>"] = "preview-page-up",
      ["<S-left>"] = "preview-page-reset",
    },
    fzf = {
      ["f3"] = "toggle-preview-wrap",
      ["f4"] = "toggle-preview",
      ["shift-down"] = "half-page-down",
      ["shift-up"] = "half-page-up",
    },
  },
  actions = {
    -- These override the default tables completely
    -- no need to set to `false` to disable an action
    -- delete or modify is sufficient
    files = {
      ["enter"] = actions.file_edit_or_qf,
      ["ctrl-o"] = actions.file_split,
      ["ctrl-v"] = actions.file_vsplit,
      ["ctrl-t"] = actions.file_tabedit,
      -- ['alt-q'] = actions.file_sel_to_qf,
      -- ['alt-Q'] = actions.file_sel_to_ll,
      ["ctrl-g"] = actions.toggle_ignore,
      -- ['ctrl-h'] = actions.toggle_hidden,
      -- ['ctrl-f'] = actions.toggle_follow,
    },
  },
  -- PROVIDERS SETUP
  -- use `defaults` (table or function) if you wish to set "global-provider" defaults
  -- for example, disabling file icons globally and open the quickfix list at the top
  --   defaults = {
  --     file_icons   = false,
  --     copen        = "topleft copen",
  --   },
  grep = {
    rg_opts = "--vimgrep --column --line-number --no-heading --color=always -e",
    hidden = true, -- enable hidden files by default
    follow = true, -- follow symlinks by default
    -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
    RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
    actions = {
      -- actions inherit from 'actions.files' and merge
      -- this action toggles between 'grep' and 'live_grep'
      ["ctrl-/"] = actions.grep_lgrep,
      ["ctrl-g"] = actions.toggle_ignore,
    },
  },
  oldfiles = {
    cwd_only = true,
  },
})
fzf.register_ui_select()

vim.keymap.set("n", "<leader>F", "<Cmd>FzfLua<CR>", { desc = "[FZ]F Menu" })
vim.keymap.set(
  "n",
  "<leader>fa",
  "<Cmd>FzfLua args<CR>",
  { desc = "[F]ZF [A]rgument List" }
)
vim.keymap.set(
  "n",
  "<leader>fh",
  "<Cmd>FzfLua helptags<CR>",
  { desc = "[F]ZF [H]elptags" }
)
vim.keymap.set(
  "n",
  "<leader>fk",
  "<Cmd>FzfLua keymaps<CR>",
  { desc = "[F]ZF [K]eymaps" }
)
vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "[F]ZF [F]iles" })
vim.keymap.set(
  "n",
  "<leader>fl",
  "<Cmd>FzfLua blines<CR>",
  { desc = "[F]ZF [L]ines in Buffer" }
)
vim.keymap.set(
  "n",
  "<leader>fg",
  "<Cmd>FzfLua git_bcommit<CR>",
  { desc = "[F]ZF [G]it Commits for Buffer" }
)
vim.keymap.set(
  "n",
  "<leader>fs",
  "<Cmd>FzfLua live_grep<CR>",
  { desc = "[F]ZF Grep [S]earch" }
)
vim.keymap.set(
  "n",
  "<leader>fS",
  "<Cmd>FzfLua live_grep resume=true<CR>",
  { desc = "[F]ZF Grep [S]earch (resume)" }
)
vim.keymap.set(
  "x",
  "<leader>fs",
  "<Cmd>FzfLua grep_visual<CR>",
  { desc = "[F]ZF Grep [S]earch Selection" }
)
vim.keymap.set(
  "n",
  "<leader>fc",
  "<Cmd>FzfLua commands<CR>",
  { desc = "[F]ZF [C]ommands" }
)
vim.keymap.set(
  "n",
  "<leader>fC",
  "<Cmd>FzfLua command_history<CR>",
  { desc = "[F]ZF [C]ommands (history)" }
)
vim.keymap.set(
  "n",
  "<leader>fr",
  "<Cmd>FzfLua oldfiles<CR>",
  { desc = "[F]ZF [O]ldfiles" }
)
vim.keymap.set(
  "n",
  "<leader>fb",
  "<Cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>",
  { desc = "[F]ZF [B]uffers" }
)
vim.keymap.set("n", "<leader>ft", "<Cmd>FzfLua tabs<CR>", { desc = "[F]ZF [T]abs" })
vim.keymap.set(
  "n",
  '<leader>f"',
  "<Cmd>FzfLua registers<CR>",
  { desc = "[F]ZF Registers" }
)
-- { '<leader>fM', '<Cmd>FzfLua marks<CR>', mode = 'n', desc = '[F]ZF [M]arks' },
-- { '<leader>fm', "<Cmd>exec 'normal 1 mq' | cclose | FzfLua quickfix<CR>", mode = 'n', desc = '[F]ZF Book[M]arks' },
-- { '<leader>fm', '<Cmd>doautocmd BufEnter<CR><Plug>BookmarkShowAll<Cmd>cclose | FzfLua quickfix<CR>', mode = 'n', desc = '[F]ZF Book[M]arks' },
vim.keymap.set("n", "<leader>fj", "<Cmd>FzfLua jumps<CR>", { desc = "[F]ZF [J]umps" })
vim.keymap.set(
  "n",
  "<leader>f<C-o>",
  "<Cmd>FzfLua jumps<CR>",
  { desc = "[F]ZF [J]umps" }
)
vim.keymap.set(
  "n",
  "gs",
  "<Cmd>FzfLua lsp_document_symbols<CR>",
  { desc = "FZF Document [S]ymbols" }
)
vim.keymap.set(
  "n",
  "gS",
  "<Cmd>FzfLua lsp_live_workspace_symbols<CR>",
  { desc = "FZF Workspace [S]ymbols" }
)
vim.keymap.set(
  "n",
  "<leader>fd",
  "<Cmd>FzfLua diagnostics_document<CR>",
  { desc = "[F]ZF Document [D]iagnostics" }
)
vim.keymap.set(
  "n",
  "<leader>fD",
  "<Cmd>FzfLua diagnostics_workspace<CR>",
  { desc = "[F]ZF Workspace [D]iagnostics" }
)
-- { '<leader>fq', '<Cmd>FzfLua quickfix<CR>', mode = 'n', { desc = '[F]ZF [Q]uickfix' } },
vim.keymap.set(
  "n",
  "<leader>fq",
  "<Cmd>FzfLua lgrep_quickfix<CR>",
  { desc = "[F]ZF [Q]uickfix Contents" }
)
vim.keymap.set("n", "<leader>fz", "<Cmd>FzfLua zoxide<CR>", { desc = "[F]ZF [Z]oxide" })
