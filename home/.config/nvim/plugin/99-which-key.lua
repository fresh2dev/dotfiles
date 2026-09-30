vim.pack.add({
  { src = "https://github.com/folke/which-key.nvim" },
})

require("which-key").setup({
  delay = function(ctx)
    return ctx.plugin and 0 or 1500
  end,
  spec = {
    { "<leader>c", group = "[C]ode" },
    { "<leader>f", group = "[F]ind" },
    { "<leader>g", group = "[G]it" },
    { "<leader>gh", group = "[G]it [H]unk" },
    { "<leader>j", group = "[J]ust" },
    { "<leader>l", group = "[L]azygit" },
    { "<leader>p", group = "[P]aste (replace with register)" },
    { "<leader>q", group = "[Q]uit" },
    { "<leader>t", group = "[T]oggle" },
    { "<leader>z", group = "[Z]oxide" },
    -- Fold mappings
    { "]z", desc = "Jump to end of current fold" },
    { "[z", desc = "Jump to beginning of current fold" },
    { "zj", desc = "Jump to next fold" },
    { "zk", desc = "Jump to previous fold" },
    { "gr", group = "LSP Actions", mode = { "n" } },
  },
})

vim.keymap.set("n", "<leader>tk", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer-local Keymaps (which-key)" })

vim.keymap.set("n", "<leader>tK", function()
  require("which-key").show({ global = true })
end, { desc = "Global Keymaps (which-key)" })
