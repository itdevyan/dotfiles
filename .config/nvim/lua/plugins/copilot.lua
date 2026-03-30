return {
	"github/copilot.vim",
	lazy = false,
	init = function()
		vim.g.copilot_filetypes = { snacks_dashboard = false }
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<C-y>", 'copilot#Accept("")', {
			expr = true,
			replace_keycodes = false,
			desc = "Copilot Accept",
		})
	end,
}
