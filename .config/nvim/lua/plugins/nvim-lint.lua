return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("lint").linters_by_ft = {
			lua = { "luacheck" },
			python = { "flake8" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			java = { "checkstyle" },
		}

		-- auto lint on save
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
