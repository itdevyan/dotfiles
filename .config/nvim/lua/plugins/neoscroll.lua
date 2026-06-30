return {
  "karb94/neoscroll.nvim",
  lazy = false,
  config = function()
    local ns = require("neoscroll")
    ns.setup()
    vim.keymap.set("n", "<C-d>", function() ns.ctrl_d({ duration = 150 }); vim.cmd("normal! zz") end)
    vim.keymap.set("n", "<C-u>", function() ns.ctrl_u({ duration = 150 }); vim.cmd("normal! zz") end)
    vim.keymap.set("n", "<C-f>", function() ns.ctrl_f({ duration = 250 }); vim.cmd("normal! zz") end)
    vim.keymap.set("n", "<C-b>", function() ns.ctrl_b({ duration = 250 }); vim.cmd("normal! zz") end)
  end,
}
