return {
	"SmiteshP/nvim-navic",
	event = "LspAttach",
	config = function()
		require("nvim-navic").setup({
			lsp = {
				auto_attach = true,
				preference = { "jdtls", "spring-boot" },
			},
			highlight = true,
			depth_limit = 5,
		})
	end,
}
