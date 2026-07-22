return {

  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    win = { border = "single" },
    spec = {
      { "<leader>h", group = " git/hunks" },
      { "<leader>f", group = " file/fzf" },
      { "<leader>fy", group = " Copy Path/Reference" },
      { "<leader>g", group = " Git options" },
      { "<leader>j", group = " java/java" },
      { "<leader>jd", group = " Debug options" },
      { "<leader>jb", group = " Build options" },
      { "<leader>jr", group = " Run options" },
      { "<leader>jm", group = " Maven options" },
      { "<leader>gg", group = " LazyGit" },
      { "<leader>l", group = " LSP/TS extras" },
      { "<leader>R", group = " Kulala options" },
      { "<leader>s", group = " Split options" },
      { "<leader>t", group = " Tabs" },
      { "<leader>v", group = " Videre options" },
      { "<leader>w", group = " Word Wrap" },
      { "<leader>.", group = " Options" },
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
