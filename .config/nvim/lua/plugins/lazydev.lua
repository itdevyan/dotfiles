-- lazydev.nvim: Fast LuaLS setup, replaces manual workspace.library config
-- Lazily indexes only the modules you actually require() in open files
return {
	"folke/lazydev.nvim",
	ft = "lua",
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
