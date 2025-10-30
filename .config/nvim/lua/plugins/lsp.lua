return {
  {
    "mason-org/mason.nvim",
    opts = {},   -- default options
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "mason-org/mason.nvim" },
    opts = {
      --ensure_installed = { "lua_ls", "ts_ls" },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip", -- enable snippets
      "saadparwaiz1/cmp_luasnip", -- source snippets
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "antosha417/nvim-lsp-file-operations", config = true }, -- Syncronize changes between files and LSP
      { "folke/lazydev.nvim", opts = {} }, -- Add autocomplete and typo of lua develops
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  }
}
