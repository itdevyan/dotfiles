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
vim.opt.relativenumber = false

-- UI
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.list = false
--vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 4
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

-- 'scroll' recalculates to half-window-height on EVERY resize (statusline,
-- tabline, plugin UI attaching, etc), not just at startup — vanilla Vim/Neovim
-- quirk, no "sticky" flag survives it. WinScrolled fires after each resize in
-- the tabpage, so reapplying there makes it self-heal instead of a one-shot.
-- TabEnter/TabNew added after Oracle review (2026-07-08, neoscroll.lua round
-- 10 verification): opening a 2nd tab adds a tabline, shrinking every window
-- by a row -- WinScrolled does NOT fire for that specific resize, so without
-- these two events 'scroll' silently drifts to the new half-height and stays
-- there, corrupting the exact "8 lines per <C-d>" distance neoscroll.lua's
-- centering math is built on.
vim.api.nvim_create_autocmd({ "VimEnter", "WinScrolled", "TabEnter", "TabNew" }, {
	callback = function()
		vim.o.scroll = 8
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
	callback = function()
        vim.hl.on_yank()
	end,
	desc = "Highlight yank",
})

-- Split border color (catppuccin yellow)
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#f9e2af", bold = true })
