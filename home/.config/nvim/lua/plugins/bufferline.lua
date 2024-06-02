return {
  'https://github.com/akinsho/bufferline.nvim',
  version = 'v4',
  lazy = false,
  keys = {
    { '<S-h>', ':BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { '<S-l>', ':BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    { '[b', ':BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    { ']b', ':BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    -- { 'gT', ':BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
    -- { 'gt', ':BufferLineCycleNext<cr>', desc = 'Next Buffer' },
    -- { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
    -- { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
    -- { '<leader>Q', '<Cmd>BufferLineCloseOthers<CR>', desc = 'Delete Other Buffers' },
    -- { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
    -- { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
    -- { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
    -- { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
  },
  dependencies = {
    -- 'https://github.com/SmiteshP/nvim-navic',
    'https://github.com/nvim-tree/nvim-web-devicons',
    -- -- Enables tab-specific buffers:
    -- { 'https://github.com/tiagovla/scope.nvim', lazy = false, config = true },
    -- -- Defines the `Bdelete` command
    -- { 'https://github.com/famiu/bufdelete.nvim' },
  },
  opts = {
    options = {
      mode = 'buffers', -- set to "tabs" to only show tabpages instead
      -- stylepreset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
      themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
      numbers = 'buffer_id', -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
      close_command = 'Bdelete! %d', -- can be a string | function, | false see "Mouse actions"
      right_mouse_command = nil, -- can be a string | function | false, see "Mouse actions"
      left_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
      indicator = {
        icon = '▎', -- this should be omitted if indicator style is not 'icon'
        style = 'icon', --'icon' | 'underline' | 'none',
      },
      -- buffer_close_icon = '󰅖',
      -- modified_icon = '● ',
      -- close_icon = ' ',
      -- left_trunc_marker = ' ',
      -- right_trunc_marker = ' ',
      -- max_name_length = 18,
      -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      -- truncate_names = true, -- whether or not tab names should be truncated
      -- tab_size = 18,
      diagnostics = false, -- false | "nvim_lsp" | "coc",
      custom_filter = function(buf_number, buf_numbers)
        -- Filter out special buftypes
        if vim.bo[buf_number].buftype ~= '' then
          return false
        end

        -- -- Filter out filetypes you don't want to see.
        -- local exclude_filetypes = { 'qf', 'loclist', 'git', 'fugitive', 'grug-far' }
        --
        -- return not vim.tbl_contains(exclude_filetypes, vim.bo[buf_number].filetype)
        return true
      end,
      offsets = {
        {
          filetype = 'neo-tree',
          text = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
          end,
          highlight = 'Directory',
          text_align = 'left',
          separator = false,
        },
      },
      color_icons = true, -- whether or not to add the filetype icon highlights
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = false,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
      duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      -- separator_style = 'slant', -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      -- auto_toggle_bufferline = true | false,
      -- hover = {
      --     enabled = true,
      --     delay = 200,
      --     reveal = {'close'}
      -- },
      sort_by = 'id', -- 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)

    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete' }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })

    -- -- Make compoatible with 'edgy'
    -- local Offset = require 'bufferline.offset'
    -- if not Offset.edgy then
    --   local get = Offset.get
    --   Offset.get = function()
    --     if package.loaded.edgy then
    --       local layout = require('edgy.config').layout
    --       local ret = { left = '', left_size = 0, right = '', right_size = 0 }
    --       for _, pos in ipairs { 'left', 'right' } do
    --         local sb = layout[pos]
    --         if sb and #sb.wins > 0 then
    --           local title = ' Sidebar' .. string.rep(' ', sb.bounds.width - 8)
    --           ret[pos] = '%#EdgyTitle#' .. title .. '%*' .. '%#WinSeparator#│%*'
    --           ret[pos .. '_size'] = sb.bounds.width
    --         end
    --       end
    --       ret.total_size = ret.left_size + ret.right_size
    --       if ret.total_size > 0 then
    --         return ret
    --       end
    --     end
    --     return get()
    --   end
    --   Offset.edgy = true
    -- end
  end,
}
