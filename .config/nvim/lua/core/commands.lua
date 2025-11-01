-- Base configs
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number")
vim.cmd("set relativenumber")

-- disable wrap by default
vim.opt.wrap = false

-- Toggle wrap
vim.keymap.set("n", "<leader>ww",
  function()
    vim.wo.wrap = not vim.wo.wrap
  end, { desc = "Toggle wrap" })

-- Escape commands
vim.api.nvim_set_keymap("i", "jj","<Esc>", { noremap = false } )
vim.api.nvim_set_keymap("i", "jk","<Esc>", { noremap = false } )
vim.api.nvim_set_keymap("i", "kk","<Esc>", { noremap = false } )
