-- Code outline sidebar powered by LSP.
return {
  'https://github.com/h3pei/copy-file-path.nvim',
  lazy = true,
  cmd = {
    'CopyRelativeFilePath',
    'CopyAbsoluteFilePath',
    'CopyRelativeFilePathFromHome',
    'CopyFileName',
    'CopyFilePath',
    'CopyAllRelativeFilePaths',
    'CopyAllAbsoluteFilePaths',
    'CopyAllRelativeFilePathsFromHome',
    'CopyAllFileNames',
  },
  keys = {
    { '<leader>yp', ':CopyRelativeFilePath<CR>', desc = '[Y]ank [P]ath' },
    { '<leader>yP', ':CopyAbsoluteFilePath<CR>', desc = '[Y]ank Absolute [P]ath' },
  },
}
