return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		color_overrides = {
			mocha = {
				blue = "#b4ccff",
				green = "#c7ffc4",
				lavender = "#d5dcff",
				mauve = "#e4c7ff",
				text = "#f0f3ff",
				peach = "#ffd0aa",
				pink = "#ffd7f5",
				red = "#ffb0c6",
				sky = "#b4f2ff",
				subtext1 = "#d3d8f4",
				subtext0 = "#c0c6e8",
				teal = "#b9fff3",
				yellow = "#fff4c8",
				overlay2 = "#a7aec8",
				overlay1 = "#929ab8",
				overlay0 = "#7c849f",
			},
		},
		custom_highlights = function(colors)
			return {
				LineNr = { fg = colors.overlay1 },
			}
		end,
		default_integrations = true,
		auto_integrations = true,
		transparent_background = true,
		float = {
		    transparent = false,
		    solid = false,
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
