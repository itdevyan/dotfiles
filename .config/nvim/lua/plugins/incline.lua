return {
	"b0o/incline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")

		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = { top = 1, bottom = 1 } },
			placement = { horizontal = "left", vertical = "top" },
			},
			render = function(props)
				local function get_project_name()
					local cwd = vim.loop.cwd()
					if not cwd or cwd == "" then
						return nil
					end
					return vim.fn.fnamemodify(cwd, ":t")
				end
				local full = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(full, ":t")
				local parent = vim.fn.fnamemodify(full, ":h:t")
				local textToShow = (parent ~= "" and (parent .. "/") or "") .. filename
				if textToShow == "" then
					textToShow = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)
                local bg_peach = "#ffe5b4"
                local ft_peach = "#000000"
				local modified = vim.bo[props.buf].modified
				return {
					ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
					{ get_project_name(), gui = "bold", guibg = ft_color, guifg = ft_color and helpers.contrast_color(ft_color) or nil },
					{ " ", gui = "bold", guibg = ft_color, guifg = ft_color and helpers.contrast_color(ft_color) or nil },
					{ "", guifg = ft_color, guibg = bg_peach },
                    { " ", guibg = bg_peach },
					{ textToShow, guifg = ft_peach, gui = modified and "italic" or "" },
                    { " ", guibg = bg_peach },
					{ "", guifg = bg_peach, guibg = ft_peach },
					guibg = bg_peach,
				}
			end,
		})
	end,
	-- Optional: Lazy load Incline
	event = "VeryLazy",
}
