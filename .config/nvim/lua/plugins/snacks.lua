return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      exclude = {
        ".git",
        "node_modules",
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        filename_bonus = true,
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    lazygit = {
      enabled = true,
    },
    dashboard = {
      sections = {
        { pane = 1, section = "header" },
        { section = "startup", padding = 1 },
        {
          pane = 1,
          icon = " ",
          title = "Recent Files (Project)",
          section = "recent_files",
          -- `cwd = true` will use your current working directory
          cwd = true,
          limit = 8,
          indent = 2,
          padding = 1,
        },
        {
          pane = 1,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          --height = 2,
          ttl = 5 * 60,
          indent = 3,
          padding = 1,
        },
        { pane = 1, icon = " ", title = "Options", section = "keys", indent = 2, padding = 1 },
        --{ pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        --{ pane = 1, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        --[[{
          section = "projects",
          icon = " ",
          title = "Projects",
          indent = 2,
          padding = 1,
          limit = 10,
          items = function()
            local base = vim.fn.expand("~/BancoChile/Repositorios")
            local dirs = vim.fn.readdir(base, function(name)
            return vim.fn.isdirectory(base .. "/" .. name) == 1 end)
            local items = {}
            for i, name in ipairs(dirs) do
              table.insert(items, {
                icon = " ",
                desc = name,
                key = tostring(i), -- numbers 1,2,3,...
                action = string.format(":cd %s/%s | e .<CR>", base, name),
              })
              end
            return items
          end,
        },]]
      },
      preset = {
        header = [[

      dP                   M""MMMM""M                   
      88                   M. `MM' .M                   
.d888b88 .d8888b. dP   .dP MM.    .MM .d8888b. 88d888b. 
88'  `88 88ooood8 88   d8' MMMb  dMMM 88'  `88 88'  `88 
88.  .88 88.  ... 88 .88'  MMMM  MMMM 88.  .88 88    88 
`88888P8 `88888P' 8888P'   MMMM  MMMM `88888P8 dP    dP 
                           MMMMMMMMMM                   
        ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          --{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          --{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          --{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          --{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
          --{ icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "g", desc = "LazyGit", action = ":LazyGit" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      }
    },
  }
}
