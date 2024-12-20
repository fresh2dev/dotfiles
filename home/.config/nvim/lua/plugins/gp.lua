return { -- ChatGPT plugin
  'https://github.com/robitx/gp.nvim',
  init = function()
    -- vim.api.nvim_create_autocmd('BufWinEnter', {
    vim.api.nvim_create_autocmd('BufWinEnter', {
      pattern = '*',
      callback = function()
        if vim.bo.buftype == 'prompt' and vim.bo.filetype == 'markdown' then
          vim.cmd 'wincmd L' -- Show on right-hand side.
          vim.cmd 'normal G' -- Put cursor at bottom.
        end
      end,
    })
  end,
  config = function()
    require('gp').setup {
      chat_template = [[
      # topic: ?
      - file: {{filename}}
      ---

      {{user_prefix}}
      ]],
      chat_confirm_delete = false,
      -- conceal model parameters in chat
      chat_conceal_model_params = false,
      -- local shortcuts bound to the chat buffer
      -- (be careful to choose something which will work across specified modes)
      chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<leader>gpg' },
      chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<leader>gpd' },
      chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<leader>gpx' },
      chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<leader>gpn' },
      -- -- if true, finished ChatResponder won't move the cursor to the end of the buffer
      -- chat_free_cursor = false,
      -- use prompt buftype for chats (:h prompt-buffer)
      chat_prompt_buf_type = true,

      -- -- templates
      -- template_selection = 'I have the following from {{filename}}:' .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}',
      -- template_rewrite = 'I have the following from {{filename}}:'
      --   .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      --   .. '\n\nRespond exclusively with the snippet that should replace the selection above.',
      -- template_append = 'I have the following from {{filename}}:'
      --   .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      --   .. '\n\nRespond exclusively with the snippet that should be appended after the selection above.',
      -- template_prepend = 'I have the following from {{filename}}:'
      --   .. '\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}'
      --   .. '\n\nRespond exclusively with the snippet that should be prepended before the selection above.',
      -- template_command = '{{command}}',

      whisper = {
        -- you can disable whisper completely by whisper = {disable = true}
        disable = true,
      },

      -- image generation settings
      image = {
        -- you can disable image generation logic completely by image = {disable = true}
        disable = true,
      },
      -- default agent names set during startup, if nil last used agent is used
      default_chat_agent = 'ChatGPT4o',
      default_command_agent = 'CodeGPT4o',
      agents = {
        {
          name = 'ChatGPT4o',
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'You are a general AI assistant.\n\n'
            .. 'The user provided the additional info about how they would like you to respond:\n\n'
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. '- Ask question if you need clarification to provide better answer.\n'
            .. '- Think deeply and carefully from first principles step by step.\n'
            .. '- Zoom out first to see the big picture and then zoom in to details.\n'
            .. '- Use Socratic method to improve your thinking and coding skills.\n'
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
        {
          name = 'CodeGPT4o',
          chat = false,
          command = true,
          -- string with model name or table with model name and parameters
          model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'You are an AI working as a code editor.\n\n'
            .. 'Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n'
            .. 'START AND END YOUR ANSWER WITH:\n\n```',
        },
      },
    }

    -- example hook functions (see Extend functionality section in the README)
    require('which-key').add {
      {
        mode = { 'v' },
        { '<leader>ai', ":<C-u>'<,'>GpRewrite<cr>", desc = 'Visual Rewrite', nowait = true, remap = false },
        { '<leader>aI', ":<C-u>'<,'>GpImplement<cr>", desc = 'Visual Rewrite', nowait = true, remap = false },
        { '<leader>ax', '<cmd>GpStop<cr>', desc = 'GpStop', nowait = true, remap = false },
        -- { '<leader>gpc', ":<C-u>'<,'>GpContext<cr>", desc = 'Visual GpContext', nowait = true, remap = false },
        -- { '<leader>gpn', ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = 'Visual Chat New', nowait = true, remap = false },
        -- { '<leader>gpo', ":<C-u>'<,'>GpNew<cr>", desc = 'Visual GpNew', nowait = true, remap = false },
        -- { '<leader>gpp', ":<C-u>'<,'>GpChatPaste vsplit<cr>", desc = 'Visual Chat Paste', nowait = true, remap = false },
        -- { '<leader>gpt', ":<C-u>'<,'>GpChatToggle vsplit<cr>", desc = 'Visual Toggle Chat', nowait = true, remap = false },
      },
    }

    -- NORMAL mode mappings
    require('which-key').add {
      {
        mode = { 'n' },
        { '<leader>ai', '<cmd>GpRewrite<cr>', desc = 'Inline Rewrite', nowait = true, remap = false },
        { '<leader>ax', '<cmd>GpStop<cr>', desc = 'GpStop', nowait = true, remap = false },
        -- { '<leader>gpc', '<cmd>GpContext<cr>', desc = 'Toggle GpContext', nowait = true, remap = false },
        -- { '<leader>gpf', '<cmd>GpChatFinder<cr>', desc = 'Chat Finder', nowait = true, remap = false },
        -- { '<leader>gpn', '<cmd>GpChatNew vsplit<cr>', desc = 'New Chat', nowait = true, remap = false },
        -- { '<leader>gpo', '<cmd>GpNew<cr>', desc = 'GpNew', nowait = true, remap = false },
        -- { '<leader>gpt', '<cmd>GpChatToggle vsplit<cr>', desc = 'Toggle Chat', nowait = true, remap = false },
      },
    }
  end,
}
