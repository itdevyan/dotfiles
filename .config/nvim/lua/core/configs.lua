-- Options & Settings ==========================================================

-- Globals
vim.g.maplocalleader = ","
vim.g.big_file = { size = 1024 * 5000, lines = 50000 }
vim.g.mapleader = " "

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- UI
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 12
vim.o.winborder = "rounded"

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Persistent undo/swap/backup (.local/state/nvim/)
local state = vim.fn.stdpath("state")
vim.opt.directory = state .. "/swap//"
vim.opt.undodir   = state .. "/undo//"
vim.opt.backupdir = state .. "/backup//"
vim.opt.undofile  = true

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})

-- Split border color (catppuccin yellow)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#f9e2af", bold = true })
