-- Floating panes
local lib = require("modules.lib")

local FLOAT_BOUNDS = { 0.05, 0.1, 0.9, 0.8 } -- x, y, width, height

-- Floating layers in the window that hold the labelled pane, or a pane running `program`
local function find_floating(window, label, program)
  local found = {}
  for _, layer in ipairs(window and window.layers or {}) do
    if layer.kind == "floating" then
      for _, b in ipairs(layer.blocks or {}) do
        local fg = lib.foreground(b.block_id)
        if b.label == label or (fg and fg.name == program) then
          found[#found + 1] = layer
          break
        end
      end
    end
  end
  return found
end

local function open_floating(ctx, label, options)
  local res, err = rex.session.new_layer({
    session_id = ctx.session_id,
    bounds = FLOAT_BOUNDS,
    focus = true,
    layout = rex.layout.block({ flavor = lib.SHELL, options = options }),
  })
  if not res then
    error(err)
  end
  if label then
    rex.session.set_block_label({ session_id = ctx.session_id, block_id = res.block_ids[1], label = label })
  end
end

-- Minimize every floating pane if any is showing, else restore them all, else open one
rex.action({
  name = "toggle_floating",
  title = "Toggle Floating Panes",
  run = function(ctx)
    local floats, showing = {}, false
    for _, layer in ipairs((lib.active_window(ctx.session_id) or {}).layers or {}) do
      if layer.kind == "floating" then
        floats[#floats + 1] = layer
        showing = showing or layer.state ~= "minimized"
      end
    end
    if #floats == 0 then
      local fg = lib.foreground(ctx.block_id)
      open_floating(ctx, nil, { cwd = fg and fg.cwd })
      return
    end
    for i, layer in ipairs(floats) do
      rex.session.set_layer_state({
        session_id = ctx.session_id,
        layer_id = layer.layer_id,
        state = showing and "minimized" or "normal",
        focus = not showing and i == #floats,
      })
    end
  end,
})

-- One labelled floating pane per tab (matched by label or by its running program): minimize
-- every visible one, else restore a minimized one, else open it. `keep_open` leaves the pane
-- open after its command exits.
rex.action({
  name = "float_toggle",
  title = "Toggle a Labelled Floating Pane",
  args = { label = "string", command = "array", keep_open = "boolean?" },
  run = function(ctx, args)
    local minimized, visible = nil, false
    for _, layer in ipairs(find_floating(lib.active_window(ctx.session_id), args.label, args.command[1])) do
      if layer.state == "minimized" then
        minimized = minimized or layer
      else
        visible = true
        rex.session.set_layer_state({ session_id = ctx.session_id, layer_id = layer.layer_id, state = "minimized" })
      end
    end
    if visible then
      return
    end
    if minimized then
      rex.session.set_layer_state({
        session_id = ctx.session_id,
        layer_id = minimized.layer_id,
        state = "normal",
        focus = true,
      })
      return
    end
    local fg = lib.foreground(ctx.block_id)
    open_floating(ctx, args.label, {
      command = args.command,
      cwd = fg and fg.cwd,
      exit = args.keep_open and { on_completion = false } or nil,
    })
  end,
})

-- alt+space is a prefix for floating panes
rex.bind("alt+space>space", "toggle_floating")
rex.bind("alt+space>alt+space", "toggle_floating") -- holding alt through the chord works too
rex.bind("alt+space>j", "float_toggle", { label = "just", command = { "just" }, keep_open = true })
rex.bind("alt+space>p", "float_toggle", { label = "drydock", command = { "drydock" } })
rex.bind("alt+space>n", "float_toggle", { label = "neovim", command = { "nvim" } })

return { find = find_floating, open = open_floating }
