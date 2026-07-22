--[[
return {
  "tiagovla/tokyodark.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent_background = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      identifiers = { italic = true },
      functions = { bold = true },
      variables = {},
    },
    custom_highlights = function(highlights)
      for _, group in ipairs({ "Operator", "Conditional", "Repeat" }) do
        highlights[group].bold = true
      end
      highlights.Boolean.bold = true
      highlights.Boolean.italic = true
      return highlights
    end,
  },
  config = function(_, opts)
    require("tokyodark").setup(opts)
    vim.cmd.colorscheme("tokyodark")
  end,
}
]]

return {}
