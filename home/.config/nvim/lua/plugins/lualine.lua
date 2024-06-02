local function wordcount()
  return tostring(vim.fn.wordcount().words) .. ' words'
end

local function readingtime()
  return tostring(math.ceil(vim.fn.wordcount().words / 200.0)) .. ' min'
end

local function is_markdown()
  return vim.bo.filetype == 'markdown' or vim.bo.filetype == 'asciidoc'
end

return {
  'https://github.com/nvim-lualine/lualine.nvim',
  dependencies = { 'https://github.com/nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'tokyonight',
      component_separators = { left = '|', right = '|' },
      section_separators = { left = '', right = '' },
      ignore_focus = { 'dashboard', 'neo-tree' },
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          path = 1,
          -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory
        },
      },
      -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_x = {
        { wordcount, cond = is_markdown },
        { readingtime, cond = is_markdown },
        'diagnostics',
        { 'filetype', colored = true, icon_only = false },
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  },
}
