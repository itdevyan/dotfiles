-- Conform.nvim configuration file
-- This file sets up the Conform.nvim plugin with specific formatters for different file types
return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "isort", "black" },
			java = { "google_java_format" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
		},
		-- Enable automatic formatting on save
		--format_on_save = {
		--timeout_ms = 500,
		--lsp_fallback = true, -- Use LSP formatting if no formatter is found
		--},
	},
}
