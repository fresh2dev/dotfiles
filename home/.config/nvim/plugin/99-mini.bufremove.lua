-- mini.bufremove, plus the core "I'm done with this buffer/window" keymaps that
-- build on it: `<leader>w`/`<leader>W` (write), `<leader>x` (quit smart), the
-- `<leader>q*` family, and the :Quit* / :Bdelete / :Bwipeout user commands.
vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.bufremove" },
})

require("mini.bufremove").setup()

-- [[ :Bdelete / :Bwipeout ]]
-- Like :bdelete / :bwipeout but keep the windows open (mini swaps them to
-- another buffer). Accept a buffer number or a name pattern.
local function buf_action(fn)
  return function(opts)
    local bufnr = 0
    if opts.args ~= "" then
      bufnr = tonumber(opts.args) or vim.fn.bufnr(opts.args)
      if bufnr < 0 or not vim.api.nvim_buf_is_valid(bufnr) then
        vim.notify(('No buffer matching "%s"'):format(opts.args), vim.log.levels.ERROR)
        return
      end
    end
    fn(bufnr, opts.bang)
  end
end

vim.api.nvim_create_user_command("Bdelete", buf_action(MiniBufremove.delete), {
  bang = true,
  complete = "buffer",
  nargs = "?",
  desc = "Delete buffer, keep windows (! to discard changes)",
})
vim.api.nvim_create_user_command("Bwipeout", buf_action(MiniBufremove.wipeout), {
  bang = true,
  complete = "buffer",
  nargs = "?",
  desc = "Wipe out buffer, keep windows (! to discard changes)",
})

-- [[ Helpers ]]

--- Non-floating windows, in any tabpage, that show `buf`.
---@param buf integer
---@return integer[]
local function real_wins(buf)
  return vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_config(win).relative == ""
  end, vim.fn.win_findbuf(buf))
end

--- A regular file buffer: listed and without a special 'buftype'. Terminals,
--- scratch buffers, help, quickfix, mini.files, etc. are deliberately excluded
--- so bulk deletes never kill a hidden shell or a plugin's state buffer.
---@param buf integer
local function is_normal(buf)
  return vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
end

local GIT_FILETYPES = {
  git = true,
  gitcommit = true,
  gitrebase = true,
  floggraph = true,
}

--- fugitive / flog / git buffers. Diffview is intentionally not included; it
--- has its own :DiffviewClose and owns its tab layout.
---@param buf integer
local function is_git(buf)
  local ft = vim.bo[buf].filetype
  return GIT_FILETYPES[ft] == true or vim.startswith(ft, "fugitive")
end

--- Delete every loaded buffer for which `predicate` is true. Modified buffers
--- are skipped unless `force`, and reported once at the end.
---@param predicate fun(buf: integer): boolean
---@param force boolean|nil
---@return integer deleted
local function delete_buffers_where(predicate, force)
  local skipped, deleted = {}, 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Deleting one buffer can wipe another via autocmds (bufhidden=delete/wipe),
    -- so re-check validity on every iteration.
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.api.nvim_buf_is_loaded(buf)
      and predicate(buf)
    then
      if vim.bo[buf].modified and not force then
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
        table.insert(skipped, name ~= "" and name or "[No Name]")
      elseif MiniBufremove.delete(buf, force) then
        deleted = deleted + 1
      end
    end
  end
  if #skipped > 0 then
    vim.notify(
      "Kept modified: " .. table.concat(skipped, ", ") .. " (use ! to discard)",
      vim.log.levels.WARN
    )
  end
  return deleted
end

-- [[ Actions ]]

--- Delete git buffers. Windows showing them are closed first (unless a window
--- is the last one in its tab), so the splits opened by `<leader>gg` go away
--- instead of being swapped to some other buffer.
---@param force boolean|nil
local function quit_git(force)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and is_git(vim.api.nvim_win_get_buf(win)) then
      local tab = vim.api.nvim_win_get_tabpage(win)
      if #vim.api.nvim_tabpage_list_wins(tab) > 1 then
        vim.api.nvim_win_close(win, true)
      end
    end
  end
  return delete_buffers_where(is_git, force)
end

