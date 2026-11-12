-- neorex labels a tab after its Neovim file, and that label stays when focus moves to another
-- pane, so the tab never shows that pane's title (Claude only sets a title, never a label). When a
-- tab's focused pane isn't neorex, clear a label neorex set, which restores Rex's default.
-- Runs as `rex do --all clear-neorex-tab-labels.lua`, started by init.lua.

local lib = require("modules.lib")

-- window -> the label a neorex pane in it had, so it is still known once Neovim quits
local neorex_label = {}

lib.on_view_changed(function(sid, view)
  for _, w in ipairs(view.windows or {}) do
    if w.label and not w.label:match("^Window %x+$") then -- "Window <id>" is Rex's default
      local focused_neorex = false
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do
          local fg = b.creator_name == lib.T and lib.foreground(b.block_id, sid)
          if fg and fg.name == "neorex" then
            if b.label == w.label then
              neorex_label[w.window_id] = w.label
            end
            focused_neorex = focused_neorex or b.block_id == w.focused_block_id
          end
        end
      end
      if not focused_neorex and neorex_label[w.window_id] == w.label then
        rex.call("session.set_window_label", { session_id = sid, window_id = w.window_id, label = "" })
      end
    end
  end
end)
