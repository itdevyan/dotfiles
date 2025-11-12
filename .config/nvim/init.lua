-- Globals --------------------------------------------------------------------
vim.g.maplocalleader = ","
vim.g.big_file = { size = 1024 * 5000, lines = 50000 }
vim.g.mapleader = " "

require("core.lazy")
require("core.lsp_cmd")
require("core.commands")
require("core.utils")
require("core.icons.icons")
require("core.icons.fallback_icons")
