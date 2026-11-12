-- Helpers shared by the config modules
local M = {}

M.T = "com.superlogical.terminal"
M.SHELL = "com.superlogical.terminal.shell"

-- A terminal's processes; a `rex do` script must name the session, an action may leave it out
function M.process(block_id, session_id)
  return rex.block.call(M.T, "process", { session_id = session_id, block_id = block_id }) or {}
end

function M.foreground(block_id, session_id)
  return M.process(block_id, session_id).foreground
end

local attached = {}
-- A `rex do` script can only call into sessions it is attached to
function M.attach(session_id)
  if not attached[session_id] then
    rex.session.attach({ session_id = session_id })
    attached[session_id] = true
  end
end

-- In a `rex do --all` script: fn(session_id, view) after each change to a session's view
function M.on_view_changed(fn)
  rex.on("session_view_changed", function(ctx)
    M.attach(ctx.session_id)
    local view = rex.session.view({ session_id = ctx.session_id })
    if view then
      fn(ctx.session_id, view)
    end
  end)
end

function M.active_window(session_id)
  local view = rex.session.view({ session_id = session_id }) or {}
  for _, w in ipairs(view.windows or {}) do
    if w.window_id == view.active_window_id then
      return w
    end
  end
end

-- The active window's tiled layout tree, and its focused block
function M.tiled_layout(session_id)
  local w = M.active_window(session_id)
  return w and w.layers and w.layers[1] and w.layers[1].layout, w and w.focused_block_id
end

function M.first_block(node)
  return node.block_id or M.first_block(node.split.before)
end

return M
