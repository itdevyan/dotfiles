return {
	"lewis6991/gitsigns.nvim", -- plugin repo
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "▌" },
				change = { text = "▌" },
				delete = { text = "▌" },
				topdelete = { text = "▌" },
				changedelete = { text = "▌" },
				untracked = { text = "▌" },
			},
			signs_staged = {
				add = { text = "▌" },
				change = { text = "▌" },
				delete = { text = "▌" },
				topdelete = { text = "▌" },
				changedelete = { text = "▌" },
				untracked = { text = "▌" },
			},
			signs_staged_enable = true,
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = false,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
				use_focus = true,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Next git hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Previous git hunk" })

				-- Hunk Actions
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

				map("v", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk (visual)" })

				map("v", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk (visual)" })

				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

				map("n", "<leader>hb", function()
					gitsigns.blame_line({ full = true })
				end, { desc = "Blame line" })

				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })

				map("n", "<leader>hD", function()
					gitsigns.diffthis("~")
				end, { desc = "Diff this vs. previous" })

				map("n", "<leader>hQ", function()
					gitsigns.setqflist("all")
				end, { desc = "Set qflist (all)" })
				map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set qflist (buffer)" })

				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle current line blame" })
				map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

				-- Text object
				map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select git hunk" })
			end,
		})
		local c = {
			add    = "#a6e3a1",
			change = "#89b4fa",
			delete = "#f38ba8",
			add_staged    = "#74c99e",
			change_staged = "#6a9fd8",
			delete_staged = "#e0788a",
		}
		local function gs_hl(name, fg)
			vim.api.nvim_set_hl(0, name, { fg = fg, bg = "NONE" })
		end

		gs_hl("GitSignsAdd",           c.add)
		gs_hl("GitSignsAddNr",         c.add)
		gs_hl("GitSignsAddPreview",    c.add)
		gs_hl("GitSignsChange",        c.change)
		gs_hl("GitSignsChangeNr",      c.change)
		gs_hl("GitSignsDelete",        c.delete)
		gs_hl("GitSignsDeleteNr",      c.delete)
		gs_hl("GitSignsDeletePreview", c.delete)
		gs_hl("GitSignsTopDelete",     c.delete)
		gs_hl("GitSignsTopDeleteNr",   c.delete)
		gs_hl("GitSignsChangeDelete",  c.change)
		gs_hl("GitSignsChangeDeleteNr",c.change)
		gs_hl("GitSignsUntracked",     c.add)
		gs_hl("GitSignsUntrackedNr",   c.add)

		gs_hl("GitSignsStagedAdd",           c.add_staged)
		gs_hl("GitSignsStagedAddNr",         c.add_staged)
		gs_hl("GitSignsStagedChange",        c.change_staged)
		gs_hl("GitSignsStagedChangeNr",      c.change_staged)
		gs_hl("GitSignsStagedDelete",        c.delete_staged)
		gs_hl("GitSignsStagedDeleteNr",      c.delete_staged)
		gs_hl("GitSignsStagedTopDelete",     c.delete_staged)
		gs_hl("GitSignsStagedTopDeleteNr",   c.delete_staged)
		gs_hl("GitSignsStagedChangeDelete",  c.change_staged)
		gs_hl("GitSignsStagedChangeDeleteNr",c.change_staged)
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
	end,
}
