-- Neovim's <Space> leader from any pane: alt+space>f>f runs <Space>ff in the per-tab "neovim"
-- float, seeded with the focused pane's cwd and, when that pane runs Neovim, its file and line.
-- Neovim stays the source of truth: Rex only forwards the keys.
local lib = require("modules.lib")
local floating = require("modules.floating")

local LABEL = "neovim"
local LETTERS = "abcdefghijklmnopqrstuvwxyz"

local function key_name(c)
  if c:match("%u") then
    return "shift+" .. c:lower()
  end
  return c == "?" and "shift+/" or c
end

-- The socket is named after the server's pid, which is the TUI's `nvim --embed` child.
-- shortcut: macOS only (stdpath('run') is $TMPDIR/nvim.$USER), add $XDG_RUNTIME_DIR for Linux
local function socket(pid)
  local r = rex.exec({
    "sh",
    "-c",
    'for p in $(pgrep -P "$1") "$1"; do ls "${TMPDIR:-$(getconf DARWIN_USER_TEMP_DIR)}"/nvim.*/*/nvim.$p.0 2>/dev/null && exit; done',
    "sh",
    tostring(pid),
  })
  return r and r.stdout:match("[^\n]+")
end

-- Evaluate a Vimscript expression in the Neovim process `fg`. Rex may lack nvim on PATH, so run
-- the same binary the pane runs.
local function remote(fg, expr)
  local sock = socket(fg.pid)
  local r = sock and rex.exec({ fg.path, "--server", sock, "--remote-expr", expr }, { timeout = 2 })
  return r and r.ok and r.stdout or nil
end

-- Lua run in an existing float: an expression (luaeval) over the seed `_A`, inside Vimscript
-- single quotes, so no ' inside.
local SEED_CODE = "(function(a) "
  .. "if a.dir then vim.cmd.tcd(vim.fn.fnameescape(a.dir)) end "
  .. 'if a.file then vim.cmd("edit +" .. a.line .. " " .. vim.fn.fnameescape(a.file)) end '
  .. 'vim.api.nvim_input("<C-\\\\><C-n><Esc><Space>" .. a.keys) end)(_A)'

rex.action({
  name = "nvim_leader",
  title = "Run a Neovim <Space> Mapping in the Floating Neovim",
  args = { keys = "string" },
  run = function(ctx, args)
    local fg = lib.foreground(ctx.block_id)
    local seed = { keys = args.keys, dir = fg and fg.cwd }
    if fg and fg.name == "nvim" then
      local out = remote(fg, "json_encode([getcwd(), expand('%:p'), line('.')])")
      local t = out and rex.json.decode(out)
      if t then
        seed.dir = t[1]
        if t[2] ~= "" then
          seed.file, seed.line = t[2], t[3]
        end
      end
    end

    for _, layer in ipairs(floating.find(lib.active_window(ctx.session_id), LABEL, "nvim")) do
      for _, b in ipairs(layer.blocks or {}) do
        local ffg = lib.foreground(b.block_id)
        if ffg and ffg.name == "nvim" then
          rex.session.set_layer_state({
            session_id = ctx.session_id,
            layer_id = layer.layer_id,
            state = "normal",
            focus = true,
          })
          local json = rex.json.encode(seed):gsub("'", "''")
          remote(ffg, "luaeval('" .. SEED_CODE .. "', json_decode('" .. json .. "'))")
          return
        end
      end
    end

    local cmd = { "nvim" }
    if seed.file then
      cmd[#cmd + 1] = "+" .. seed.line
      cmd[#cmd + 1] = seed.file
    end
    cmd[#cmd + 1] = "-c"
    cmd[#cmd + 1] = 'lua vim.api.nvim_input("<Space>' .. seed.keys .. '")'
    floating.open(ctx, LABEL, { command = cmd, cwd = seed.dir })
  end,
})

-- alt+space>f>… and alt+space>g>… mirror <Space>f… and <Space>g…, lazygit (gg) included.
for _, group in ipairs({ "f", "g" }) do
  for c in (LETTERS .. LETTERS:upper() .. "/?"):gmatch(".") do
    rex.bind("alt+space>" .. group .. ">" .. key_name(c), "nvim_leader", { keys = group .. c })
  end
end
rex.bind("alt+space>shift+f", "nvim_leader", { keys = "F" }) -- <Space>F: resume last picker
