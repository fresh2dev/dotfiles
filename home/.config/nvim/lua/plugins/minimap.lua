return {
  'https://github.com/wfxr/minimap.vim',
  lazy = false,
  cmd = { 'Minimap', 'MinimapToggle', 'MinimapFocus' },
  keys = {
    { '<leader>tmm', ':MinimapToggle<CR>', mode = 'n', desc = '[T]oggle [M]ini[M]ap' },
    {
      'gm',
      function()
        if vim.bo.filetype == 'minimap' then
          vim.cmd 'wincmd p'
        else
          vim.cmd 'MinimapFocus'
        end
      end,
      mode = 'n',
      desc = '[G]o to Mini[M]ap',
    },
  },
  init = function()
    vim.g.minimap_width = 8
    vim.g.minimap_auto_start = 0
    vim.g.minimap_auto_start_win_enter = 0
    vim.g.minimap_left = 0
    vim.g.minimap_block_filetypes = { 'fugitive', 'neo-tree', 'tagbar', 'fzf', 'telescope', 'toggleterm' }
    vim.g.minimap_block_buftypes = { 'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt' }
    -- vim.g.minimap_close_filetypes = { 'startify', 'netrw', 'vim-plug' }
    vim.g.minimap_highlight_range = 1
    vim.g.minimap_highlight_search = 1
    vim.g.minimap_git_colors = 1
  end,
  config = function()
    -- Create command to focus minimap
    vim.api.nvim_create_user_command('MinimapFocus', function()
      vim.cmd 'Minimap'
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'filetype') == 'minimap' then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end, {})

    -- Return to previous window when enter is pressed within minimap buffer
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'minimap',
      callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':wincmd p<CR>', { noremap = true, silent = true })
      end,
    })
  end,
}
