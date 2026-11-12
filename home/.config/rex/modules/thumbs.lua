-- rex-thumbs (https://github.com/chaosteil/rex-thumbs): alt+y puts hints on the URLs, paths and
-- hashes on screen; a hint copies its text, shift+hint also pastes it. `mise run recipes bootstrap`
-- clones it outside this repo, so the config still loads before the clone exists.
local path = os.getenv("HOME") .. "/.local/share/rex/rex-thumbs/init.lua"
local ok, thumbs = pcall(dofile, path)
if ok then
  thumbs.setup({ key = "alt+y" })
end
