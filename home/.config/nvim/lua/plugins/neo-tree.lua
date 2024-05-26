-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal position=left<CR>', desc = 'NeoTree sidebar' },
    { '|', ':Neotree reveal position=float<CR>', desc = 'NeoTree floating' },
    -- { '<leader><leader>', ':Neotree reveal position=current<CR>', { desc = 'NeoTree' } },
    -- { '<leader>sp', ':split | Neotree reveal position=current<CR>', { desc = 'NeoTree split' } },
    -- { '<leader>vs', ':vsplit | Neotree reveal position=current<CR>', { desc = 'NeoTree vsplit' } },
  },
  opts = {
    sources = {
      'filesystem',
      -- 'buffers',
      -- 'git_status',
      -- "document_symbols",
    },
    close_if_last_window = false,
    enable_cursor_hijack = false,
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
    popup_border_style = 'rounded',
    use_default_mappings = false,
    -- default_component_configs = {
    --   indent = {
    --     with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
    --   },
    -- },
    window = {
      mappings = {
        ['<space>'] = 'none',
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        ['l'] = 'open',
        ['L'] = 'set_root',
        ['h'] = 'close_node',
        ['H'] = 'navigate_up',
        ['zR'] = 'expand_all_nodes',
        ['zM'] = 'close_all_nodes',
        ['i'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['I'] = 'focus_preview',
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
        ['E'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open'](state)
            vim.cmd 'Neotree reveal'
          end
        end,
        ['ee'] = 'open_with_window_picker',
        ['es'] = 'split_with_window_picker',
        ['ev'] = 'vsplit_with_window_picker',
        ['<F5>'] = 'refresh',
        ['+'] = {
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
        ['<Esc>'] = 'close_window',
        ['q'] = 'close_window',
        ['\\'] = 'close_window',
        ['|'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
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
          ['a'] = 'toggle_hidden',
          -- ['/'] = 'fuzzy_finder',
          -- ['D'] = 'fuzzy_finder_directory',
          -- --["/"] = "filter_as_you_type", -- this was the default until v1.28
          -- ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['/'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['<BS>'] = 'navigate_up',
          ['.'] = 'set_root',
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
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
      },
      hijack_netrw_behavior = 'open_current', -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",-- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
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
