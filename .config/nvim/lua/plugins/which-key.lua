return {

  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    win = { border = "single" },
    spec = {
      { "<leader>h", name = " git/hunks" },
      { "<leader>f", name = " file/fzf" },
      { "<leader>g", name = " Git options" },
      { "<leader>j", name = " java/java" },
      { "<leader>jd", name = " Debug options" },
      { "<leader>jb", name = " Build options" },
      { "<leader>jr", name = " Run options" },
      { "<leader>jm", name = " Maven options" },
      { "<leader>gg", name = " LazyGit" },
      { "<leader>l", name = " LSP/TS extras" },
      { "<leader>R", name = " Kulala options" },
      { "<leader>s", name = " Split options" },
      { "<leader>t", name = " Tabs" },
      { "<leader>v", name = " Videre options" },
      { "<leader>w", name = " Word Wrap" },
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
