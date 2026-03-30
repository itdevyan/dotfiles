return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"rcasia/neotest-java",
        "nvim-neotest/neotest-jest",
	},
	config = function()
		-- Setup
		require("neotest").setup({
			adapters = {
				require("neotest-java")({
					junit_jar = nil,
				}),
                require("neotest-jest")({
                  jestCommand = "npm test --",
                  jestArguments = function(defaultArguments, context)
                    return defaultArguments
                  end,
                  jestConfigFile = "custom.jest.config.ts",
                  env = { CI = true },
                  cwd = function(path)
                    return vim.fn.getcwd()
                  end,
                  isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
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
}
