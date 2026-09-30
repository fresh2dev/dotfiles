-- TODO: determine which keymaps are essential, then remove the rest.

-- Runs for every markdown buffer. Plugin install and `setup()` happen once; the
-- buffer-local keymaps and which-key groups below the guard are (re)applied per
-- buffer.
--
-- markdown-plus.nvim owns lists (continuation, indent, renumbering, checkboxes,
-- type toggling), inline formatting, headings and the TOC, links and images,
-- tables, fenced code blocks, blockquotes and callouts, footnotes and thematic
-- breaks. Its default keymaps are disabled: <localleader> is <Space> here, so the
-- upstream prefixes (<localleader>t, <localleader>lt, <localleader>h) and `]b`
-- would shadow the global Toggle and Lazygit groups and buffer navigation.
-- Everything is mapped explicitly under <localleader>m via the plugin's <Plug>
-- mappings instead; `gd` is left to the LSP and `<C-t>` keeps its insert-mode
-- indent.
if not vim.g.loaded_markdown_config then
  vim.g.loaded_markdown_config = true

  vim.pack.add({
    { src = "https://github.com/YousefHadder/markdown-plus.nvim" },
  })

  require("markdown-plus").setup({
    keymaps = { enabled = false },
    -- H2 and H3, matching the TOC in this repo's README.
    toc = { initial_depth = 3 },
    -- <localleader>mp: paste a clipboard URL as a link, fetching the page title
    -- over HTTP for the link text (falls back to a prompt).
    links = { smart_paste = { enabled = true, timeout = 5 } },
    table = {
      keymaps = { enabled = true, prefix = "<localleader>mt" },
    },
  })
end

local mp = require("markdown-plus")
local buf = vim.api.nvim_get_current_buf()

-- Table keymaps come from the plugin itself (prefix set in `setup()` above) so
-- their descriptions stay in sync with upstream. `<A-h/j/k/l>` move between cells
-- in insert mode and fall back to cursor movement outside a table.
require("markdown-plus.table.keymaps").setup_buffer_keymaps(mp.config.table)

local function map(modes, lhs, plug, desc)
  vim.keymap.set(modes, lhs, "<Plug>(MarkdownPlus" .. plug .. ")", {
    buffer = true,
    desc = desc,
  })
end

-- Context-aware editing keys. Each one acts only inside a list (or a table for
-- the navigation keys) and otherwise hands the key back to whatever mapping it
-- displaced (blink, autopairs) or to the native behaviour.
map("i", "<CR>", "ListEnter", "Continue list")
map("i", "<A-CR>", "ListShiftEnter", "Continue list content on next line") -- TODO: remove `alt` mapping
map("i", "<Tab>", "ListIndent", "Indent list item")
map("i", "<S-Tab>", "ListOutdent", "Outdent list item")
map("n", "o", "NewListItemBelow", "New list item below")
map("n", "O", "NewListItemAbove", "New list item above")

-- <BS> is owned here rather than by the plugin: nvim-autopairs (re)maps it
-- buffer-locally from its own FileType/BufEnter autocmds, which run after this
-- file and would replace a plain <Plug> mapping. Apply ours once those have
-- finished: remove the marker of an empty list item, otherwise defer to
-- autopairs (upstream recipe, see :help markdown-plus-interop).
local bs_plug =
  vim.api.nvim_replace_termcodes("<Plug>(MarkdownPlusListBackspace)", true, true, true)
vim.schedule(function()
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.keymap.set("i", "<BS>", function()
    if mp.in_list_context("backspace") then
      return bs_plug
    end
    return require("nvim-autopairs").autopairs_bs()
  end, {
    buffer = buf,
    expr = true,
    replace_keycodes = false,
    desc = "Remove empty list marker, else autopairs delete",
  })
end)

-- Navigation (bracket pairs; `]b`/`[b` stay buffer navigation)
map("n", "]]", "NextHeader", "Next heading")
map("n", "[[", "PrevHeader", "Previous heading")
map("n", "]f", "CodeBlockNext", "Next code [F]ence")
map("n", "[f", "CodeBlockPrev", "Previous code [F]ence")

-- Inline formatting
map({ "n", "x" }, "<localleader>mb", "Bold", "Toggle [B]old")
map({ "n", "x" }, "<localleader>mi", "Italic", "Toggle [I]talic")
map({ "n", "x" }, "<localleader>mS", "Strikethrough", "Toggle [S]trikethrough")
map({ "n", "x" }, "<localleader>m`", "Code", "Toggle inline code")
map({ "n", "x" }, "<localleader>m=", "Highlight", "Toggle highlight (==)")
map({ "n", "x" }, "<localleader>mu", "Underline", "Toggle [U]nderline")
map({ "n", "x" }, "<localleader>mF", "ClearFormatting", "Clear [F]ormatting")
map("x", "<localleader>me", "EscapeSelection", "[E]scape/unescape punctuation")

