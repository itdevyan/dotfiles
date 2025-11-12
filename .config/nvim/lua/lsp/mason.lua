return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "ts_ls",
      "lua_ls",
      "jdtls",
      "marksman",
    },
  },
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          icons = {
            package_installed = "✔",
            package_pending = "➡",
            package_unistalled = "✘",
          }
        }
      }
    },
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-jdtls"
  }
}
