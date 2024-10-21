return {
  'https://github.com/utilyre/barbecue.nvim',
  version = 'v1.2',
  name = 'barbecue',
  dependencies = {
    'https://github.com/SmiteshP/nvim-navic',
    'https://github.com/nvim-tree/nvim-web-devicons', -- optional dependency
  },
  opts = {
    theme = {
      -- this highlight is used to override other highlights
      -- you can take advantage of its `bg` and set a background throughout your winbar
      -- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
      normal = { fg = '#c0caf5', bg = '#080808' },
    },
    attach_navic = true,
    show_modified = true,
    include_buftypes = { '', 'nowrite' },
    exclude_filetypes = { 'netrw', 'toggleterm' },
    -- lead_custom_section = function()
    --   return '!!!'
    -- end,
  },
}
