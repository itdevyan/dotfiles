return {
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-dap", -- for debugging (optional)
		},
	},
	-- nvim-java handles JDTLS setup separately
	{ "nvim-java/nvim-java" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-java")({
						junit_jar = nil,
					}),
				},
			})
			-- Keymaps
			vim.keymap.set("n", "<leader>tn", function()
				require("neotest").run.run()
			end, { desc = "Run nearest test" })

			vim.keymap.set("n", "<leader>tf", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, { desc = "Run current file" })

			vim.keymap.set("n", "<leader>ts", function()
				require("neotest").summary.toggle()
			end, { desc = "Toggle test summary" })

			vim.keymap.set("n", "<leader>to", function()
				require("neotest").output_panel.toggle()
			end, { desc = "Toggle output panel" })
		end,
	},
}
