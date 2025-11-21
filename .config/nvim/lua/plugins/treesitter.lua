local utils = require("core.utils")

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "java", "javascript", "typescript", "html" },
      auto_install = true,
      sync_install = false,
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return utils.is_big_file(bufnr)
        end,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Enter>",
          node_incremental = "<Enter>",
          scope_incremental = false,
          node_decremental = "<Backspace>",
        },
      },
    })
  end,
}
