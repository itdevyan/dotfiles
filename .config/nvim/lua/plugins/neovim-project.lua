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
