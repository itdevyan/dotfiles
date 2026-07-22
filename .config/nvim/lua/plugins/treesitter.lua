local utils = require("core.utils")

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup {
      install_dir = vim.fn.stdpath("data") .. "/site",
    }

    require("nvim-treesitter").install {
      "lua", "java", "javascript", "typescript", "tsx", "html",
      "vim", "query", "json", "xml" -- useful for nvim config and ts query files
    }

    -- Enable treesitter highlighting, indentation, and folding per filetype,
    -- skipping large files via the existing big-file guard.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "lua", "java", "javascript", "typescript", "typescriptreact",
        "html", "vim", "query", "json", "xml",
      },
      callback = function(ev)
        if utils.is_big_file(ev.buf) then
          return
        end
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          -- Enable treesitter-based folding (official README recommendation)
          vim.wo[0][0].foldmethod = "expr"
          vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo[0][0].foldlevel = 99   -- all folds open on buffer open
          vim.wo[0][0].foldenable = true -- keep folding available (zc/zM to close)
        end
      end,
    })
  end,
}
