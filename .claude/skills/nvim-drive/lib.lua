-- Helpers passed as `...` to every file run by `nvim-drive lua`. State that must
-- outlive one call lives in `_G.nvim_drive`, because this file is re-read per call.
local D = {}

_G.nvim_drive = _G.nvim_drive or { diag_at = {} }
local state = _G.nvim_drive

if not state.diag_autocmd then
  -- Fires on every publish, including an empty one, so "server has reported"
  -- can be told apart from "server has reported nothing".
  state.diag_autocmd = vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(ev)
      state.diag_at[ev.buf] = vim.uv.hrtime()
    end,
  })
end

local function ms_since(t0)
  return math.floor((vim.uv.hrtime() - t0) / 1e5) / 10
end

--- Run a Lua file with `D` as its argument; return its result as JSON.
function D.run(path)
  local chunk, err = loadfile(path)
  if not chunk then
    return vim.json.encode({ error = err })
  end
  local ok, res = xpcall(chunk, debug.traceback, D)
  if not ok then
    return vim.json.encode({ error = res })
  end
  local enc_ok, json = pcall(vim.json.encode, res == nil and vim.NIL or res)
  return enc_ok and json or vim.json.encode({ inspect = vim.inspect(res) })
end

--- Open `path` in the current window and return its buffer number.
function D.open(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end

--- Wait until a client named `name` is attached to `buf` and initialized.
--- Returns the client and the milliseconds waited, or nil on timeout.
function D.wait_client(name, timeout, buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local t0 = vim.uv.hrtime()
  local client
  vim.wait(timeout or 10000, function()
    client = vim.lsp.get_clients({ bufnr = buf, name = name })[1]
    return client ~= nil and client.initialized
  end, 20)
  return client, ms_since(t0)
end

--- Wait for the next diagnostics publish on `buf` after `since` (an hrtime;
--- default now). Returns the milliseconds waited, or nil on timeout.
function D.wait_diagnostics(timeout, buf, since)
  buf = buf or vim.api.nvim_get_current_buf()
  since = since or vim.uv.hrtime()
  local done = vim.wait(timeout or 10000, function()
    return (state.diag_at[buf] or 0) > since
  end, 20)
  return done and ms_since(since) or nil
end

--- Diagnostics on `buf` as plain tables, optionally only from client `name`.
function D.diagnostics(buf, name)
  buf = buf or vim.api.nvim_get_current_buf()
  if not name then
    return D.diagnostics_ns(buf, nil)
  end
  local client = vim.lsp.get_clients({ bufnr = buf, name = name })[1]
  if not client then
    return {}
  end
  -- A client's push, pull and per-identifier pull namespaces are all named
  -- "nvim.lsp.<name>.<id>[.<identifier>]"; collect every one of them.
  local prefix = ("nvim.lsp.%s.%d"):format(client.name, client.id)
  local out = {}
  for ns, meta in pairs(vim.diagnostic.get_namespaces()) do
    if meta.name == prefix or vim.startswith(meta.name, prefix .. ".") then
      vim.list_extend(out, D.diagnostics_ns(buf, ns))
    end
  end
  return out
end

function D.diagnostics_ns(buf, ns)
  local out = {}
  for _, d in ipairs(vim.diagnostic.get(buf, { namespace = ns })) do
    out[#out + 1] = {
      lnum = d.lnum + 1,
      col = d.col + 1,
      severity = vim.diagnostic.severity[d.severity],
      source = d.source,
      code = d.code,
      message = d.message,
    }
  end
  return out
end

--- Put the cursor on the `nth` (default 1) plain-text match of `text` in the
--- current buffer, plus `offset` columns. Returns {line, col} (1-based) or nil.
function D.at(text, nth, offset)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local seen = 0
  for i, line in ipairs(lines) do
    local start = 1
    while true do
      local s = line:find(text, start, true)
      if not s then
        break
      end
      seen = seen + 1
      if seen == (nth or 1) then
        local col = s - 1 + (offset or 0)
        vim.api.nvim_win_set_cursor(0, { i, col })
        return { i, col + 1 }
      end
      start = s + 1
    end
  end
end

--- Send an LSP request from the cursor position to every client on the
--- current buffer (or only client `name`). `params` defaults to position
--- params; pass a function to extend them. Returns per-client results and the
--- round-trip time.
function D.request(method, params, opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  local results = {}
  local t0 = vim.uv.hrtime()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = opts.name })) do
    if client:supports_method(method, buf) then
      local p = vim.lsp.util.make_position_params(0, client.offset_encoding)
      if type(params) == "function" then
        p = params(p, client)
      elseif params then
        p = params
      end
      local c0 = vim.uv.hrtime()
      local resp = client:request_sync(method, p, opts.timeout or 5000, buf)
      results[client.name] = {
        ms = ms_since(c0),
        result = resp and resp.result,
        error = resp and resp.err,
        timeout = resp == nil or nil,
      }
    end
  end
  return results, ms_since(t0)
end

--- Server capabilities of client `name` on the current buffer.
function D.capabilities(name)
  local client = vim.lsp.get_clients({ bufnr = 0, name = name })[1]
  return client and client.server_capabilities
end

--- Floating windows (hover, signature help, menus) with their text.
function D.floats()
  local out = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= "" then
      local buf = vim.api.nvim_win_get_buf(win)
      out[#out + 1] = {
        filetype = vim.bo[buf].filetype,
        width = cfg.width,
        height = cfg.height,
        lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false),
      }
    end
  end
  return out
end

--- Run `vim.cmd(cmd)` and return what it printed.
function D.exec(cmd)
  return vim.api.nvim_exec2(cmd, { output = true }).output
end

return D
