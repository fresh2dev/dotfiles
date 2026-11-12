-- Show tabs above while a pane is zoomed and on the left when it unzooms, however the zoom
-- changed (keys, palette, Rex unzooming on its own). Only a change of zoom acts, so switching
-- tabs or alt+\ isn't undone. Runs as `rex do --all zoom-tabs.lua`, started by init.lua.

local STYLE = { [true] = "horizontal", [false] = "vertical" } -- Workspace.tabStyle: above, left
local zoomed = {} -- window_id -> whether it had a zoomed pane at the last view change (never cleared: ids are cheap)

local function has(list, value)
  for _, v in ipairs(list or {}) do
    if v == value then
      return true
    end
  end
end

-- Rex can only toggle the tab style, so read the app's current one first
local function set_tab_style(session_id, style)
  local r = rex.exec({ "/usr/bin/defaults", "read", "com.superlogical.rex", "Workspace.tabStyle" })
  if r and r.ok and r.stdout:match("%S+") == style then
    return
  end
  local list = rex.call("client.list", {}) or {}
  for _, c in ipairs(list.clients or {}) do
    if c.info and c.info.kind == "app" and has(c.session_ids, session_id) then
      rex.call("client.perform", { client_id = c.client_id, action = "client.tab_style.toggle" })
    end
  end
end

rex.on("session_view_changed", function(ctx)
  local view = rex.session.view({ session_id = ctx.session_id })
  for _, w in ipairs(view and view.windows or {}) do
    local now = w.zoomed_block_id ~= nil
    local before = zoomed[w.window_id] or false -- a window not seen yet counts as unzoomed
    zoomed[w.window_id] = now
    if before ~= now then
      set_tab_style(ctx.session_id, STYLE[now])
    end
  end
end)
