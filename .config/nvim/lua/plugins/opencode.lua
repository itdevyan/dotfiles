return {
	"NickvanDyke/opencode.nvim",
	version = "*", -- Latest stable release
	dependencies = {
		-- Recommended for `ask()` and `select()`.
		---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
		{
			"folke/snacks.nvim",
			optional = true,
			opts = {
				input = {}, -- Enhances `ask()`
				picker = { -- Enhances `select()`
					actions = {
						opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
				terminal = {},
			},
		},
	},
	config = function()
		---@type opencode.Opts
		vim.g.opencode_opts = {
			lsp = {
				enabled = false, -- Set to true to try the experimental LSP feature
				filetypes = {
					"lua",
					"java",
					"javascript",
					"typescript",
					"javascriptreact",
					"typescriptreact",
					"python",
					"go",
					"rust",
					"c",
					"cpp",
					"markdown",
					"yaml",
					"json",
					"toml",
					"xml",
					"html",
					"css",
					"scss",
					"sh",
					"bash",
					"zsh",
					"dockerfile",
					"sql",
				},
			},
		}

		-- Required for `opts.events.reload`.
		vim.o.autoread = true

		-- Recommended/example keymaps.
		vim.keymap.set({ "n", "x" }, "<C-o>", function()
			require("opencode").ask("@this: ", { submit = true })
		end, { desc = "Ask opencode" })
		vim.keymap.set({ "n", "x" }, "<C-x>", function()
			require("opencode").select()
		end, { desc = "Execute opencode action…" })
		vim.keymap.set({ "n", "t" }, "<C-.>", function()
			require("opencode").toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return require("opencode").operator("@this ")
		end, { expr = true, desc = "Add range to opencode" })
		vim.keymap.set("n", "goo", function()
			return require("opencode").operator("@this ") .. "_"
		end, { expr = true, desc = "Add line to opencode" })

		vim.keymap.set("n", "<S-C-u>", function()
			require("opencode").command("session.half.page.up")
		end, { desc = "opencode half page up" })
		vim.keymap.set("n", "<S-C-d>", function()
			require("opencode").command("session.half.page.down")
		end, { desc = "opencode half page down" })

		-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
		--vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
		--vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
	end,
}
