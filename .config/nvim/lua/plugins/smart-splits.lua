return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	opts = {
		default_amount = 5,
		at_edge = "wrap",
		multiplexer_integration = "tmux",
	},
	config = function(_, opts)
		require("smart-splits").setup(opts)
		vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left, { desc = "Resize split left" })
		vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down, { desc = "Resize split down" })
		vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up, { desc = "Resize split up" })
		vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right, { desc = "Resize split right" })
	end,
}
