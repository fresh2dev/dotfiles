-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
return {
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  version = '*',
  cmd = 'Neotree',
  keys = {
    { '<C-\\>', '<Cmd>silent! Neotree toggle action=focus reveal=true reveal_force_cwd=true position=left<CR>', desc = '[B]uffer [S]idebar' },
    { '<leader>bb', '<Cmd>silent! Neotree toggle action=focus reveal=true reveal_force_cwd=true position=float<CR>', desc = '[B]uffer Explorer' },
  },
  dependencies = {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'https://github.com/MunifTanjim/nui.nvim',
    -- {
    --   'https://github.com/s1n7ax/nvim-window-picker',
    --   opt = {
    --     filter_rules = {
    --       include_current_win = false,
    --       autoselect_one = true,
    --       -- filter using buffer options
    --       bo = {
    --         -- if the file type is one of following, the window will be ignored
    --         filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
    --         -- if the buffer type is one of following, the window will be ignored
    --         buftype = { 'terminal', 'quickfix' },
    --       },
    --     },
    --   },
    -- },
  },
  opts = {
    sources = {
      'buffers',
      -- 'filesystem',
      -- 'git_status',
      -- 'document_symbols',
    },
    source_selector = {
      winbar = true,
      statusline = false,
    },
    close_if_last_window = false,
    default_source = 'buffers',
    enable_diagnostics = false,
    enable_git_status = true,
    enable_modified_markers = true, -- Show markers for files with unsaved changes.
    enable_opened_markers = false, -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
    enable_refresh_on_write = false, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
    enable_cursor_hijack = false, -- If enabled neotree will keep the cursor on the first letter of the filename when moving in the tree.
    git_status_async = true,
    hide_root_node = true,
    open_files_do_not_replace_types = {
      'terminal',
      'Trouble',
      'trouble',
      'qf',
      'Outline',
      'edgy',
      'fugitive',
    },
    popup_border_style = 'rounded',
    use_default_mappings = false,
    default_component_configs = {
      indent = {
        with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
      },
    },
    window = {
      position = 'float',
      width = 30,
      popup = { -- settings that apply to float position only
        size = {
          height = '80%',
          width = '50%',
        },
        position = '50%', -- 50% means center it
      },
      mappings = {
        ['<space>'] = 'none',
        ['<2-LeftMouse>'] = 'open',
        ['<CR>'] = 'open',
        ['zo'] = 'open',
        ['zc'] = 'close_node',
        ['zR'] = 'expand_all_nodes',
        ['zM'] = 'close_all_nodes',
        ['K'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = false } },
        ['i'] = 'focus_preview',
        ['<C-o>'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open_split'](state)
          end
        end,
        ['<C-v>'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open_vsplit'](state)
          end
        end,
        ['<C-t>'] = function(state)
          local node = state.tree:get_node()
          if require('neo-tree.utils').is_expandable(node) then
            state.commands['toggle_node'](state)
          else
            state.commands['open_tabnew'](state)
          end
        end,
        ['<F5>'] = 'refresh',
        ['u'] = 'refresh',
        ['cc'] = 'rename',
        -- ['q'] = 'close_window',
        ['<C-\\>'] = function(state)
          vim.cmd 'wincmd p'
          vim.cmd 'Neotree action=close'
        end,
        ['q'] = function(state)
          vim.cmd 'wincmd p'
          vim.cmd 'Neotree action=close'
        end,
        ['g?'] = 'show_help',
        ['yy'] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          desc = 'Copy Path to Clipboard',
        },
      },
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
          -- ['h'] = 'navigate_up',
          -- ['.'] = 'set_root',
          ['dd'] = 'buffer_delete',
          ['DD'] = function(state)
            -- This is the native `buffer_delete` function
            -- but modified to use `Bdelete` over `bdelete`,
            -- to preserve window positions
            local node = state.tree:get_node()
            if node then
              if node.type == 'message' then
                return
              end
              vim.api.nvim_buf_delete(node.extra.bufnr, { force = true, unload = true })
            end
          end,
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
}
