return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  keys = {
    { "<leader>Rs", function() require("kulala").run() end,         desc = "Send request" },
    { "<leader>Ra", function() require("kulala").run_all() end,     desc = "Send all requests" },
    { "<leader>Rr", function() require("kulala").replay() end,      desc = "Replay last request" },
    { "<leader>Rb", function() require("kulala").scratchpad() end,  desc = "Open scratchpad" },
    { "<leader>Ri", function() require("kulala").inspect() end,     desc = "Inspect request" },
    { "<leader>Rc", function() require("kulala").copy() end,        desc = "Copy as cURL" },
    { "<leader>Re", function() require("kulala").set_selected_env() end, desc = "Select environment" },
    { "<leader>Rx", function() require("kulala").clear_cached_files() end, desc = "Clear cached files" },
  },
  opts = {
    global_keymaps = false,
    ui = {
      display_mode = "split",
      split_direction = "right",
      default_view = "body",
      winbar = true,
    },
    kulala_keymaps = {
      ["Previous tab"] = { "<S-Tab>", function() require("kulala.ui").show_previous_tab() end },
      ["Next tab"]     = { "<Tab>",   function() require("kulala.ui").show_next_tab() end },
    },
  },
}
