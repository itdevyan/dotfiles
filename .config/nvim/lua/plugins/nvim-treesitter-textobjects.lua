return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  init = function()
    -- Disable built-in ftplugin maps to avoid conflicts with textobject keymaps.
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v",  -- charwise
          ["@function.outer"]  = "V",  -- linewise
          ["@class.outer"]     = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = true,
      },
      move = {
        set_jumps = true,
      },
    }

    local select = require("nvim-treesitter-textobjects.select")
    local swap   = require("nvim-treesitter-textobjects.swap")
    local move   = require("nvim-treesitter-textobjects.move")

    -- ── Select ────────────────────────────────────────────────────────────
    vim.keymap.set({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, { desc = "Select outer function" })
    vim.keymap.set({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, { desc = "Select inner function" })
    vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer",    "textobjects") end, { desc = "Select outer class" })
    vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner",    "textobjects") end, { desc = "Select inner class" })
    vim.keymap.set({ "x", "o" }, "ao", function() select.select_textobject("@comment.outer",  "textobjects") end, { desc = "Select outer comment" })
    vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope",    "locals")      end, { desc = "Select language scope" })

    -- ── Swap ──────────────────────────────────────────────────────────────
    vim.keymap.set("n", "<leader>0", function() swap.swap_next("@parameter.inner")     end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "<leader>9", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap with previous parameter" })

    -- ── Move ──────────────────────────────────────────────────────────────
    vim.keymap.set({ "n", "x", "o" }, "]m",  function() move.goto_next_start("@function.outer",              "textobjects") end, { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]]",  function() move.goto_next_start("@class.outer",                 "textobjects") end, { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]o",  function() move.goto_next_start({ "@loop.inner", "@loop.outer" },"textobjects") end, { desc = "Next loop start" })
    vim.keymap.set({ "n", "x", "o" }, "]s",  function() move.goto_next_start("@local.scope",                 "locals")      end, { desc = "Next scope" })
    vim.keymap.set({ "n", "x", "o" }, "]z",  function() move.goto_next_start("@fold",                        "folds")       end, { desc = "Next fold" })

    vim.keymap.set({ "n", "x", "o" }, "]M",  function() move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "][",  function() move.goto_next_end("@class.outer",    "textobjects") end, { desc = "Next class end" })

    vim.keymap.set({ "n", "x", "o" }, "[m",  function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
    vim.keymap.set({ "n", "x", "o" }, "[[",  function() move.goto_previous_start("@class.outer",    "textobjects") end, { desc = "Prev class start" })

    vim.keymap.set({ "n", "x", "o" }, "[M",  function() move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Prev function end" })
    vim.keymap.set({ "n", "x", "o" }, "[]",  function() move.goto_previous_end("@class.outer",    "textobjects") end, { desc = "Prev class end" })

    vim.keymap.set({ "n", "x", "o" }, "]d",  function() move.goto_next("@conditional.outer",     "textobjects") end, { desc = "Next conditional" })
    vim.keymap.set({ "n", "x", "o" }, "[d",  function() move.goto_previous("@conditional.outer", "textobjects") end, { desc = "Prev conditional" })
  end,
}
