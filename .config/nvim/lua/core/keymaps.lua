-- Keymaps ====================================================================

-- Toggle wrap
vim.keymap.set("n", "<leader>ww", function()
	vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

-- Delete and change to the beginning of the text
vim.keymap.set('n', 'dh', 'd^', { desc = "Delete backwards to the beginning of the text" })
vim.keymap.set('n', 'ch', 'c^', { desc = "Delete backwards to the beginning of the text and change" })

-- Finding selected text
vim.keymap.set("v", "//", 'y/<C-R>"<CR>', { desc = "Find selected text" })

-- Open finder
vim.keymap.set("n", "<leader>o", ":!open -R %<CR>", { desc = "Open Finder" })

-- Copy to clipboard
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

-- Paste from clipboard
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Cut to clipboard
vim.keymap.set("v", "<leader>x", '"+x', { desc = "Cut to clipboard" })

-- Escape commands
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("i", "kk", "<Esc>")

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Moving lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })

-- Indent with Tab
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Oil commands
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })

-- Diagnostics
vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in float" })

-- Format
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
vim.keymap.set("n", "<leader>jda", "<cmd>JavaTestRunAllTests<CR>", { desc = "[Debug] Debug all tests" })
vim.keymap.set("n", "<leader>jdc", "<cmd>JavaTestDebugCurrentClass<CR>", { desc = "[Debug] Debug current class" })
vim.keymap.set("n", "<leader>jdm", "<cmd>JavaTestDebugCurrentMethod<CR>", { desc = "[Debug] Debug current method" })
vim.keymap.set("n", "<leader>jdv", "<cmd>DapViewOpen<CR>", { desc = "[Debug] Open Dap View UI" })
vim.keymap.set("n", "<leader>jdV", "<cmd>DapViewClose<CR>", { desc = "[Debug] Close Dap View UI" })
vim.keymap.set("n", "<leader>jdt", "<cmd>DapTerminate<CR>", { desc = "[Debug] Terminate" })
vim.keymap.set("n", "<leader>jdo", function() require("dap").step_over() end, { desc = "[Debug] Step over" })
vim.keymap.set("n", "<leader>jdb", function() require("dap").step_back() end, { desc = "[Debug] Step back" })
vim.keymap.set("n", "<leader>jdg", function() require("dap").continue() end, { desc = "[Debug] Start/Continue debugging" })
vim.keymap.set("n", "<leader>jds", function() require("dap").toggle_breakpoint() end, { desc = "[Debug] Toggle breakpoint" })

-- Maven
local maven_opts = table.concat({
  "--add-opens jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.code=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.jvm=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED",
  "--add-opens jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED",
}, " ")

local lombok = "-Dlombok.version=1.18.30"
local function run_maven(args)
  local cmd
  if args == "clean" then
    cmd = "mvn clean"
  else
    cmd = string.format('MAVEN_OPTS="%s" mvn %s %s', maven_opts, args, lombok)
  end
  vim.cmd("botright split | terminal " .. cmd)
  vim.cmd("resize 15")
end

vim.keymap.set("n", "<leader>jmi", function() run_maven("install") end, { desc = "[Maven] Install" })
vim.keymap.set("n", "<leader>jmI", function() run_maven("install -DskipTests") end, { desc = "[Maven] Install without test" })
vim.keymap.set("n", "<leader>jmp", function() run_maven("package") end, { desc = "[Maven] Package" })
vim.keymap.set("n", "<leader>jmx", function() run_maven("clean") end, { desc = "[Maven] Clean" })
vim.keymap.set("n", "<leader>jmc", function() run_maven("compile") end, { desc = "[Maven] Compile" })

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

-- Snacks dashboard in vertical split
vim.keymap.set("n", "<leader>sv", function()
  vim.cmd("vnew")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  Snacks.dashboard.open({ win = win, buf = buf })
  vim.keymap.set("n", "q", "<cmd>bd<cr>", { silent = true, buffer = buf })
end, { desc = "Open dashboard in vertical split" })

-- Snacks dashboard in horizontal split
vim.keymap.set("n", "<leader>sh", function()
  vim.cmd("new")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  Snacks.dashboard.open({ win = win, buf = buf })
  vim.keymap.set("n", "q", "<cmd>bd<cr>", { silent = true, buffer = buf })
end, { desc = "Open dashboard in vertical split" })

vim.keymap.set("n", "<leader>sn", "<cmd>vnew<cr>", { desc = "New empty vertical split" })
vim.keymap.set("n", "<leader>sN", "<cmd>new<cr>", { desc = "New empty horizontal split" })