-- Lists
map({ "n", "x" }, "<localleader>mx", "ToggleCheckbox", "Toggle checkbo[X]")
map("n", "<localleader>mr", "RenumberLists", "[R]enumber ordered lists")
for _, t in ipairs({
  { "u", "Unordered", "[U]nordered (-)" },
  { "t", "Task", "[T]ask (- [ ])" },
  { "n", "Ordered", "[N]umbered (1.)" },
  { "N", "OrderedParen", "[N]umbered (1))" },
  { "l", "LetterLower", "[L]ettered (a.)" },
  { "L", "LetterUpper", "[L]ettered (A.)" },
  { "p", "LetterLowerParen", "Lettered (a))" },
  { "P", "LetterUpperParen", "Lettered (A))" },
  { "c", "Clear", "[C]lear list markers" },
}) do
  map({ "n", "x" }, "<localleader>ml" .. t[1], "ToggleList" .. t[2], t[3])
end

-- Headings and table of contents
map("n", "<localleader>m+", "PromoteHeader", "Promote heading (add #)")
map("n", "<localleader>m-", "DemoteHeader", "Demote heading (remove #)")
for i = 1, 6 do
  map("n", "<localleader>m" .. i, "Header" .. i, "Set heading level " .. i)
end
map("n", "<localleader>ms", "ToggleAtxSetext", "Toggle ATX/[S]etext heading")
map("n", "<localleader>mTg", "GenerateTOC", "[G]enerate TOC")
map("n", "<localleader>mTu", "UpdateTOC", "[U]pdate TOC")
map("n", "<localleader>mTo", "OpenTocWindow", "[O]pen TOC window (:Toc)")

-- Links and images
map("n", "<localleader>mk", "InsertLink", "Insert lin[K]")
map("x", "<localleader>mk", "SelectionToLink", "Selection to lin[K]")
map("n", "<localleader>me", "EditLink", "[E]dit link under cursor")
map("n", "<localleader>ma", "AutoLinkURL", "[A]uto-link URL under cursor")
map("n", "<localleader>mp", "SmartPaste", "[P]aste clipboard URL as link")
map("n", "<localleader>mR", "ConvertToReference", "To [R]eference-style link")
map("n", "<localleader>mI", "ConvertToInline", "To [I]nline link")
map("n", "<localleader>mg", "InsertImage", "Insert ima[G]e")
map("x", "<localleader>mg", "SelectionToImage", "Selection to ima[G]e")
map("n", "<localleader>mG", "EditImage", "Edit ima[G]e under cursor")
map("n", "<localleader>mA", "ToggleImageLink", "Toggle link <-> im[A]ge")

-- Code blocks, quotes, callouts, thematic breaks
map({ "n", "x" }, "<localleader>mc", "CodeBlockInsert", "Insert/wrap [C]ode block")
map("n", "<localleader>mC", "CodeBlockChangeLanguage", "[C]hange code block language")
map({ "n", "x" }, "<localleader>mq", "ToggleQuote", "Toggle block[Q]uote")
map({ "n", "x" }, "<localleader>mQi", "InsertCallout", "[I]nsert/wrap callout")
map("n", "<localleader>mQt", "ToggleCalloutType", "Cycle callout [T]ype")
map("n", "<localleader>mQc", "ConvertToCallout", "Blockquote to [C]allout")
map("n", "<localleader>mQb", "ConvertToBlockquote", "Callout to [B]lockquote")
map("n", "<localleader>mh", "InsertThematicBreak", "Insert [H]orizontal rule")
map("n", "<localleader>mH", "CycleThematicBreak", "Cycle [H]orizontal rule style")

-- Footnotes
map("n", "<localleader>mfi", "FootnoteInsert", "[I]nsert footnote")
map("n", "<localleader>mfe", "FootnoteEdit", "[E]dit footnote")
map("n", "<localleader>mfd", "FootnoteDelete", "[D]elete footnote")
map("n", "<localleader>mfg", "FootnoteGotoDefinition", "[G]o to definition")
map("n", "<localleader>mfr", "FootnoteGotoReference", "Go to [R]eference")
map("n", "<localleader>mfn", "FootnoteNext", "[N]ext footnote")
map("n", "<localleader>mfp", "FootnotePrev", "[P]revious footnote")
map("n", "<localleader>mfl", "FootnoteList", "[L]ist footnotes")

-- which-key groups (buffer-local, so they only show in markdown buffers)
require("which-key").add({
  { "<localleader>m", group = "[M]arkdown", buffer = buf, mode = { "n", "x" } },
  { "<localleader>ml", group = "[L]ist type", buffer = buf, mode = { "n", "x" } },
  { "<localleader>mT", group = "[T]OC", buffer = buf },
  { "<localleader>mQ", group = "Callout", buffer = buf, mode = { "n", "x" } },
  { "<localleader>mf", group = "[F]ootnote", buffer = buf },
  { "<localleader>mt", group = "[T]able", buffer = buf },
  { "<localleader>mtd", group = "[D]elete", buffer = buf },
  { "<localleader>mti", group = "[I]nsert", buffer = buf },
  { "<localleader>mtm", group = "[M]ove", buffer = buf },
  { "<localleader>mts", group = "[S]ort", buffer = buf },
  { "<localleader>mtv", group = "CSV", buffer = buf },
  { "<localleader>mty", group = "Duplicate ([Y]ank)", buffer = buf },
})
