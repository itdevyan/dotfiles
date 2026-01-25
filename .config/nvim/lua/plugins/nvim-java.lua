return {
	"nvim-java/nvim-java",
	config = function()
		require("java").setup()
		vim.lsp.config("jdtls", {
			settings = {
				java = {
					configuration = {
						runtimes = {
							{
								name = "JavaSE-25",
								path = "/Users/yan/Library/Java/JavaVirtualMachines/openjdk-25.0.1/Contents/Home",
							},
							{
								name = "JavaSE-21",
								path = "/Users/yan/Library/Java/JavaVirtualMachines/ms-21.0.9/Contents/Home",
								default = true,
							},
							{
								name = "JavaSE-17",
								path = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home",
							},
						},
					},
				},
			},
		})
		vim.lsp.enable("jdtls")
	end,
}
