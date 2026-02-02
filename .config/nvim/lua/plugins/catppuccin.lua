return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		transparent_background = true,
		float = {
			transparent = true,
			solid = true,
		},
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			functions = { "italic", "underline" },
			--keywords = { "bold" },
			--properties = { "bold" },
			--types = { "bold" },
		},
		lsp_styles = {
			inlay_hints = {
				background = false,
			},
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
