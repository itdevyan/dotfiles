-- Toggle wrap
vim.keymap.set("n", "<leader>ww", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

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

vim.keymap.set("n", "<leader>cf", function()
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
