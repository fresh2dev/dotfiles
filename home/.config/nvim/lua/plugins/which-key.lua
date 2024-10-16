-- WhichKey helps you remember your Neovim keymaps, by showing available keybindings in a popup as you type.
return {
  'https://github.com/folke/which-key.nvim',
  lazy = false,
  keys = {
    {
      '<leader>tk',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
    {
      '<leader>tK',
      function()
        require('which-key').show { global = true }
      end,
      desc = 'Global Keymaps (which-key)',
    },
  },
  opts = {
    delay = function(ctx)
      return ctx.plugin and 0 or 1500
    end,
    spec = {
      { '<leader>c', group = '[C]ode' },
      { '<leader>f', group = '[F]ind' },
      { '<leader>g', group = '[G]it' },
      { '<leader>gh', group = '[G]it [H]unk' },
      { '<leader>q', group = '[Q]uit' },
      { '<leader>t', group = '[T]oggle' },
      ---
      { '<leader>w', desc = '[W]rite Buffer' },
      { '<leader>W', desc = '[W]rite [A]ll Buffers' },
      { '<leader>x', desc = 'IntelliQuit' },
      { '<leader>qq', desc = 'IntelliQuit' },
      { '<leader>qs', desc = 'Close Window' },
      { '<leader>qS', desc = 'Close Splits' },
      { '<leader>qe', desc = 'Delete Buffer ([Q]uit [E]diting)' },
      { '<leader>qc', desc = 'Close Window and Delete Buffer' },
      { '<leader>qh', desc = 'Delete Hidden Buffers' },
      { '<leader>qo', desc = 'Close other Windows and Delete other Buffers' },
      { '<leader>qt', desc = 'Close Tab' },
    },
  },
}
