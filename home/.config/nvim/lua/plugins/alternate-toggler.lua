return {
  'rmagatti/alternate-toggler',
  lazy = false,
  keys = {
    {
      '<leader>ta',
      function()
        require('alternate-toggler').toggleAlternate()
      end,
    },
  },
  config = function()
    require('alternate-toggler').setup {
      alternates = {
        -- builtin:
        -- ['true'] = 'false',
        -- ['True'] = 'False',
        -- ['TRUE'] = 'FALSE',
        -- ['yes'] = 'no',
        -- ['Yes'] = 'No',
        -- ['YES'] = 'NO',
        -- ['1'] = '0',
        -- ['<'] = '>',
        -- ['('] = ')',
        -- ['['] = ']',
        -- ['{'] = '}',
        -- ['"'] = "'",
        -- ['""'] = "''",
        -- ['+'] = '-',
        -- ['==='] = '!==',
      },
    }
  end,
}
