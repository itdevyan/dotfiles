-- Toggle wrap
vim.keymap.set("n", "<leader>ww", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

-- Escape commands
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "kk", "<Esc>", { noremap = false })

local severity = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = "✖",
      [severity.WARN] = "⚠",
      [severity.HINT] = "★",
      [severity.INFO] = "✔",
    },
  },
})

-- Oil commands
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
