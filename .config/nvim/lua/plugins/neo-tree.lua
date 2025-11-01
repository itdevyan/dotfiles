return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommende
  },
  lazy = false, -- neo-tree will lazily load itself
  config = function()
    local neotree = require("neo-tree")
    neotree.setup({
      filesystem = {
        window = {
          mappings = {
            ["h"] = "close_node",       -- Navigate to parent directory
            ["l"] = "open",             -- Open file or expand directory
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = true,
        use_libuv_file_watcher = true,
      },
    })
    -- Toggle project directory
    vim.keymap.set("n", "<leader>n", function()
      local manager = require("neo-tree.sources.manager")
      local state = manager.get_state("filesystem")
      if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
        vim.cmd("Neotree reveal")
      else
        vim.cmd("Neotree filesystem reveal left")
      end
    end, { desc = "Toggle Neo-tree" })
    -- Close project directory
    vim.keymap.set("n", "<leader>N", "<cmd>Neotree close<CR>", { desc = "Close Neo-tree" })
  end
}
