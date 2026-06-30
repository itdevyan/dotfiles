return {
	"coffebar/neovim-project",
	opts = {
		projects = {
			"~/Projects/Kakebook/backend/*",
			"~/Projects/Kakebook/mobile/*",
			"~/.config/*",
		},
		picker = {
			type = "fzf-lua",
		},
        last_session_on_startup = false,
        autochdir = true,
	},
	init = function()
		-- enable saving the state of plugins in the session
		vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
		vim.keymap.set("n", "<leader>fp", ":NeovimProjectHistory<CR>", { silent = true, desc = "[P]roject history" })
		local function yank(value)
			vim.fn.setreg("+", value)
			vim.notify("Copied: " .. value)
		end
		vim.keymap.set("n", "<leader>fyp", function() yank(vim.fn.fnamemodify(vim.fn.getcwd(), ":t")) end, { silent = true, desc = "[Y]ank project name" })
		vim.keymap.set("n", "<leader>fyP", function() yank(vim.fn.getcwd()) end, { silent = true, desc = "[Y]ank absolute project path" })
		vim.keymap.set("n", "<leader>fyf", function() yank(vim.fn.expand("%:t")) end, { silent = true, desc = "[Y]ank file name" })
		vim.keymap.set("n", "<leader>fyF", function() yank(vim.fn.expand("%:p")) end, { silent = true, desc = "[Y]ank absolute file path" })
		vim.keymap.set("n", "<leader>fyr", function()
			local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
			yank(vim.fn.expand("%:p"):sub(#git_root + 2))
		end, { silent = true, desc = "[Y]ank path from repo root" })
		vim.keymap.set("n", "<leader>fyc", function() yank(vim.fn.expand("%:.")) end, { silent = true, desc = "[Y]ank path from content root" })
		vim.keymap.set("n", "<leader>fq", function()
			local history = require("neovim-project.utils.history")
			local path = require("neovim-project.utils.path")
			local cwd = path.short_path(vim.fn.getcwd())
			history.make_sure_read_projects_from_history()
			history.delete_project(cwd)
			history.write_projects_to_history()
			require("session_manager").delete_current_dir_session()
			vim.cmd("qa")
		end, { silent = true, desc = "[P]roject close (delete session + history)" })
	end,
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "ibhagwan/fzf-lua" },
		{ "Shatur/neovim-session-manager" },
	},
	lazy = false,
	priority = 100,
}
