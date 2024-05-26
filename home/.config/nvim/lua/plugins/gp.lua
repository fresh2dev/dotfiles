return { -- ChatGPT plugin
  'robitx/gp.nvim',
  config = function()
    local config = {
      chat_topic_gen_model = 'gpt-4-turbo-preview',
      chat_confirm_delete = false,
      chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = 'gpg' },
      chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = 'gpd' },
      chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = 'gpx' },
      chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = 'gpn' },
    }
    require('gp').setup(config)

    -- local function keymapOptions(desc)
    --   return {
    --     noremap = true,
    --     silent = true,
    --     nowait = true,
    --     desc = 'GPT prompt ' .. desc,
    --   }
    -- end

    -- -- Chat commands
    -- vim.keymap.set({ 'n' }, 'gpn', '<cmd>GpChatNew vsplit<cr>', keymapOptions 'New Chat')
    -- vim.keymap.set({ 'n' }, 'gpt', '<cmd>GpChatToggle vsplit<cr>', keymapOptions 'Toggle Chat')
    -- vim.keymap.set({ 'n' }, 'gpf', '<cmd>GpChatFinder<cr>', keymapOptions 'Chat Finder')
    --
    -- vim.keymap.set('v', 'gpn', ":<C-u>'<,'>GpChatNew<cr>", keymapOptions 'Visual Chat New')
    -- vim.keymap.set('v', 'gpp', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions 'Visual Chat Paste')
    --
    -- -- Prompt commands
    -- vim.keymap.set({ 'n' }, 'gpr', '<cmd>GpRewrite<cr>', keymapOptions 'Inline Rewrite')
    -- -- vim.keymap.set({ 'n' }, '<C-g>o', '<cmd>GpAppend<cr>', keymapOptions 'Append (after)')
    -- -- vim.keymap.set({ 'n' }, '<C-g>O', '<cmd>GpPrepend<cr>', keymapOptions 'Prepend (before)')
    --
    -- vim.keymap.set('v', 'gpr', ":<C-u>'<,'>GpRewrite<cr>", keymapOptions 'Visual Rewrite')
    -- -- vim.keymap.set('v', '<C-g>o', ":<C-u>'<,'>GpAppend<cr>", keymapOptions 'Visual Append (after)')
    -- -- vim.keymap.set('v', '<C-g>O', ":<C-u>'<,'>GpPrepend<cr>", keymapOptions 'Visual Prepend (before)')
    -- -- vim.keymap.set('v', 'gpi', ":<C-u>'<,'>GpImplement<cr>", keymapOptions 'Implement selection')
    --
    -- vim.keymap.set({ 'n' }, 'gpi', '<cmd>GpNew<cr>', keymapOptions 'GpNew')
    -- -- vim.keymap.set({ 'n' }, '<C-g>gp', '<cmd>GpPopup<cr>', keymapOptions 'Popup')
    -- -- vim.keymap.set({ 'n' }, '<C-g>ge', '<cmd>GpEnew<cr>', keymapOptions 'GpEnew')
    -- -- vim.keymap.set({ 'n' }, '<C-g>gv', '<cmd>GpVnew<cr>', keymapOptions 'GpVnew')
    -- -- vim.keymap.set({ 'n' }, '<C-g>gt', '<cmd>GpTabnew<cr>', keymapOptions 'GpTabnew')
    --
    -- vim.keymap.set('v', 'gpi', ":<C-u>'<,'>GpNew<cr>", keymapOptions 'Visual GpNew')
    -- -- vim.keymap.set('v', '<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", keymapOptions 'Visual Popup')
    -- -- vim.keymap.set('v', '<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", keymapOptions 'Visual GpEnew')
    -- -- vim.keymap.set('v', '<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", keymapOptions 'Visual GpVnew')
    -- -- vim.keymap.set('v', '<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", keymapOptions 'Visual GpTabnew')
    --
    -- vim.keymap.set({ 'n' }, 'gpc', '<cmd>GpContext<cr>', keymapOptions 'Toggle Context')
    -- vim.keymap.set('v', 'gpc', ":<C-u>'<,'>GpContext<cr>", keymapOptions 'Visual Toggle Context')
    --
    -- vim.keymap.set({ 'n', 'v' }, 'gpx', '<cmd>GpStop<cr>', keymapOptions 'Stop')
    --

    -- VISUAL mode mappings
    -- s, x, v modes are handled the same way by which_key
    require('which-key').register({
      -- ...
      ['gp'] = {
        n = { ":<C-u>'<,'>GpChatNew vsplit<cr>", 'Visual Chat New' },
        t = { ":<C-u>'<,'>GpChatToggle vsplit<cr>", 'Visual Toggle Chat' },

        p = { ":<C-u>'<,'>GpChatPaste vsplit<cr>", 'Visual Chat Paste' },

        r = { ":<C-u>'<,'>GpRewrite<cr>", 'Visual Rewrite' },

        o = { ":<C-u>'<,'>GpNew<cr>", 'Visual GpNew' },

        x = { '<cmd>GpStop<cr>', 'GpStop' },
        c = { ":<C-u>'<,'>GpContext<cr>", 'Visual GpContext' },
      },
    }, {
      mode = 'v', -- VISUAL mode
      prefix = '',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    })

    -- NORMAL mode mappings
    require('which-key').register({
      -- ...
      ['gp'] = {
        n = { '<cmd>GpChatNew vsplit<cr>', 'New Chat' },
        t = { '<cmd>GpChatToggle vsplit<cr>', 'Toggle Chat' },
        f = { '<cmd>GpChatFinder<cr>', 'Chat Finder' },

        r = { '<cmd>GpRewrite<cr>', 'Inline Rewrite' },

        o = { '<cmd>GpNew<cr>', 'GpNew' },

        x = { '<cmd>GpStop<cr>', 'GpStop' },
        c = { '<cmd>GpContext<cr>', 'Toggle GpContext' },
      },
    }, {
      mode = 'n', -- NORMAL mode
      prefix = '',
      buffer = nil,
      silent = true,
      noremap = true,
      nowait = true,
    })
  end,
}
