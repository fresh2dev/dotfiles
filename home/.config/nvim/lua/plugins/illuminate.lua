-- Neovim plugin for automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
-- https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua
return {
  'https://github.com/RRethy/vim-illuminate',
  lazy = false,
  opts = {
    delay = 200,
    filetypes_denylist = {
      'neo-tree',
      'fugitive',
    },
  },
  config = function(_, opts)
    require('illuminate').configure(opts)

    -- local function map(key, dir, buffer)
    --   vim.keymap.set({ 'n' }, key, function()
    --     require('illuminate')['goto_' .. dir .. '_reference'](true)
    --   end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference', buffer = buffer })
    -- end
    --
    -- map(']]', 'next')
    -- map('[[', 'prev')
    --
    -- -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
    -- vim.api.nvim_create_autocmd('FileType', {
    --   callback = function()
    --     local buffer = vim.api.nvim_get_current_buf()
    --     map(']]', 'next', buffer)
    --     map('[[', 'prev', buffer)
    --   end,
    -- })
  end,
}
