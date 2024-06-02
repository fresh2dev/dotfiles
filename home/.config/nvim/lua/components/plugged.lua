-- Create an entry for each plugin managed by vim-plug.

-- Lazy.nvim hijacks neovims native plugin-loading sequence,
-- see:
-- https://lazy.folke.io/usage#%EF%B8%8F-startup-sequence
-- https://neovim.io/doc/user/starting.html#load-pluginsSo we instruct lazy.nvim to respect pl

-- g:plug_home is where vim-plug installs extensions.
local plug_dir = vim.g.plug_home or (vim.fn.stdpath 'data' .. '/plugged')

-- Return nothing if the path doesn't exist.
if vim.fn.isdirectory(plug_dir) == 0 then
  return {}
end

-- Define a lazy.nvim entry for each plugin.
return vim.tbl_map(function(dir_name)
  return {
    dir_name, -- Dir name is plugin name.
    dir = plug_dir .. '/' .. dir_name, -- Full repo path
    pin = true, -- Don't update this plugin.
    lazy = false,
    priority = 100, -- Load these plugins first.
  }
end, vim.fn.readdir(plug_dir))
