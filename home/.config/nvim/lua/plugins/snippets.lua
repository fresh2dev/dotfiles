-- Snippet integration with `fzf-lua`, from:
-- https://github.com/towry/nvim/blob/e0dc02c216467bf0609024ba8c60501003daf087/lua/userlib/snippets/init.lua#L12
local function get_snippet_info_desc(description)
  if type(description) == 'string' then
    return description
  elseif type(description) == 'table' then
    return description[1]
  end
  return ''
end

local function get_available_snippets()
  local lua_snippets = require 'snippets'
  local snippets_flatten = {}

  --- { [snippet_name] = { body = 'string', description = 'string', prefix =
  --- 'string' }
  lua_snippets.load_snippets_for_ft(vim.bo.filetype)
  local availables = lua_snippets.get_loaded_snippets() or {}

  for snippet_name, snippet_definition in pairs(availables) do
    table.insert(snippets_flatten, {
      name = snippet_name,
      description = get_snippet_info_desc(snippet_definition.description),
      body = snippet_definition.body,
      trigger = snippet_definition.prefix,
    })
  end

  return snippets_flatten
end

local function fzf_complete_snippet(opts)
  local fzflua = require 'fzf-lua'

  opts = opts or {}
  opts.winopts = {
    fullscreen = false,
  }

  local snippets = get_available_snippets()
  if #snippets <= 0 then
    vim.notify('No snippets found', vim.log.levels.WARN)
    return
  end

  -- Uncomment to search for word under cursor.
  -- if not opts.query then
  --   local match = '[^%s"\']*'
  --   local line = vim.api.nvim_get_current_line()
  --   local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  --   local before = col > 1 and line:sub(1, col - 1):reverse():match(match):reverse() or ''
  --   opts.query = before or ''
  -- end

  opts.actions = opts.actions
    or {
      ['default'] = function(selected, _opts)
        local select = selected[1]
        --- extract index from select by pattern index: ...
        local index = select:match '^%d+'
        local sp = snippets[tonumber(index)]
        if not sp then
          vim.notify('No snippets selected', vim.log.levels.WARN)
          return
        end

        if not sp.body then
          return
        end

        local body = type(sp.body) == 'string' and sp.body or table.concat(sp.body, '\n')

        vim.defer_fn(function()
          vim.cmd.startinsert()
          vim.snippet.expand(body)
        end, 1)
      end,
    }

  -- use snippets[index].description or .trigger
  local contents = vim
    .iter(ipairs(snippets))
    :map(function(i, snip)
      return string.format('%s: `%s` (%s)', i, snip.name, snip.description)
    end)
    :totable()

  opts.fzf_opts = {
    ['--preview'] = 'echo {} && butter --help',
    ['--preview-window'] = 'nohidden,down,50%',
    -- previewer = function(entry)
    --   local index = entry:match '^%d+'
    --   local sp = snippets[tonumber(index)]
    --   if not sp or not sp.body then
    --     return ''
    --   end
    --   return type(sp.body) == 'string' and sp.body or table.concat(sp.body, '\n')
    -- end,
  }

  opts.prompt = 'Snippets> '
  -- opts.previewer = 'builtin'
  local builtin = require 'fzf-lua.previewer.builtin'

  -- Inherit from "base" instead of "buffer_or_file"
  local MyPreviewer = builtin.base:extend()

  function MyPreviewer:new(o, opts, fzf_win)
    MyPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, MyPreviewer)
    return self
  end

  function MyPreviewer:populate_preview_buf(entry_str)
    local tmpbuf = self:get_tmp_buffer()

    local index = entry_str:match '^%d+'
    local sp = snippets[tonumber(index)]
    if not sp or not sp.body then
      return ''
    end

    -- vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, {
    --   -- string.format('SELECTED FILE: %s', entry_str),
    --   type(sp.body) == 'string' and sp.body or table.concat(sp.body, '\n'),
    -- })

    vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, type(sp.body) == 'string' and { sp.body } or sp.body)
    -- vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, { vim.lsp.util.parse_snippet(sp.body) })

    self:set_preview_buf(tmpbuf)
    self.win:update_scrollbar()
  end

  -- Disable line numbering and word wrap
  function MyPreviewer:gen_winopts()
    local new_winopts = {
      wrap = false,
      number = false,
    }
    return vim.tbl_extend('force', self.winopts, new_winopts)
  end --
  opts.previewer = MyPreviewer
  -- opts.previewer = function(entry)
  --   local index = entry:match '^%d+'
  --   local sp = snippets[tonumber(index)]
  --   if not sp or not sp.body then
  --     return ''
  --   end
  --   return type(sp.body) == 'string' and sp.body or table.concat(sp.body, '\n')
  -- end

  return fzflua.fzf_exec(contents, opts)
end

return {
  {
    'https://github.com/garymjr/nvim-snippets',
    lazy = false,
    dependencies = {
      {
        'https://github.com/fresh2dev/friendly-snippets',
        branch = 'dev',
      },
      -- {
      --   'https://github.com/chrisgrieser/nvim-scissors',
      --   config = function()
      --     require('scissors').setup {
      --       snippetDir = snippet_dir,
      --       jsonFormatter = 'jq',
      --     }
      --   end,
      -- },
    },
    config = function()
      require('snippets').setup {
        create_autocmd = true,
        create_cmp_source = false,
        friendly_snippets = true,
        ignored_filetypes = nil,
        -- search_paths = { '/Users/donald/.vim/snippets' },
        -- global_snippets = { 'all' },
        extended_filetypes = {
          markdown = { 'html' },
        },
      }
    end,
    keys = {
      {
        '<leader>fi',
        function()
          fzf_complete_snippet()
          vim.cmd.startinsert()
        end,
        desc = '[F]ind Snippets',
        mode = { 'n' },
      },
      -- {
      --   '<Tab>',
      --   function()
      --     if vim.snippet.active { direction = 1 } then
      --       vim.schedule(function()
      --         vim.snippet.jump(1)
      --       end)
      --       return
      --     end
      --     return '<Tab>'
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = 'i',
      -- },
      -- {
      --   '<Tab>',
      --   function()
      --     vim.schedule(function()
      --       vim.snippet.jump(1)
      --     end)
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = 's',
      -- },
      -- {
      --   '<S-Tab>',
      --   function()
      --     if vim.snippet.active { direction = -1 } then
      --       vim.schedule(function()
      --         vim.snippet.jump(-1)
      --       end)
      --       return
      --     end
      --     return '<S-Tab>'
      --   end,
      --   expr = true,
      --   silent = true,
      --   mode = { 'i', 's' },
      -- },
    },
  },
}
