return {
  'https://github.com/ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'https://github.com/nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  keys = {
    -- Disabled in favor of `legendary.nvim`
    -- { '<C-p>', ':FzfLua<CR>', mode = 'n', desc = '[FZ]F Menu' },
    { '<leader>F', ':FzfLua<CR>', mode = 'n', desc = '[FZ]F Menu' },
    { '<leader>fa', ':FzfLua args<CR>', mode = 'n', desc = '[F]ZF [A]rgument List' },
    { '<leader>fh', ':FzfLua helptags<CR>', mode = 'n', desc = '[F]ZF [H]elptags' },
    -- Disabled in favor of `legendary.nvim`
    -- { '<leader>fk', ':FzfLua keymaps<CR>', mode = 'n', desc = '[F]ZF [K]eymaps' },
    { '<leader>ff', ':FzfLua files<CR>', mode = 'n', desc = '[F]ZF [F]iles' },
    { '<leader>fl', ':FzfLua blines<CR>', mode = 'n', desc = '[F]ZF [L]ines in Buffer' },
    { '<leader>fg', ':FzfLua git_bcommit<CR>', mode = 'n', desc = '[F]ZF [G]it Commits for Buffer' },
    { '<leader>fs', ':FzfLua live_grep_glob<CR>', mode = 'n', desc = '[F]ZF Grep [S]earch' },
    { '<leader>fS', ':FzfLua live_grep_glob resume=true<CR>', mode = 'n', desc = '[F]ZF Resume Grep [S]earch' },
    -- Disabled in favor of `legendary.nvim`
    -- { '<leader>fc', ':FzfLua changes<CR>', mode = 'n', desc = '[F]ZF File [C]hanges' },
    { '<leader>fo', ':FzfLua oldfiles<CR>', mode = 'n', desc = '[F]ZF [O]ldfiles' },
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
    { '<leader>fq', ':FzfLua quickfix<CR>', mode = 'n', { desc = '[F]ZF [Q]uickfix' } },
    { '<leader>fQ', ':FzfLua loclist<CR>', mode = 'n', { desc = '[F]ZF [Q]uickfix Stack' } },
  },
  config = function()
    local fzf = require 'fzf-lua'
    local actions = require 'fzf-lua.actions'
    fzf.setup {
      -- 'fzf-vim',
      winopts = {
        fullscreen = false, -- start fullscreen?
        preview = {
          layout = 'vertical',
          vertical = 'down:60%',
        },
        on_create = function()
          -- called once upon creation of the fzf main window
          -- can be used to add custom fzf-lua mappings, e.g:
          vim.keymap.set('t', '<C-j>', '<Down>', { silent = true, buffer = true })
          vim.keymap.set('t', '<C-k>', '<Up>', { silent = true, buffer = true })
        end,
        -- called once *after* the fzf interface is closed
        -- on_close = function() ... end
      },
      keymap = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          ['<F1>'] = 'toggle-help',
          ['<F2>'] = 'toggle-fullscreen',
          -- Only valid with the 'builtin' previewer
          ['<F3>'] = 'toggle-preview-wrap',
          ['<F4>'] = 'toggle-preview',
          -- Rotate preview clockwise/counter-clockwise
          ['<F5>'] = 'toggle-preview-ccw',
          ['<F6>'] = 'toggle-preview-cw',
          ['<S-down>'] = 'preview-page-down',
          ['<S-up>'] = 'preview-page-up',
          ['<S-left>'] = 'preview-page-reset',
        },
        fzf = {
          -- This should be set in environment variable $FZF_DEFAULT_OPTS
          -- -- fzf '--bind=' options
          -- ['ctrl-z'] = 'abort',
          -- -- ['ctrl-u'] = 'unix-line-discard',
          -- ['ctrl-d'] = 'half-page-down',
          -- ['ctrl-u'] = 'half-page-up',
          -- -- ['ctrl-a'] = 'beginning-of-line',
          -- -- ['ctrl-e'] = 'end-of-line',
          -- ['ctrl-a'] = 'toggle-all',
          -- -- Only valid with fzf previewers (bat/cat/git/etc)
          -- ['f3'] = 'toggle-preview-wrap',
          -- ['f4'] = 'toggle-preview',
          -- ['shift-down'] = 'preview-page-down',
          -- ['shift-up'] = 'preview-page-up',
        },
      },
      actions = {
        -- These override the default tables completely
        -- no need to set to `false` to disable an action
        -- delete or modify is sufficient
        files = {
          -- providers that inherit these actions:
          --   files, git_files, git_status, grep, lsp
          --   oldfiles, quickfix, loclist, tags, btags
          --   args
          -- default action opens a single selection
          -- or sends multiple selection to quickfix
          -- replace the default action with the below
          -- to open all files whether single or multiple
          -- ["default"]     = actions.file_edit,
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-o'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          -- ['alt-q'] = actions.file_sel_to_qf,
          -- ['alt-l'] = actions.file_sel_to_ll,
        },
        buffers = {
          -- providers that inherit these actions:
          --   buffers, tabs, lines, blines
          ['default'] = actions.buf_edit,
          ['ctrl-o'] = actions.buf_split,
          ['ctrl-v'] = actions.buf_vsplit,
          ['ctrl-t'] = actions.buf_tabedit,
        },
      },
      fzf_opts = {
        -- options are sent as `<left>=<right>`
        -- set to `false` to remove a flag
        -- set to `true` for a no-value flag
        -- for raw args use `fzf_args` instead
        ['--ansi'] = true,
        ['--info'] = 'inline-right', -- fzf < v0.42 = "inline"
        ['--height'] = '100%',
        ['--layout'] = 'reverse',
        ['--border'] = 'none',
      },
      -- PROVIDERS SETUP
      -- use `defaults` (table or function) if you wish to set "global-provider" defaults
      -- for example, disabling file icons globally and open the quickfix list at the top
      --   defaults = {
      --     file_icons   = false,
      --     copen        = "topleft copen",
      --   },
      files = {
        previewer = 'bat',
        prompt = 'Files❯ ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- path_shorten   = 1,              -- 'true' or number, shorten path?
        -- Uncomment for custom vscode-like formatter where the filename is first:
        -- e.g. "fzf-lua/previewer/fzf.lua" => "fzf.lua previewer/fzf-lua"
        -- formatter      = "path.filename_first",
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
        -- default options are controlled by 'fd|rg|find|_opts'
        -- NOTE: 'find -printf' requires GNU find
        -- cmd            = "find . -type f -printf '%P\n'",
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        -- by default, cwd appears in the header only if {opts} contain a cwd
        -- parameter to a different folder than the current working directory
        -- uncomment if you wish to force display of the cwd as part of the
        -- query prompt string (fzf.vim style), header line or both
        -- cwd_header = true,
        cwd_prompt = true,
        cwd_prompt_shorten_len = 32, -- shorten prompt beyond this length
        cwd_prompt_shorten_val = 1, -- shortened path parts length
        toggle_ignore_flag = '--no-ignore', -- flag toggled in `actions.toggle_ignore`
        toggle_hidden_flag = '--hidden', -- flag toggled in `actions.toggle_ignore`
        actions = {
          -- inherits from 'actions.files', here we can override
          -- or set bind to 'false' to disable a default action
          -- action to toggle `--no-ignore`, requires fd or rg installed
          ['ctrl-r'] = { actions.toggle_ignore },
          -- uncomment to override `actions.file_edit_or_qf`
          --   ["default"]   = actions.file_edit,
          -- custom actions are available too
          --   ["ctrl-y"]    = function(selected) print(selected[1]) end,
        },
      },
      git = {
        files = {
          prompt = 'GitFiles❯ ',
          cmd = 'git ls-files --exclude-standard',
          multiprocess = true, -- run command in a separate process
          git_icons = true, -- show git icons?
          file_icons = true, -- show file icons?
          color_icons = true, -- colorize file|git icons
          -- force display the cwd header line regardless of your current working
          -- directory can also be used to hide the header when not wanted
          -- cwd_header = true
        },
        status = {
          prompt = 'GitStatus❯ ',
          cmd = 'git -c color.status=false --no-optional-locks status --porcelain=v1 -u',
          multiprocess = true, -- run command in a separate process
          file_icons = true,
          git_icons = true,
          color_icons = true,
          previewer = 'git_diff',
          -- git-delta is automatically detected as pager, uncomment to disable
          -- preview_pager = false,
          actions = {
            -- actions inherit from 'actions.files' and merge
            ['right'] = { fn = actions.git_unstage, reload = true },
            ['left'] = { fn = actions.git_stage, reload = true },
            ['ctrl-x'] = { fn = actions.git_reset, reload = true },
          },
          -- If you wish to use a single stage|unstage toggle instead
          -- using 'ctrl-o' modify the 'actions' table as shown below
          -- actions = {
          --   ["right"]   = false,
          --   ["left"]    = false,
          --   ["ctrl-x"]  = { fn = actions.git_reset, reload = true },
          --   ["ctrl-o"]  = { fn = actions.git_stage_unstage, reload = true },
          -- },
        },
        commits = {
          prompt = 'Commits❯ ',
          cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]] .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset"]],
          preview = 'git show --color {1}',
          -- git-delta is automatically detected as pager, uncomment to disable
          -- preview_pager = false,
          actions = {
            ['default'] = actions.git_checkout,
            -- remove `exec_silent` or set to `false` to exit after yank
            ['ctrl-y'] = { fn = actions.git_yank_commit, exec_silent = true },
          },
        },
        bcommits = {
          prompt = 'BCommits❯ ',
          -- default preview shows a git diff vs the previous commit
          -- if you prefer to see the entire commit you can use:
          --   git show --color {1} --rotate-to={file}
          --   {1}    : commit SHA (fzf field index expression)
          --   {file} : filepath placement within the commands
          cmd = [[git log --color --pretty=format:"%C(yellow)%h%Creset ]] .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {file}]],
          preview = 'git show --color {1} -- {file}',
          -- git-delta is automatically detected as pager, uncomment to disable
          -- preview_pager = false,
          actions = {
            ['default'] = actions.git_buf_edit,
            ['ctrl-o'] = actions.git_buf_split,
            ['ctrl-v'] = actions.git_buf_vsplit,
            ['ctrl-t'] = actions.git_buf_tabedit,
            ['ctrl-y'] = { fn = actions.git_yank_commit, exec_silent = true },
          },
        },
        branches = {
          prompt = 'Branches❯ ',
          cmd = 'git branch --all --color',
          preview = 'git log --graph --pretty=oneline --abbrev-commit --color {1}',
          actions = {
            ['default'] = actions.git_switch,
            ['ctrl-x'] = { fn = actions.git_branch_del, reload = true },
            ['ctrl-a'] = { fn = actions.git_branch_add, field_index = '{q}', reload = true },
          },
          -- If you wish to add branch and switch immediately
          -- cmd_add  = { "git", "checkout", "-b" },
          cmd_add = { 'git', 'branch' },
          -- If you wish to delete unmerged branches add "--force"
          -- cmd_del  = { "git", "branch", "--delete", "--force" },
          cmd_del = { 'git', 'branch', '--delete' },
        },
        tags = {
          prompt = 'Tags> ',
          cmd = [[git for-each-ref --color --sort="-taggerdate" --format ]]
            .. [["%(color:yellow)%(refname:short)%(color:reset) ]]
            .. [[%(color:green)(%(taggerdate:relative))%(color:reset)]]
            .. [[ %(subject) %(color:blue)%(taggername)%(color:reset)" refs/tags]],
          preview = [[git log --graph --color --pretty=format:"%C(yellow)%h%Creset ]] .. [[%Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset" {1}]],
          actions = { ['default'] = actions.git_checkout },
        },
        stash = {
          prompt = 'Stash> ',
          cmd = 'git --no-pager stash list',
          preview = 'git --no-pager stash show --patch --color {1}',
          actions = {
            ['default'] = actions.git_stash_apply,
            ['ctrl-x'] = { fn = actions.git_stash_drop, reload = true },
          },
        },
        icons = {
          ['M'] = { icon = 'M', color = 'yellow' },
          ['D'] = { icon = 'D', color = 'red' },
          ['A'] = { icon = 'A', color = 'green' },
          ['R'] = { icon = 'R', color = 'yellow' },
          ['C'] = { icon = 'C', color = 'yellow' },
          ['T'] = { icon = 'T', color = 'magenta' },
          ['?'] = { icon = '?', color = 'magenta' },
          -- override git icons?
          -- ["M"]        = { icon = "★", color = "red" },
          -- ["D"]        = { icon = "✗", color = "red" },
          -- ["A"]        = { icon = "+", color = "green" },
        },
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `rg` over `grep`
        -- default options are controlled by 'rg|grep_opts'
        -- cmd            = "rg --vimgrep",
        grep_opts = '--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e',
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --glob="!.git" --sort=path -e',
        -- Uncomment to use the rg config file `$RIPGREP_CONFIG_PATH`
        RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
        --
        -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
        -- search strings will be split using the 'glob_separator' and translated
        -- to '--iglob=' arguments, requires 'rg'
        -- can still be used when 'false' by calling 'live_grep_glob' directly
        rg_glob = false, -- default to glob parsing?
        glob_flag = '--iglob', -- for case sensitive globs use '--glob'
        glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
        -- advanced usage: for custom argument parsing define
        -- 'rg_glob_fn' to return a pair:
        --   first returned argument is the new search query
        --   second returned argument are additional rg flags
        -- rg_glob_fn = function(query, opts)
        --   ...
        --   return new_query, flags
        -- end,
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ['ctrl-g'] = { actions.grep_lgrep },
          -- uncomment to enable '.gitignore' toggle for grep
          -- ['ctrl-r'] = { actions.toggle_ignore },
        },
        no_header = false, -- hide grep|cwd header?
        no_header_i = false, -- hide interactive header?
      },
      args = {
        prompt = 'Args❯ ',
        files_only = true,
        -- actions inherit from 'actions.files' and merge
        actions = { ['ctrl-x'] = { fn = actions.arg_del, reload = true } },
      },
      oldfiles = {
        prompt = 'History❯ ',
        cwd_only = true,
        stat_file = true, -- verify files exist on disk
        include_current_session = false, -- include bufs from current session
      },
      buffers = {
        prompt = 'Buffers❯ ',
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        sort_lastused = true, -- sort buffers() by last used
        show_unloaded = true, -- show unloaded buffers
        cwd_only = false, -- buffers for the cwd only
        cwd = nil, -- buffers list for a given dir
        actions = {
          -- actions inherit from 'actions.buffers' and merge
          -- by supplying a table of functions we're telling
          -- fzf-lua to not close the fzf window, this way we
          -- can resume the buffers picker on the same window
          -- eliminating an otherwise unaesthetic win "flash"
          ['ctrl-x'] = { fn = actions.buf_del, reload = true },
        },
      },
      lines = {
        previewer = 'builtin', -- set to 'false' to disable
        prompt = 'Lines❯ ',
        show_unloaded = true, -- show unloaded buffers
        show_unlisted = false, -- exclude 'help' buffers
        no_term_buffers = true, -- exclude 'term' buffers
        fzf_opts = {
          -- do not include bufnr in fuzzy matching
          -- tiebreak by line no.
          ['--delimiter'] = '[\\]:]',
          ['--nth'] = '2..',
          ['--tiebreak'] = 'index',
          ['--tabstop'] = '1',
        },
        -- actions inherit from 'actions.buffers' and merge
        actions = {
          ['default'] = actions.buf_edit_or_qf,
          ['alt-q'] = actions.buf_sel_to_qf,
          ['alt-l'] = actions.buf_sel_to_ll,
        },
      },
      blines = {
        previewer = 'builtin', -- set to 'false' to disable
        prompt = 'BLines❯ ',
        show_unlisted = true, -- include 'help' buffers
        no_term_buffers = false, -- include 'term' buffers
        -- start          = "cursor"      -- start display from cursor?
        fzf_opts = {
          -- hide filename, tiebreak by line no.
          ['--delimiter'] = '[:]',
          ['--with-nth'] = '2..',
          ['--tiebreak'] = 'index',
          ['--tabstop'] = '1',
        },
        -- actions inherit from 'actions.buffers' and merge
        actions = {
          ['default'] = actions.buf_edit_or_qf,
          ['alt-q'] = actions.buf_sel_to_qf,
          ['alt-l'] = actions.buf_sel_to_ll,
        },
      },
      tags = {
        prompt = 'Tags❯ ',
        ctags_file = nil, -- auto-detect from tags-option
        multiprocess = true,
        file_icons = true,
        git_icons = true,
        color_icons = true,
        -- 'tags_live_grep' options, `rg` prioritizes over `grep`
        rg_opts = '--no-heading --color=always --smart-case',
        grep_opts = '--color=auto --perl-regexp',
        fzf_opts = { ['--tiebreak'] = 'begin' },
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ['ctrl-g'] = { actions.grep_lgrep },
        },
        no_header = false, -- hide grep|cwd header?
        no_header_i = false, -- hide interactive header?
      },
      btags = {
        prompt = 'BTags❯ ',
        ctags_file = nil, -- auto-detect from tags-option
        ctags_autogen = true, -- dynamically generate ctags each call
        multiprocess = true,
        file_icons = false,
        git_icons = false,
        rg_opts = '--color=never --no-heading',
        grep_opts = '--color=never --perl-regexp',
        fzf_opts = { ['--tiebreak'] = 'begin' },
        -- actions inherit from 'actions.files'
      },
      colorschemes = {
        prompt = 'Colorschemes❯ ',
        live_preview = true, -- apply the colorscheme on preview?
        actions = { ['default'] = actions.colorscheme },
        winopts = { height = 0.55, width = 0.30 },
        -- uncomment to ignore colorschemes names (lua patterns)
        -- ignore_patterns   = { "^delek$", "^blue$" },
        -- uncomment to execute a callback on preview|close
        -- e.g. a call to reset statusline highlights
        -- cb_preview        = function() ... end,
        -- cb_exit           = function() ... end,
      },
      keymaps = {
        prompt = 'Keymaps> ',
        winopts = { preview = { layout = 'vertical' } },
        fzf_opts = { ['--tiebreak'] = 'index' },
        -- by default, we ignore <Plug> and <SNR> mappings
        -- set `ignore_patterns = false` to disable filtering
        ignore_patterns = { '^<SNR>', '^<Plug>' },
        actions = {
          ['default'] = actions.keymap_apply,
          ['ctrl-o'] = actions.keymap_split,
          ['ctrl-v'] = actions.keymap_vsplit,
          ['ctrl-t'] = actions.keymap_tabedit,
        },
      },
      quickfix = {
        file_icons = true,
        git_icons = true,
        only_valid = false, -- select among only the valid quickfix entries
      },
      quickfix_stack = {
        prompt = 'Quickfix Stack> ',
        marker = '>', -- current list marker
      },
      lsp = {
        prompt_postfix = '❯ ', -- will be appended to the LSP label
        -- to override use 'prompt' instead
        cwd_only = false, -- LSP/diagnostics for cwd only?
        async_or_timeout = 5000, -- timeout(ms) or 'true' for async calls
        file_icons = true,
        git_icons = false,
        -- The equivalent of using `includeDeclaration` in lsp buf calls, e.g:
        -- :lua vim.lsp.buf.references({includeDeclaration = false})
        includeDeclaration = true, -- include current declaration in LSP context
        -- settings for 'lsp_{document|workspace|lsp_live_workspace}_symbols'
        symbols = {
          async_or_timeout = true, -- symbols are async by default
          symbol_style = 1, -- style for document/workspace symbols
          -- false: disable,    1: icon+kind
          --     2: icon only,  3: kind only
          -- NOTE: icons are extracted from
          -- vim.lsp.protocol.CompletionItemKind
          -- icons for symbol kind
          -- see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
          -- see https://github.com/neovim/neovim/blob/829d92eca3d72a701adc6e6aa17ccd9fe2082479/runtime/lua/vim/lsp/protocol.lua#L117
          symbol_icons = {
            File = '󰈙',
            Module = '',
            Namespace = '󰦮',
            Package = '',
            Class = '󰆧',
            Method = '󰊕',
            Property = '',
            Field = '',
            Constructor = '',
            Enum = '',
            Interface = '',
            Function = '󰊕',
            Variable = '󰀫',
            Constant = '󰏿',
            String = '',
            Number = '󰎠',
            Boolean = '󰨙',
            Array = '󱡠',
            Object = '',
            Key = '󰌋',
            Null = '󰟢',
            EnumMember = '',
            Struct = '󰆼',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰗴',
          },
          -- colorize using Treesitter '@' highlight groups ("@function", etc).
          -- or 'false' to disable highlighting
          symbol_hl = function(s)
            return '@' .. s:lower()
          end,
          -- additional symbol formatting, works with or without style
          symbol_fmt = function(s, opts)
            return '[' .. s .. ']'
          end,
          -- prefix child symbols. set to any string or `false` to disable
          child_prefix = true,
          fzf_opts = { ['--tiebreak'] = 'begin' },
        },
        code_actions = {
          prompt = 'Code Actions> ',
          async_or_timeout = 5000,
          -- when git-delta is installed use "codeaction_native" for beautiful diffs
          -- try it out with `:FzfLua lsp_code_actions previewer=codeaction_native`
          -- scroll up to `previewers.codeaction{_native}` for more previewer options
          -- previewer = 'codeaction',
          previewer = 'codeaction_native',
        },
        finder = {
          prompt = 'LSP Finder> ',
          file_icons = true,
          color_icons = true,
          git_icons = false,
          async = true, -- async by default
          silent = true, -- suppress "not found"
          separator = '| ', -- separator after provider prefix, `false` to disable
          includeDeclaration = true, -- include current declaration in LSP context
          -- by default display all LSP locations
          -- to customize, duplicate table and delete unwanted providers
          providers = {
            { 'references', prefix = require('fzf-lua').utils.ansi_codes.blue 'ref ' },
            { 'definitions', prefix = require('fzf-lua').utils.ansi_codes.green 'def ' },
            { 'declarations', prefix = require('fzf-lua').utils.ansi_codes.magenta 'decl' },
            { 'typedefs', prefix = require('fzf-lua').utils.ansi_codes.red 'tdef' },
            { 'implementations', prefix = require('fzf-lua').utils.ansi_codes.green 'impl' },
            { 'incoming_calls', prefix = require('fzf-lua').utils.ansi_codes.cyan 'in  ' },
            { 'outgoing_calls', prefix = require('fzf-lua').utils.ansi_codes.yellow 'out ' },
          },
        },
      },
      diagnostics = {
        prompt = 'Diagnostics❯ ',
        cwd_only = false,
        file_icons = true,
        git_icons = false,
        diag_icons = true,
        diag_source = true, -- display diag source (e.g. [pycodestyle])
        icon_padding = '', -- add padding for wide diagnostics signs
        multiline = true, -- concatenate multi-line diags into a single line
        -- set to `false` to display the first line only
        -- by default icons and highlights are extracted from 'DiagnosticSignXXX'
        -- and highlighted by a highlight group of the same name (which is usually
        -- set by your colorscheme, for more info see:
        --   :help DiagnosticSignHint'
        --   :help hl-DiagnosticSignHint'
        -- only uncomment below if you wish to override the signs/highlights
        -- define only text, texthl or both (':help sign_define()' for more info)
        -- signs = {
        --   ["Error"] = { text = "", texthl = "DiagnosticError" },
        --   ["Warn"]  = { text = "", texthl = "DiagnosticWarn" },
        --   ["Info"]  = { text = "", texthl = "DiagnosticInfo" },
        --   ["Hint"]  = { text = "󰌵", texthl = "DiagnosticHint" },
        -- },
        -- limit to specific severity, use either a string or num:
        --   1 or "hint"
        --   2 or "information"
        --   3 or "warning"
        --   4 or "error"
        -- severity_only:   keep any matching exact severity
        -- severity_limit:  keep any equal or more severe (lower)
        -- severity_bound:  keep any equal or less severe (higher)
      },
      marks = {
        marks = '', -- filter vim marks with a lua pattern
        -- for example if you want to only show user defined marks
        -- you would set this option as %a this would match characters from [A-Za-z]
        -- or if you want to show only numbers you would set the pattern to %d (0-9).
      },
      complete_path = {
        cmd = 'rg', -- default: auto detect fd|rg|find
        complete = { ['default'] = actions.complete },
      },
      complete_file = {
        cmd = 'rg', -- default: auto detect rg|fd|find
        file_icons = true,
        color_icons = true,
        git_icons = false,
        -- actions inherit from 'actions.files' and merge
        actions = { ['default'] = actions.complete },
        -- previewer hidden by default
        winopts = { preview = { hidden = 'hidden' } },
      },
      -- uncomment to use fzf native previewers
      -- (instead of using a neovim floating window)
      -- manpages = { previewer = "man_native" },
      -- helptags = { previewer = "help_native" },
      --
      -- padding can help kitty term users with double-width icon rendering
      file_icon_padding = '',
      -- uncomment if your terminal/font does not support unicode character
      -- 'EN SPACE' (U+2002), the below sets it to 'NBSP' (U+00A0) instead
      -- nbsp = '\xc2\xa0',
    }
    fzf.register_ui_select()
  end,
}
