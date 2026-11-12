-- Event watchers. rex.on only works under `rex do`, so run each script in ../ as a detached
-- `rex do --all`, replacing the one a previous config load started.
--   zoom-tabs.lua: tabs above while a pane is zoomed, on the left otherwise
--   name-session.lua: label each session after the worktree that holds most of its panes
--   clear-neorex-tab-labels.lua: drop neorex's tab label once focus leaves its pane
local SCRIPTS = { "zoom-tabs.lua", "name-session.lua", "clear-neorex-tab-labels.lua" }

-- `rex` is not on any PATH outside Rex terminals, so use the CLI from the server bundle.
local HOME = os.getenv("HOME")
local REX = HOME
  .. "/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"

for _, name in ipairs(SCRIPTS) do
  local script = HOME .. "/.config/rex/" .. name
  rex.exec({ "pkill", "-f", "rex do --all " .. script })
  rex.exec.start({ REX, "do", "--all", script }, { detach = true })
end
