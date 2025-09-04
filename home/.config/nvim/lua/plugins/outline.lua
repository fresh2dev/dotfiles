-- Code outline sidebar powered by LSP.
return {
  'https://github.com/hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  keys = {
    { '<leader>to', ':Outline!<CR>', desc = '[T]oggle [O]utline' },
    { '<leader>co', ':OutlineOpen<CR>', desc = '[C]ode [O]utline' },
  },
  opts = {
    outline_window = {
      width = 15,
      relative_width = true,
    },
    preview_window = {
      -- Automatically open preview of code location when navigating outline window
      auto_preview = false,
      open_hover_on_preview = true,
    },
    -- Your setup opts here
    keymaps = {
      show_help = '?',
      close = { '<Esc>', 'q' },
      -- Jump to symbol under cursor.
      -- It can auto close the outline window when triggered, see
      -- 'auto_close' option above.
      goto_location = '<Cr>',
      -- Jump to symbol under cursor but keep focus on outline window.
      peek_location = 'o',
      -- Visit location in code and close outline immediately
      goto_and_close = '<S-Cr>',
      -- Change cursor position of outline window to match current location in code.
      -- 'Opposite' of goto/peek_location.
      restore_location = '<C-g>',
      -- Open LSP/provider-dependent symbol hover information
      hover_symbol = '<C-space>',
      -- Preview location code of the symbol under cursor
      toggle_preview = 'i',
      rename_symbol = 'r',
      code_actions = 'a',
      -- These fold actions are collapsing tree nodes, not code folding
      fold = 'h',
      unfold = 'l',
      -- fold_toggle = '<Tab>',
      -- Toggle folds for all nodes.
      -- If at least one node is folded, this action will fold all nodes.
      -- If all nodes are folded, this action will unfold all nodes.
      -- fold_toggle_all = '<S-Tab>',
      fold_all = 'zM',
      unfold_all = 'zR',
      -- fold_reset = 'r',
      -- Move down/up by one line and peek_location immediately.
      up_and_jump = '<C-p>',
      down_and_jump = '<C-n>',
    },
  },
}
