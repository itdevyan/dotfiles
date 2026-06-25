return {
	url = "https://codeberg.org/andyg/leap.nvim",
	event = "VeryLazy",
	config = function()
		-- Core mappings (recommended by author)
		-- 's' forward leap, 'S' leap across windows
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
		vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap: from window" })

		-- Remote operations: operate on distant text without moving cursor
		-- e.g. `gs{leap}yap` yanks paragraph at target and pastes it here
		vim.keymap.set({ "n", "o" }, "gs", "<Plug>(leap-remote)", { desc = "Leap: remote op" })
		vim.keymap.set({ "n", "o" }, "gS", "<Plug>(leap-remote-linewise)", { desc = "Leap: remote linewise" })

		-- Preview filter: skip preview for mid-word alphabetic runs and whitespace
		-- reduces visual noise / blinking after first keypress
		require("leap").opts.preview = function(ch0, ch1, ch2)
			return not (
				ch1:match("%s")
				or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a"))
			)
		end

		-- Auto-paste after remote yank (clone text from anywhere in one move)
		vim.api.nvim_create_autocmd("User", {
			pattern = "RemoteOperationDone",
			group = vim.api.nvim_create_augroup("LeapRemote", {}),
			callback = function(event)
				if vim.v.operator == "y" and event.data.register == '"' then
					vim.cmd("normal! p")
				end
			end,
		})
	end,
}