--- Delete regular buffers not shown in any (non-floating) window.
--- NOTE: this includes the alternate buffer, so `<leader>qu` (:edit #) will not
--- work immediately afterwards.
---@param force boolean|nil
local function quit_hidden(force)
  return delete_buffers_where(function(buf)
    return is_normal(buf) and #real_wins(buf) == 0
  end, force)
end

--- Keep only the current window and its buffer.
---@param force boolean|nil
local function quit_other(force)
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd.tabonly()
  end
  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.cmd.only()
  end
  return quit_hidden(force)
end

--- Delete every regular buffer (windows stay open on a scratch buffer).
---@param force boolean|nil
local function quit_all(force)
  return delete_buffers_where(is_normal, force)
end

--- Whether every regular buffer other than `cur` is already shown in a
--- (non-floating) window of the current tab.
---@param cur integer
local function other_buffers_visible_in_tab(cur)
  local visible = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      visible[vim.api.nvim_win_get_buf(win)] = true
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      buf ~= cur
      and vim.api.nvim_buf_is_loaded(buf)
      and is_normal(buf)
      and not visible[buf]
    then
      return false
    end
  end
  return true
end

--- A single "I'm done with this view" action. Plain :bdelete is wrong when the
--- buffer is also open in another window (it yanks the buffer out from under
--- that view); plain :close is wrong when this is the only view (the user wanted
--- to drop the buffer, not just the split). So:
---   1. a floating window (zen, zoom, preview) is simply closed;
---   2. if the buffer is shown in another real window, close this window;
---   3. if every other buffer is already visible in this tab, deleting the
---      buffer would only make this window show something that is already on
---      screen, so close the window instead (unless it is the last one);
---   4. otherwise delete the buffer and let mini swap in the next one.
---@param force boolean|nil
local function quit_smart(force)
  local cur = vim.api.nvim_get_current_buf()
  local in_float = vim.api.nvim_win_get_config(0).relative ~= ""
  local last_in_tab = #vim.api.nvim_tabpage_list_wins(0) == 1
  if
    in_float
    or #real_wins(cur) > 1
    or (not last_in_tab and other_buffers_visible_in_tab(cur))
  then
    vim.cmd.close()
  else
    MiniBufremove.delete(cur, force)
  end
end

for name, spec in pairs({
  QuitGit = {
    quit_git,
    "Delete git buffers and close their windows (! to discard changes)",
  },
  QuitHidden = {
    quit_hidden,
    "Delete buffers not shown in any window (! to discard changes)",
  },
  QuitOther = {
    quit_other,
    "Keep only this window and buffer (! to discard changes)",
  },
  QuitAll = { quit_all, "Delete all buffers (! to discard changes)" },
  QuitSmart = {
    quit_smart,
    "Close window if buffer is shown elsewhere, else delete buffer (! to discard)",
  },
}) do
  vim.api.nvim_create_user_command(name, function(opts)
    spec[1](opts.bang)
  end, { bang = true, desc = spec[2] })
end

-- [[ Keymaps ]]
-- Every rhs is an Ex command so `:FzfLua keymaps` shows what the key runs.
for _, m in ipairs({
  { "w", "w", "Write" },
  { "W", "wa", "Write all" },
  { "x", "QuitSmart", "Quit smart" },
  { "qq", "QuitSmart", "Quit smart" },
  { "qe", "Bdelete", "Delete buffer (keep windows)" },
  { "qE", "Bdelete!", "Delete buffer (keep windows, discard changes)" },
  { "qs", "close", "Close window" },
  { "qS", "only", "Only window" },
  { "qt", "tabclose", "Close tab" },
  { "qu", "edit #", "Edit alternate" },
  { "qo", "QuitHidden", "Quit hidden buffers" },
  { "qO", "QuitOther", "Quit other windows and buffers" },
  { "qa", "QuitAll", "Quit all buffers" },
  { "qA", "QuitAll!", "Quit all buffers (discard changes)" },
  { "qg", "QuitGit", "Quit git buffers" },
}) do
  vim.keymap.set(
    "n",
    "<leader>" .. m[1],
    "<Cmd>" .. m[2] .. "<CR>",
    { silent = true, desc = m[3] }
  )
end
