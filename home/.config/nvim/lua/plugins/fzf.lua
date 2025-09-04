return {
  'https://github.com/ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'https://github.com/nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  keys = {
    -- { '<C-p>', ':FzfLua<CR>', mode = { 'n', 'i' }, desc = '[FZ]F Menu' },
    { '<leader>F', ':FzfLua<CR>', mode = 'n', desc = '[FZ]F Menu' },
    { '<leader>fa', ':FzfLua args<CR>', mode = 'n', desc = '[F]ZF [A]rgument List' },
    { '<leader>fh', ':FzfLua helptags<CR>', mode = 'n', desc = '[F]ZF [H]elptags' },
    { '<leader>fk', ':FzfLua keymaps<CR>', mode = 'n', desc = '[F]ZF [K]eymaps' },
    { '<leader>ff', ':FzfLua files<CR>', mode = 'n', desc = '[F]ZF [F]iles' },
    { '<leader>fl', ':FzfLua blines<CR>', mode = 'n', desc = '[F]ZF [L]ines in Buffer' },
    { '<leader>fg', ':FzfLua git_bcommit<CR>', mode = 'n', desc = '[F]ZF [G]it Commits for Buffer' },
    { '<leader>fs', ':FzfLua live_grep<CR>', mode = 'n', desc = '[F]ZF Grep [S]earch' },
    { '<leader>fS', ':FzfLua live_grep resume=true<CR>', mode = 'n', desc = '[F]ZF Resume Grep [S]earch' },
    { '<leader>fs', ':FzfLua grep_visual<CR>', mode = 'x', desc = '[F]ZF Grep [S]earch Selection' },
    { '<leader>fc', ':FzfLua commands<CR>', mode = 'n', desc = '[F]ZF File [C]hanges' },
    { '<leader>fC', ':FzfLua command_history<CR>', mode = 'n', desc = '[F]ZF File [C]hanges' },
    { '<leader>fr', ':FzfLua oldfiles<CR>', mode = 'n', desc = '[F]ZF [O]ldfiles' },
    { '<leader>fb', ':FzfLua buffers sort_mru=true sort_lastused=true<CR>', mode = 'n', desc = '[F]ZF [B]uffers' },
    { '<leader>ft', ':FzfLua tabs<CR>', mode = 'n', desc = '[F]ZF [T]abs' },
    { '<leader>fM', ':FzfLua marks marks="%a"<CR>', mode = 'n', desc = '[F]ZF [M]arks' },
    -- { '<leader>fM', ':FzfLua marks<CR>', mode = 'n', desc = '[F]ZF [M]arks' },
    -- { '<leader>fm', "<Cmd>exec 'normal 1 mq' | cclose | FzfLua quickfix<CR>", mode = 'n', desc = '[F]ZF Book[M]arks' },
    -- { '<leader>fm', '<Cmd>doautocmd BufEnter<CR><Plug>BookmarkShowAll<Cmd>cclose | FzfLua quickfix<CR>', mode = 'n', desc = '[F]ZF Book[M]arks' },
    { '<leader>fj', ':FzfLua jumps<CR>', mode = 'n', desc = '[F]ZF [J]umps' },
    { '<leader>f<C-o>', ':FzfLua jumps<CR>', mode = 'n', desc = '[F]ZF [J]umps' },
    { '<leader>fv', ':FzfLua lsp_document_symbols<CR>', mode = 'n', { desc = '[F]ZF Document Symbols' } },
    { '<leader>fV', ':FzfLua lsp_live_workspace_symbols<CR>', mode = 'n', { desc = '[F]ZF Workspace Symbols' } },
    { '<leader>fd', ':FzfLua diagnostics_document<CR>', mode = 'n', { desc = '[F]ZF Document [D]iagnostics' } },
    { '<leader>fD', ':FzfLua diagnostics_workspace<CR>', mode = 'n', { desc = '[F]ZF Workspace [D]iagnostics' } },
    -- { '<leader>fq', ':FzfLua quickfix<CR>', mode = 'n', { desc = '[F]ZF [Q]uickfix' } },
    { '<leader>fq', ':FzfLua lgrep_quickfix<CR>', mode = 'n', { desc = '[F]ZF [Q]uickfix Contents' } },
    { '<leader>fz', ':FzfLua zoxide<CR>', mode = 'n', { desc = '[F]ZF [Z]oxide' } },
  },
  config = function()
    local fzf = require 'fzf-lua'
    local actions = require 'fzf-lua.actions'
    fzf.setup {
      winopts = {
        preview = {
          default = 'bat',
          layout = 'vertical',
          vertical = 'down:60%',
        },
      },
      keymap = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
          ['<F1>'] = 'toggle-help',
          ['<F2>'] = 'toggle-fullscreen',
          -- Only valid with the 'builtin' previewer
          ['<F3>'] = 'toggle-preview-wrap',
          ['<F4>'] = 'toggle-preview',
          -- Rotate preview clockwise/counter-clockwise
          ['<F5>'] = 'toggle-preview-ccw',
          ['<F6>'] = 'toggle-preview-cw',
          -- `ts-ctx` binds require `nvim-treesitter-context`
          ['<F7>'] = 'toggle-preview-ts-ctx',
          ['<F8>'] = 'preview-ts-ctx-dec',
          ['<F9>'] = 'preview-ts-ctx-inc',
          ['<S-down>'] = 'preview-page-down',
          ['<S-up>'] = 'preview-page-up',
          ['<S-left>'] = 'preview-page-reset',
        },
        fzf = {
          ['f3'] = 'toggle-preview-wrap',
          ['f4'] = 'toggle-preview',
          ['shift-down'] = 'half-page-down',
          ['shift-up'] = 'half-page-up',
        },
      },
      actions = {
        -- These override the default tables completely
        -- no need to set to `false` to disable an action
        -- delete or modify is sufficient
        files = {
          ['enter'] = actions.file_edit_or_qf,
          ['ctrl-o'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          -- ['alt-q'] = actions.file_sel_to_qf,
          -- ['alt-Q'] = actions.file_sel_to_ll,
          ['ctrl-g'] = actions.toggle_ignore,
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
        rg_opts = '--vimgrep --column --line-number --no-heading --color=always -e',
        hidden = true, -- enable hidden files by default
        follow = true, -- follow symlinks by default
        -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
        RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ['ctrl-/'] = actions.grep_lgrep,
          ['ctrl-g'] = actions.toggle_ignore,
        },
      },
      oldfiles = {
        cwd_only = true,
      },
    }
    fzf.register_ui_select()
  end,
}
