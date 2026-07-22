-- return {
  -- "lalitmee/cobalt2.nvim",
  -- lazy = false,
  -- priority = 1000,
  -- dependencies = { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" },
  -- config = function()
    -- require("colorbuddy").colorscheme("cobalt2")
-- 
    -- local function highlight(name, changes)
      -- local current = vim.api.nvim_get_hl(0, { name = name })
      -- vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", current, changes))
    -- end
-- 
    -- highlight("Normal", { bg = "none" })
    -- highlight("NormalNC", { bg = "none" })
    -- highlight("Comment", { italic = true })
    -- highlight("Function", { bold = true })
    -- highlight("Keyword", { italic = true })
    -- for _, group in ipairs({ "Operator", "Conditional", "Repeat" }) do
      -- highlight(group, { bold = true })
    -- end
    -- highlight("Boolean", { bold = true, italic = true })
  -- end,
-- }


return {}
