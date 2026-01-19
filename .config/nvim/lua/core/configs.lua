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
  virtual_lines = true,
  virtual_text = {
    current_line = true
  }
})

-- Oil commands
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })

-- Improved hover
vim.o.winborder = 'rounded'

vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Open Diagnostics in float"})

vim.keymap.set("n", "<leader>cf", function() require('conform').format() end, { desc = "Format current file" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
