-- Toggle wrap
vim.keymap.set("n", "<leader>ww", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

-- Finding selected text
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Find selected text" })

-- Copy to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Cut to clipboard
vim.keymap.set("v", "<leader>x", '"+x', { desc = "Cut to clipboard" })

-- Escape commands
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })
vim.api.nvim_set_keymap("i", "kk", "<Esc>", { noremap = false })

-- Moving lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

-- Indent with Tab
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Diagnostic configuration
local severity = vim.diagnostic.severity
vim.diagnostic.config({
	signs = {
		text = {
			[severity.ERROR] = "✖",
			[severity.WARN] = "⚠",
			[severity.HINT] = "★",
			[severity.INFO] = "✔",
		},
	},
	virtual_lines = true,
	virtual_text = {
		current_line = true,
	},
})

-- Oil commands
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })

-- Improved hover
vim.o.winborder = "rounded"

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in float" })

vim.keymap.set("n", "<leader>lf", function()
	require("conform").format()
end, { desc = "Format current file" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- nvim-java
-- Runner commands
vim.keymap.set("n", "<leader>jrr", "<cmd>JavaRunnerRunMain<CR>", { desc = "[Run] Runs the application main class" })
vim.keymap.set("n", "<leader>jrs", "<cmd>JavaRunnerStopMain<CR>", { desc = "[Run] Stops the running application" })

-- Build commands
vim.keymap.set("n", "<leader>jbc", "<cmd>JavaBuildCleanWorkspace<CR>", { desc = "[Build] Clear the workspace cache" })
vim.keymap.set("n", "<leader>jbb", "<cmd>JavaBuildBuildWorkspace<CR>", { desc = "[Build] Builds a full workspace" })

-- DAP commands
vim.keymap.set("n", "<leader>jdc", "<cmd>JavaTestDebugCurrentClass<CR>", { desc = "[Debug] Debug current class" })
vim.keymap.set("n", "<leader>jdm", "<cmd>JavaTestDebugCurrentMethod<CR>", { desc = "[Debug] Debug current method" })
vim.keymap.set("n", "<leader>jdo", "<cmd>lua require'dap'.step_over()<CR>", { desc = "[Debug] Step over" })
vim.keymap.set("n", "<leader>jdb", "<cmd>lua require'dap'.step_back()<CR>", { desc = "[Debug] Step back" })
vim.keymap.set("n", "<leader>jdg", "<cmd>lua require'dap'.continue()<CR>", { desc = "[Debug] Start/Continue debugging" })
vim.keymap.set("n", "<leader>jds", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "[Debug] Toggle breakpoint" })

-- Settings
vim.keymap.set("n", "<leader>js", "<cmd>JavaSettingsChangeRuntime<CR>", { desc = "Change SDK version" })

-- Tabs config
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")

vim.keymap.set("n", "<leader>1", "1gt")
vim.keymap.set("n", "<leader>2", "2gt")
vim.keymap.set("n", "<leader>3", "3gt")
vim.keymap.set("n", "<leader>4", "4gt")
vim.keymap.set("n", "<leader>5", "5gt")

-- Persistent files configuration ( .local/state/nvim/swap)
local state = vim.fn.stdpath("state")
vim.opt.directory = state .. "/swap//"
vim.opt.undodir   = state .. "/undo//"
vim.opt.backupdir = state .. "/backup//"
vim.opt.undofile  = true
