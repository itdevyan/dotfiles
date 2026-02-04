return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		background = {
			light = "latte",
			dark = "mocha",
		},
		default_integrations = true,
		auto_integrations = true,
		transparent_background = true,
		float = {
			transparent = true,
			solid = true,
		},
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = { "italic" },
			functions = { "bold" },
			keywords = { "italic" },
			operators = { "bold" },
			conditionals = { "bold" },
			loops = { "bold" },
			booleans = { "bold", "italic" },
			numbers = {},
			types = {},
			strings = {},
			variables = {},
			properties = {},
		},
		lsp_styles = {
			inlay_hints = {
				background = true,
			},
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
