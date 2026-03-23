return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup()
		-- REQUIRED

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
			vim.notify("Harpoon: added " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
		end, { desc = "Harpoon: add file to list" })
		vim.keymap.set("n", "<leader>e", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: toggle quick menu" })

		vim.keymap.set("n", "<C-1>", function()
			harpoon:list():select(1)
		end, { desc = "Harpoon: jump to file 1" })
		vim.keymap.set("n", "<C-2>", function()
			harpoon:list():select(2)
		end, { desc = "Harpoon: jump to file 2" })
		vim.keymap.set("n", "<C-3>", function()
			harpoon:list():select(3)
		end, { desc = "Harpoon: jump to file 3" })
		vim.keymap.set("n", "<C-4>", function()
			harpoon:list():select(4)
		end, { desc = "Harpoon: jump to file 4" })
		vim.keymap.set("n", "<C-5>", function()
			harpoon:list():select(5)
		end, { desc = "Harpoon: jump to file 5" })
		vim.keymap.set("n", "<C-6>", function()
			harpoon:list():select(6)
		end, { desc = "Harpoon: jump to file 6" })
		vim.keymap.set("n", "<C-7>", function()
			harpoon:list():select(7)
		end, { desc = "Harpoon: jump to file 7" })
		vim.keymap.set("n", "<C-8>", function()
			harpoon:list():select(8)
		end, { desc = "Harpoon: jump to file 8" })
		vim.keymap.set("n", "<C-9>", function()
			harpoon:list():select(9)
		end, { desc = "Harpoon: jump to file 9" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: jump to previous file" })
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: jump to next file" })
	end,
}
