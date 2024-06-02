-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree<CR>', desc = 'Show File Explorer' },
    { '|', ':Neotree reveal=true<CR>', desc = 'Show File Explorer' },
    { '<C-\\>', ':Neotree toggle action=focus reveal=true<CR>', desc = '[T]oggle File Explorer' },
    { '<leader>t\\', ':Neotree toggle action=focus reveal=true<CR>', desc = '[T]oggle File Explorer' },
    -- { '|', ':Neotree reveal position=float<CR>', desc = 'NeoTree floating' },
    -- { '<leader><leader>', ':Neotree reveal position=current<CR>', { desc = 'NeoTree' } },
    -- { '<leader>sp', ':split | Neotree reveal position=current<CR>', { desc = 'NeoTree split' } },
    -- { '<leader>vs', ':vsplit | Neotree reveal position=current<CR>', { desc = 'NeoTree vsplit' } },
  },
  opts = {
    sources = {
      'filesystem',
      'buffers',
      -- 'git_status',
      -- 'document_symbols',
    },
    source_selector = {
      winbar = true,
      statusline = false,
    },
    close_if_last_window = false,
    enable_diagnostics = false,
    enable_git_status = true,
    enable_modified_markers = true, -- Show markers for files with unsaved changes.
    enable_opened_markers = true, -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
    enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
    enable_cursor_hijack = false, -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    git_status_async = true,
    open_files_do_not_replace_types = {
      'terminal',
      'Trouble',
      'trouble',
      'qf',
      'Outline',
      'edgy',
      'fugitive',
    },
    use_default_mappings = false,
    default_component_configs = {
      indent = {
        with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
      },
    },
    commands = {
      open_and_clear_filter = function(state)
        local node = state.tree:get_node()
        if node and node.type == 'file' then
          local file_path = node:get_id()
          -- reuse built-in commands to open and clear filter
          local cmds = require 'neo-tree.sources.filesystem.commands'
          cmds.open(state)
          cmds.clear_filter(state)
          -- reveal the selected file without focusing the tree
          require('neo-tree.sources.filesystem').navigate(state, state.path, file_path)
        end
      end,
    },
    window = {
      width = 30,
      mappings = {
        ['<space>'] = 'none',
        ['<2-LeftMouse>'] = 'open',
        ['<CR>'] = 'open',
        -- ['l'] = 'open',
        ['zl'] = 'open',
        ['l'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open'](state)
            vim.cmd 'Neotree reveal'
          end
        end,
        -- ['L'] = 'set_root',
        -- ['J'] = function(state)
        --   vim.cmd 'normal! j'
        -- end,
        -- ['K'] = function(state)
        --   vim.cmd 'normal! k'
        -- end,
        ['h'] = 'close_node',
        ['zh'] = 'close_node',
        ['zR'] = 'expand_all_nodes',
        ['zM'] = 'close_all_nodes',
        ['K'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['i'] = 'focus_preview',
        ['o'] = 'open_split',
        ['O'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open_split'](state)
            vim.cmd 'Neotree reveal'
          end
        end,
        ['v'] = 'open_vsplit',
        ['V'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open_vsplit'](state)
            vim.cmd 'Neotree reveal'
          end
        end,
        ['e'] = { 'show_help', nowait = false, config = { title = 'Edit', prefix_key = 'e' } },
        ['ee'] = 'open_with_window_picker',
        ['eo'] = 'split_with_window_picker',
        ['ev'] = 'vsplit_with_window_picker',
        ['<F5>'] = 'refresh',
        ['a'] = {
          'add',
          config = {
            show_path = 'relative', -- "none", "relative", "absolute"
          },
        },
        ['dd'] = 'delete',
        ['cc'] = 'rename',
        ['yy'] = 'copy_to_clipboard',
        ['mm'] = 'cut_to_clipboard',
        ['cp'] = 'copy',
        ['mv'] = 'move',
        ['p'] = 'paste_from_clipboard',
        ['q'] = 'close_window',
        ['\\'] = function(state)
          vim.cmd 'wincmd p'
          vim.cmd 'Neotree action=show'
        end,
        ['|'] = function(state)
          vim.cmd 'wincmd p'
          vim.cmd 'Neotree action=show'
        end,
        ['g?'] = 'show_help',
        -- ['<'] = 'prev_source',
        ['<Tab>'] = 'next_source',
        ['Y'] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          desc = 'Copy Path to Clipboard',
        },
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['<2-LeftMouse>'] = 'open_and_clear_filter',
          ['<cr>'] = 'open_and_clear_filter',
          -- ['a'] = 'toggle_hidden',
          -- ['ff'] = 'fuzzy_finder',
          -- ['D'] = 'fuzzy_finder_directory',
          -- --["/"] = "filter_as_you_type", -- this was the default until v1.28
          -- ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['/'] = 'filter_on_submit',
          ['<Esc>'] = 'clear_filter',
          -- ['<BS>'] = 'navigate_up',
          -- ['.'] = 'set_root',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
          -- ["i"] = "show_file_details",
          ['s'] = { 'show_help', nowait = false, config = { title = 'Sort by', prefix_key = 's' } },
          ['sc'] = { 'order_by_created', nowait = false },
          ['sd'] = { 'order_by_diagnostics', nowait = false },
          ['sg'] = { 'order_by_git_status', nowait = false },
          ['sm'] = { 'order_by_modified', nowait = false },
          ['sn'] = { 'order_by_name', nowait = false },
          ['ss'] = { 'order_by_size', nowait = false },
          ['st'] = { 'order_by_type', nowait = false },
        },
        fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
          ['<down>'] = 'move_cursor_down',
          ['<C-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<C-p>'] = 'move_cursor_up',
        },
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        never_show = {
          '.git',
          '.venv',
          '.devbox',
          '.DS_Store',
          '__pycache__',
        },
        never_show_by_pattern = {
          '.*_cache',
        },
      },
      bind_to_cwd = true,
      cwd_target = {
        sidebar = 'tab', -- sidebar is when position = left or right
        current = 'window', -- current is when position = current
      },
      follow_current_file = {
        enabled = false, -- This will find and focus the file in the active buffer every time
      },
      hijack_netrw_behavior = 'open_current', -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",-- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true,
    },
    buffers = {
      bind_to_cwd = true,
      follow_current_file = {
        enabled = true,
      },
      group_empty_dirs = true, -- when true, empty directories will be grouped together
      show_unloaded = false, -- When working with sessions, for example, restored but unfocused buffers
      -- are mark as "unloaded". Turn this on to view these unloaded buffer.
      terminals_first = false, -- when true, terminals will be listed before file buffers
      window = {
        mappings = {
          ['h'] = 'navigate_up',
          -- ['.'] = 'set_root',
          ['dd'] = 'buffer_delete',
          -- ['i'] = 'show_file_details',
          ['s'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
          ['sc'] = { 'order_by_created', nowait = false },
          ['sd'] = { 'order_by_diagnostics', nowait = false },
          ['sm'] = { 'order_by_modified', nowait = false },
          ['sn'] = { 'order_by_name', nowait = false },
          ['ss'] = { 'order_by_size', nowait = false },
          ['st'] = { 'order_by_type', nowait = false },
        },
      },
    },
  },
  dependencies = {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'https://github.com/MunifTanjim/nui.nvim',
    {
      'https://github.com/s1n7ax/nvim-window-picker',
      opt = {
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      },
    },
  },
}
