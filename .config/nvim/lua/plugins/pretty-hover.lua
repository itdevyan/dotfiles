return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {},
	config = function(_, opts)
		require("pretty_hover").setup(opts)

		vim.keymap.set("n", "K", function()
			require("pretty_hover").hover()
		end, { desc = "LSP hover (pretty)" })
	end,
}
