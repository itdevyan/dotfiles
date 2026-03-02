return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  config = function()
    local navic = require("nvim-navic")

    require('lualine').setup({
      options = {
        theme = 'catppuccin-mocha'
      },
      sections = {
        lualine_c = {
          {
            function()
              return navic.get_location()
            end,
            cond = function()
              return navic.is_available()
            end,
          },
        },
      },
    })
  end
}

