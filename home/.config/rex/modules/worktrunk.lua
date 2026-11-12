-- rex-worktrunk (https://github.com/haxybaxy/rex-worktrunk): one Rex session per worktree, opened
-- with `wt`, so wt's hooks run. `mise run recipes bootstrap` clones it outside this repo, so the
-- config still loads before the clone exists. Worktree sessions close on `wt remove` through the
-- post-remove hook in ~/.config/worktrunk/config.toml.
local path = os.getenv("HOME") .. "/.local/share/rex/rex-worktrunk/init.lua"
local ok, worktrunk = pcall(dofile, path)
if ok then
  worktrunk.setup({ picker = "native" })
  -- Pick with pj in a float, from any pane, and switch to the pick's session; esc in pj opens nothing.
  -- alt+0: any project. alt+t: the focused pane's repo and its worktrees.
  local function pj_float(key, label, pj)
    rex.bind(key, "float_toggle", {
      label = label,
      command = { "sh", "-c", "p=$(command " .. pj .. ') && rex do worktree_go path="$p"' },
    })
  end
  pj_float("alt+0", "pj", "pj")
  pj_float("alt+t", "pj-worktrees", "pj --worktrees")
  -- alt+shift+t: the same family plus its branches; a name that matches nothing creates the worktree.
  rex.bind("alt+shift+t", "worktree")
end
