return {
  'https://github.com/mikavilpas/yazi.nvim',
  cmd = { 'Yazi' },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      -- Open in the current working directory
      '<leader>fe',
      '<cmd>Yazi cwd<cr>',
      desc = '[F]ile [E]xplorer (Yazi)',
    },
    -- {
    --   '|',
    --   '<cmd>Yazi<cr>',
    --   desc = 'Open Yazi at the current file',
    -- },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = false,
    open_multiple_tabs = false,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = 'none',
    highlight_hovered_buffers_in_same_directory = false,
    keymaps = {
      show_help = false,
      open_file_in_vertical_split = '<C-v>',
      open_file_in_horizontal_split = '<C-o>',
      open_file_in_tab = false,
      grep_in_directory = false,
      replace_in_directory = 'fr',
      -- cycle_open_buffers = '<tab>',
      cycle_open_buffers = false,
      -- copy_relative_path_to_selected_files = '<c-y>',
      copy_relative_path_to_selected_files = false,
      send_to_quickfix_list = '<C-q>',
    },
    integrations = {
      grep_in_directory = function(directory)
        -- limit the search to the given path
        --
        -- `prefills.flags` get passed to ripgrep as is
        -- https://github.com/MagicDuck/grug-far.nvim/issues/146
        local filter = directory:make_relative(vim.uv.cwd())
        require('grug-far').open {
          prefills = {
            paths = filter:gsub(' ', '\\ '),
          },
        }
      end,
      grep_in_selected_files = function(selected_files)
        local files = {}
        for _, path in ipairs(selected_files) do
          files[#files + 1] = path:make_relative(vim.uv.cwd()):gsub(' ', '\\ ')
        end

        require('grug-far').open {
          prefills = {
            paths = table.concat(files, ' '),
          },
        }
      end,
      replace_in_directory = function(directory)
        -- limit the search to the given path
        --
        -- `prefills.flags` get passed to ripgrep as is
        -- https://github.com/MagicDuck/grug-far.nvim/issues/146
        local filter = directory:make_relative(vim.uv.cwd())
        require('grug-far').open {
          prefills = {
            paths = filter:gsub(' ', '\\ '),
          },
        }
      end,
      replace_in_selected_files = function(selected_files)
        local files = {}
        for _, path in ipairs(selected_files) do
          files[#files + 1] = path:make_relative(vim.uv.cwd()):gsub(' ', '\\ ')
        end

        require('grug-far').open {
          prefills = {
            paths = table.concat(files, ' '),
          },
        }
      end,
      resolve_relative_path_application = relpath,
    },
  },
}
