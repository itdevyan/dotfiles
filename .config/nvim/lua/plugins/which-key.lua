return {

  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    win = { border = "single" },
    spec = {
      { "<leader>h", name = "+git/hunks" },
      { "<leader>f", name = "+file/fzf" },
      { "<leader>j", name = "+java/java" },
      { "<leader>jd", name = "Debug options" },
      { "<leader>jb", name = "Build options" },
      { "<leader>jr", name = "Run options" },
      { "<leader>g", name = "LazyGit" },
      { "<leader>l", name = "LSP/TS extras" },
      { "<leader>t", name = "Tabs" },
      { "<leader>w", name = "Word Wrap" },
    }
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
