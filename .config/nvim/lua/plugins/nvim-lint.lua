return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters.checkstyle = {
			cmd = "/opt/homebrew/bin/checkstyle", -- El comando instalado en tu sistema
			stdin = false, -- Checkstyle funciona mejor leyendo archivos, no stdin
			append_fname = true, -- nvim-lint agregará el nombre del archivo al final del comando
			args = {
				"-c",
				vim.fn.expand("~/.config/checkstyle/google_checks.xml"), -- Expande la ruta con ~
				"-f",
				"plain", -- Forzamos salida plana para facilitar el parseo
			},
			stream = "stdout", -- Checkstyle suele imprimir los errores en stdout
			ignore_exitcode = false, -- Checkstyle devuelve código de salida != 0 si hay errores
			parser = require("lint.parser").from_pattern(
				-- Regex para capturar: [SEVERITY] file:line:col: message
				-- Ejemplo salida: [WARN] /ruta/File.java:10:5: Falta Javadoc.
				[[^%[(%w+)%]%s+.-:(%d+):(%d+):%s+(.*)$]],
				{ "severity", "lnum", "col", "message" }, -- Grupos de captura
				{
					-- Mapa de severidad
					["INFO"] = vim.diagnostic.severity.INFO,
					["WARN"] = vim.diagnostic.severity.WARN,
					["ERROR"] = vim.diagnostic.severity.ERROR,
				},
				{
					source = "checkstyle",
				}
			),
		}

		lint.linters_by_ft = {
			lua = { "luacheck" },
			python = { "flake8" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			java = { "checkstyle" },
		}

		-- auto lint on save
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
