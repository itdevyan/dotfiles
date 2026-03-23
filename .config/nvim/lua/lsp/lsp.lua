return {
	-- Main LSP Configuration
	-- nvim-lspconfig provides server config data (lsp/ directory).
	-- On Neovim 0.11+, we use the native vim.lsp.config() + vim.lsp.enable() API.
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "ts_ls" },
				-- Automatically calls vim.lsp.enable() for installed servers.
				-- Servers start lazily when a matching filetype buffer is opened.
				automatic_enable = {
					exclude = { "jdtls" }, -- nvim-java handles jdtls
				},
			},
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		-- NOTE: On 0.11+ with vim.lsp.config, blink.cmp auto-injects capabilities
		"saghen/blink.cmp",
	},
	config = function()
		-- LspAttach: keymaps and features that activate per-buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev [D]iagnostic")
				map("]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next [D]iagnostic")
				map("gn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("gr", function()
					require("fzf-lua").lsp_references({ jump1 = false })
				end, "[G]oto [R]eferences")
				map("gi", function()
					require("fzf-lua").lsp_implementations({ jump1 = false })
				end, "[G]oto [I]mplementation")
				map("gd", function()
					require("fzf-lua").lsp_definitions({ jump1 = false })
				end, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gO", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")
				map("gt", function()
					require("fzf-lua").lsp_typedefs({ jump1 = false })
				end, "[G]oto [T]ype Definition")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Document highlight on CursorHold
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = false }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Inlay hints toggle
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>ch", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "Toggle Inlay [H]ints")
				end
			end,
		})

		-- Diagnostic Config (single source of truth)
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
			},
		})

		-- Server-specific config via native API (vim.lsp.config)
		-- lazydev.nvim handles workspace/library for Lua, so we keep lua_ls config minimal
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					completion = { callSnippet = "Replace" },
					telemetry = { enable = false },
				},
			},
		})

		-- Ensure tools are installed (formatters, linters, etc.)
		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"black",
				"isort",
				"flake8",
				"prettierd",
				"prettier",
				"eslint",
				"google-java-format",
			},
		})
	end,
}
