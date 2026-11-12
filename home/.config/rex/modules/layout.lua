-- Resizing and rotating the tiled layout
local lib = require("modules.lib")
local first_block, tiled_layout = lib.first_block, lib.tiled_layout

-- Grow or shrink: move every border the focused pane touches out (grow) or in.
-- For each axis, the pane touches at most two borders: the innermost split with it before (its
-- right or bottom edge) and the innermost split with it after (its left or top edge).
local STEP = 0.05 -- of the window, per border

local function nodes_to(node, id, path)
  if node.block_id then
    return node.block_id == id
  end
  for _, side in ipairs({ "before", "after" }) do
    path[#path + 1] = { node = node, side = side }
    if nodes_to(node.split[side], id, path) then
      return true
    end
    path[#path] = nil
  end
end

local function find_split(node, split_id)
  if node.block_id then
    return
  end
  if node.split.split_id == split_id then
    return node
  end
  return find_split(node.split.before, split_id) or find_split(node.split.after, split_id)
end

rex.action({
  name = "resize_all",
  title = "Grow or Shrink Pane on Every Side",
  args = { grow = "boolean" },
  run = function(ctx, args)
    local layout, id = tiled_layout(ctx.session_id)
    local path = {}
    if not (layout and id and nodes_to(layout, id, path)) then
      return
    end
    -- Pick the borders and their targets in window coordinates first: ratios are relative to
    -- their split, so moving an outer border shifts the inner ones.
    local edges, done = {}, {}
    for i = #path, 1, -1 do
      local n, side = path[i].node, path[i].side
      local key = n.split.direction .. side
      if not done[key] then
        done[key] = true
        local axis = n.split.direction == "horizontal" and 1 or 2 -- rect index: x or y
        local border = n.rect[axis] + n.split.ratio * n.rect[axis + 2]
        local out = side == "before" and STEP or -STEP
        table.insert(edges, 1, { -- outermost first
          split_id = n.split.split_id,
          axis = axis,
          side = side,
          other = first_block(n.split[side == "before" and "after" or "before"]),
          target = border + (args.grow and out or -out),
        })
      end
    end
    for _, e in ipairs(edges) do
      local node = find_split((tiled_layout(ctx.session_id)), e.split_id)
      if node then
        local ratio = (e.target - node.rect[e.axis]) / node.rect[e.axis + 2]
        rex.session.resize_pane({
          session_id = ctx.session_id,
          direction = node.split.direction,
          before_block_id = e.side == "before" and id or e.other,
          after_block_id = e.side == "before" and e.other or id,
          ratio = math.min(0.95, math.max(0.05, ratio)),
        })
      end
    end
  end,
})
rex.bind("alt+=", "resize_all", { grow = true })
rex.bind("alt+-", "resize_all", { grow = false })

-- Rotate the tiled layout 90 degrees. Clockwise, left becomes top and top
-- becomes right; a split whose halves change sides flips its ratio so each pane keeps its share.
local function rotate(node, cw)
  if node.block_id then
    return { block_id = node.block_id }
  end
  local s = node.split
  local before, after = rotate(s.before, cw), rotate(s.after, cw)
  local keep = (s.direction == "horizontal") == cw -- cw keeps left/right order, ccw top/bottom
  return {
    split = {
      direction = s.direction == "horizontal" and "vertical" or "horizontal",
      ratio = keep and s.ratio or 1 - s.ratio,
      before = keep and before or after,
      after = keep and after or before,
    },
  }
end

local function contains(node, id)
  if node.block_id then
    return node.block_id == id
  end
  return contains(node.split.before, id) or contains(node.split.after, id)
end

-- Rex can only place a block beside another block, so rebuild the tree top down: `anchor` is a
-- placed block filling `node`'s space, and each split moves a block from the other half beside it.
-- Blocks that leave the old layout only ever enlarge the placed part, and ratios are per split.
local function build(session_id, node, anchor)
  if node.block_id then
    return
  end
  local s = node.split
  local side = contains(s.before, anchor) and "after" or "before"
  local moved = first_block(s[side])
  rex.session.move_block({
    session_id = session_id,
    block_id = moved,
    anchor_block_id = anchor,
    direction = s.direction,
    side = side,
    ratio = s.ratio,
  })
  build(session_id, s.before, side == "before" and moved or anchor)
  build(session_id, s.after, side == "after" and moved or anchor)
end

rex.action({
  name = "rotate_layout",
  title = "Rotate the Tiled Layout 90 Degrees",
  args = { clockwise = "boolean" },
  run = function(ctx, args)
    local w = lib.active_window(ctx.session_id)
    if w then
      rex.session.zoom_block({ session_id = ctx.session_id, window_id = w.window_id, zoom = false })
    end
    local layout, focused = tiled_layout(ctx.session_id)
    if not (layout and layout.split) then
      return
    end
    local target = rotate(layout, args.clockwise)
    build(ctx.session_id, target, first_block(target))
    if focused then
      rex.session.focus_block({ session_id = ctx.session_id, block_id = focused })
    end
  end,
})
rex.bind("alt+o", "rotate_layout", { clockwise = true })
rex.bind("alt+shift+o", "rotate_layout", { clockwise = false })
