return {
	"b0o/incline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local helpers = require("incline.helpers")
		local devicons = require("nvim-web-devicons")

		require("incline").setup({
			window = {
				padding = 0,
				margin = { horizontal = 0, vertical = 0 },
			},
			render = function(props)
				local function get_project_name()
					local ok, project_nvim = pcall(require, "project_nvim.project")
					if not ok then
						return nil
					end
					local root = project_nvim.get_project_root()
					if not root or root == "" then
						return nil
					end
					return vim.fn.fnamemodify(root, ":t")
				end
				local full = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(full, ":t")
				local parent = vim.fn.fnamemodify(full, ":h:t")
				local textToShow = (parent ~= "" and (parent .. "/") or "") .. filename
				if textToShow == "" then
					textToShow = "[No Name]"
				end
				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local modified = vim.bo[props.buf].modified
				return {
					ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
					" ",
					{ get_project_name(), gui = "bold" },
					"  ",
					{ textToShow, gui = modified and "italic" or "" },
					guibg = "#1e1e2e",
				}
			end,
		})
	end,
	-- Optional: Lazy load Incline
	event = "VeryLazy",
}
