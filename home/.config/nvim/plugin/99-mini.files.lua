vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local MiniFiles = require("mini.files")
MiniFiles.setup({
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close = "q",
    go_in = "L",
    go_in_plus = "<CR>",
    go_out = "<BS>",
    go_out_plus = "",
    mark_goto = "'",
    mark_set = "M",
    reset = "<F5>",
    reveal_cwd = "@",
    show_help = "g?",
    synchronize = "<leader>w",
    trim_left = "<",
    trim_right = ">",
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = true,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 25,
  },
})

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. " split")
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)

    -- After splitting window, open the file.
    MiniFiles.go_in({ close_on_file = true })
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak keys to your liking
    map_split(buf_id, "<C-o>", "belowright horizontal")
    map_split(buf_id, "<C-v>", "belowright vertical")
  end,
})

vim.keymap.set("n", "\\", function()
  if not MiniFiles.close() then
    MiniFiles.open(nil, false)
  end
end, { desc = "Show File Explorer" })

vim.keymap.set("n", "|", function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    MiniFiles.reveal_cwd()
  end
end, { desc = "Show File Explorer (at current file)" })
