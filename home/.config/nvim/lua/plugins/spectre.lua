return {
  'nvim-pack/nvim-spectre',
  build = false,
  cmd = 'Spectre',
  keys = {
    {
      '<leader>fr',
      function()
        require('spectre').open()
      end,
      mode = 'n',
      desc = '[F]ind, [R]eplace in Project',
    },
    {
      '<leader>fR',
      function()
        require('spectre').open_file_search()
      end,
      mode = 'n',
      desc = '[F]ind, [R]eplace in File',
    },
  },
  opts = {
    open_cmd = 'noswapfile vnew',
    live_update = false, -- auto execute search again when you write to any file in vim
    lnum_for_results = true, -- show line number for search/replace results
    mapping = {
      ['tab'] = {
        map = '<Tab>',
        cmd = "<cmd>lua require('spectre').tab()<cr>",
        desc = 'next query',
      },
      ['shift-tab'] = {
        map = '<S-Tab>',
        cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
        desc = 'previous query',
      },
      ['toggle_line'] = {
        map = 'dd',
        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
        desc = 'toggle item',
      },
      ['enter_file'] = {
        map = '<cr>',
        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
        desc = 'open file',
      },
      ['send_to_qf'] = {
        map = '<leader>e',
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = 'send all items to quickfix',
      },
      ['replace_cmd'] = {
        map = '<leader>c',
        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
        desc = 'input replace command',
      },
      ['show_option_menu'] = {
        map = '<leader>o',
        cmd = "<cmd>lua require('spectre').show_options()<CR>",
        desc = 'show options',
      },
      ['run_current_replace'] = {
        map = '<leader>rc',
        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
        desc = 'replace current line',
      },
      ['run_replace'] = {
        map = '<leader>R',
        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
        desc = 'replace all',
      },
      ['change_view_mode'] = {
        map = '<leader>v',
        cmd = "<cmd>lua require('spectre').change_view()<CR>",
        desc = 'change result view mode',
      },
      ['change_replace_sed'] = {
        map = 'trs',
        cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
        desc = 'use sed to replace',
      },
      ['change_replace_oxi'] = {
        map = 'to',
        cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
        desc = 'use oxi to replace',
      },
      ['toggle_live_update'] = {
        map = 'tu',
        cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
        desc = 'update when vim writes to file',
      },
      ['toggle_ignore_case'] = {
        map = 'ti',
        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
        desc = 'toggle ignore case',
      },
      ['toggle_ignore_hidden'] = {
        map = 'th',
        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
        desc = 'toggle search hidden',
      },
      ['resume_last_search'] = {
        map = '<leader>l',
        cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
        desc = 'repeat last search',
      },
      -- you can put your mapping here it only use normal mode
    },
    find_engine = {
      -- rg is map with finder_cmd
      ['rg'] = {
        cmd = 'rg',
        -- default args
        args = {
          '--pcre2',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
        options = {
          ['ignore-case'] = {
            value = '--ignore-case',
            icon = '[I]',
            desc = 'ignore case',
          },
          ['hidden'] = {
            value = '--hidden',
            desc = 'hidden file',
            icon = '[H]',
          },
          -- you can put any rg search option you want here it can toggle with
          -- show_option function
        },
      },
    },
    replace_engine = {
      ['sed'] = {
        cmd = 'sed',
        args = nil,
        options = {
          ['ignore-case'] = {
            value = '--ignore-case',
            icon = '[I]',
            desc = 'ignore case',
          },
        },
      },
      ['sd'] = {
        cmd = 'sd',
        options = {},
      },
    },
    default = {
      find = {
        --pick one of item in find_engine
        cmd = 'rg',
        options = { 'ignore-case' },
      },
      replace = {
        --pick one of item in replace_engine
        cmd = 'sed',
      },
    },
  },
}
