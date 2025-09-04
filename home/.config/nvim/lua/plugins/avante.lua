return {
  'https://github.com/yetone/avante.nvim',
  event = 'VeryLazy',
  cmd = { 'AvanteAsk' },
  version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'MeanderingProgrammer/render-markdown.nvim',
  },
  opts = {
    provider = 'gemini_pro',
    providers = {
      openrouter_anthropic = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'anthropic/claude-sonnet-4',
      },
      openrouter_deepseek = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'deepseek/deepseek-chat-v3-0324',
        disable_tools = true, -- Required, but doens't seem to actually disable tools.
      },
      gemini_pro = {
        __inherited_from = 'gemini',
        api_key_name = 'GEMINI_API_KEY',
        model = 'gemini-2.5-pro',
      },
      gemini_flash = {
        __inherited_from = 'gemini',
        api_key_name = 'GEMINI_API_KEY',
        model = 'gemini-2.5-flash',
      },
    },
    hints = { enabled = false },
    windows = {
      width = 40, -- default % based on available width
      -- position = 'right', -- the position of the sidebar
      -- wrap = true, -- similar to vim.o.wrap
      -- input = {
      --   height = 8, -- Height of the input window in vertical layout
      -- },
      -- edit = {
      --   start_insert = true, -- Start insert mode when opening the edit window
      -- },
      -- ask = {
      --   floating = true, -- Open the 'AvanteAsk' prompt in a floating window
      --   start_insert = true, -- Start insert mode when opening the ask window
      -- },
    },
    dual_boost = {
      enabled = false,
      first_provider = 'openrouter_anthropic',
      second_provider = 'openrouter_deepseek',
      prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
      timeout = 60000, -- Timeout in milliseconds
    },
    web_search_engine = {
      provider = 'tavily', -- tavily, serpapi, searchapi, google or kagi
    },
    mappings = {
      -- diff = {
      --   ours = '<leader>co',
      --   theirs = '<leader>ct',
      --   all_theirs = '<leader>ca',
      --   both = '<leader>cb',
      --   cursor = '<leader>cc',
      --   next = ']x',
      --   prev = '[x',
      -- },
      -- suggestion = {
      --   accept = '<M-l>',
      --   next = '<M-]>',
      --   prev = '<M-[>',
      --   dismiss = '<C-]>',
      -- },
      jump = {
        next = ']]',
        prev = '[[',
      },
      submit = {
        -- normal = '<CR>',
        normal = '<C-s>',
        insert = '<C-s>',
      },
      sidebar = {
        apply_all = 'A',
        apply_cursor = 'a',
        retry_user_request = 'r',
        edit_user_request = 'e',
        switch_windows = '<Tab>',
        reverse_switch_windows = '<S-Tab>',
        remove_file = 'd',
        add_file = '@',
        close = { 'q' },
        close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
      },
    },
  },
}
