-- Label each session "owner/repo::branch" after the git worktree that holds most of its panes,
-- the same label wt's post-remove hook kills, or "owner/repo" for the main worktree. Counted: tiled local terminal panes, placed by the
-- cwd of the pane's shell (where Rex opens a split). A tie goes to the focused pane's worktree,
-- else the first in view order. A session with no counted pane keeps its label.
-- `rex do name-session.lua session=ID` labels one session (zsh precmd, after a cd); with no
-- session it runs as `rex do --all`, started by init.lua, and relabels on each view change.

local lib = require("modules.lib")
-- Paths are tested on this machine, so panes on other hosts don't count
local local_host = rex.call("server.status", {}).host_id

-- Owner path of a remote URL, as wt's {{ owner }}: "git@host:a/b/c.git" or "https://host/a/b/c" -> "a/b"
local function owner(url)
  local path = url:match("^%a[%w+.-]*://[^/]+/(.*)$") or url:match("^[^/]*:(.*)$") or ""
  return path:gsub("/$", ""):gsub("%.git$", ""):match("^(.+)/[^/]+$")
end
assert(owner("git@github.com:fresh2dev/dotfiles.git") == "fresh2dev")
assert(owner("https://gitlab.com/group/sub/proj/") == "group/sub")
assert(owner("ssh://git@host:22/a/b.git") == "a")
assert(owner("/srv/repo.git") == nil)

-- shortcut: owner comes from origin only, while wt uses its primary remote; fine while every repo has origin
local GIT = [[
cd "$1" 2>/dev/null || exit 1
git rev-parse --path-format=absolute --show-toplevel --git-common-dir 2>/dev/null || exit 1
git symbolic-ref -q --short HEAD || git rev-parse --short HEAD
git remote get-url origin 2>/dev/null
exit 0
]]

-- Worktree of a directory: its top level (the key) and its label, or nil outside git
local function worktree(dir)
  local r = rex.exec({ "/bin/sh", "-c", GIT, "sh", dir })
  if not (r and r.ok) then
    return nil
  end
  local top, common, branch, url = r.stdout:match("([^\n]+)\n([^\n]+)\n([^\n]+)\n?([^\n]*)")
  if not top then
    return nil
  end
  -- wt's {{ repo }} is the main checkout's directory: the parent of the shared .git directory
  local repo = common:gsub("/%.git/?$", ""):gsub("%.git$", ""):match("([^/]+)/?$")
  local o = url ~= "" and owner(url)
  -- The main worktree holds the shared .git directory; it gets no branch suffix
  local suffix = common:gsub("/$", "") == top .. "/.git" and "" or "::" .. branch
  return top, (o and o .. "/" or "") .. repo .. suffix
end

-- The pane's shell is the outermost process whose cwd can be read (login, above it, has none)
local function shell_cwd(session_id, block_id)
  local p = lib.process(block_id, session_id)
  local cwd = p.foreground and p.foreground.cwd
  for _, a in ipairs(p.ancestors or {}) do
    cwd = a.cwd or cwd
  end
  return cwd
end

local function relabel(session_id, view)
  local focused
  for _, w in ipairs(view.windows or {}) do
    if w.window_id == view.active_window_id then
      focused = w.focused_block_id
    end
  end

  local by_dir, count, label, order, focused_top = {}, {}, {}, {}, nil
  for _, w in ipairs(view.windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.kind == "tiled" and layer.blocks or {}) do
        local dir = b.creator_name == lib.T and b.host_id == local_host and shell_cwd(session_id, b.block_id)
        if dir then
          by_dir[dir] = by_dir[dir] or { worktree(dir) }
          local top, l = by_dir[dir][1], by_dir[dir][2]
          if top then
            if not count[top] then
              order[#order + 1] = top
              count[top], label[top] = 0, l
            end
            count[top] = count[top] + 1
            if b.block_id == focused then
              focused_top = top
            end
          end
        end
      end
    end
  end

  local best
  for _, top in ipairs(order) do
    if not best or count[top] > count[best] then
      best = top
    end
  end
  if focused_top and count[focused_top] == count[best] then
    best = focused_top
  end
  if best and label[best] ~= view.label then
    rex.call("session.set_label", { session_id = session_id, label = label[best] })
  end
end

local sid = rex.args and rex.args.session
if sid then
  lib.attach(sid)
  local view = rex.session.view({ session_id = sid })
  if view then
    relabel(sid, view)
  end
else
  lib.on_view_changed(relabel)
end
