return {
	"github/copilot.vim",
	lazy = false,
	init = function()
		vim.g.copilot_filetypes = { snacks_dashboard = false }
		vim.g.copilot_no_tab_map = true
	end,
}
