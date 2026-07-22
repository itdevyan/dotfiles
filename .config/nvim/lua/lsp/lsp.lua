return {
	-- Main LSP Configuration
	-- nvim-lspconfig provides server config data (lsp/ directory).
	-- On Neovim 0.11+, we use the native vim.lsp.config() + vim.lsp.enable() API.
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "ts_ls", "jsonls", "yamlls" },
				-- Automatically calls vim.lsp.enable() for installed servers.
				-- Servers start lazily when a matching filetype buffer is opened.
				automatic_enable = { "lua_ls", "ts_ls", "jsonls", "yamlls" },
			},
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			cmd = {
				"MasonToolsInstall",
				"MasonToolsInstallSync",
				"MasonToolsUpdate",
				"MasonToolsUpdateSync",
				"MasonToolsClean",
			},
			opts = {
				ensure_installed = {
					"stylua",
					"flake8",
					"prettierd",
					"prettier",
					"eslint",
					"google-java-format",
				},
				run_on_start = false,
			},
		},

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by blink.cmp
		-- NOTE: On 0.11+ with vim.lsp.config, blink.cmp auto-injects capabilities
		"saghen/blink.cmp",
	},
	config = function()
		local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = true })
		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event)
				for _, client in ipairs(vim.lsp.get_clients({ bufnr = event.buf })) do
					if client.id ~= event.data.client_id
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
						return
					end
				end

				vim.api.nvim_buf_call(event.buf, vim.lsp.buf.clear_references)
				vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event.buf })
				vim.b[event.buf].lsp_highlight_enabled = nil
			end,
		})

		-- LspAttach: keymaps and features that activate per-buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("[d", function()
					vim.diagnostic.jump({
						count = -1,
						on_jump = function(_, bufnr)
							vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
						end,
					})
				end, "Prev [D]iagnostic")
				map("]d", function()
					vim.diagnostic.jump({
						count = 1,
						on_jump = function(_, bufnr)
							vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
						end,
					})
				end, "Next [D]iagnostic")
				map("gn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
				map("gr", function()
					require("fzf-lua").lsp_references({ jump1 = false, ignore_current_line = true, unique_line_items = true })
				end, "[G]oto [R]eferences")
				map("gI", function()
					require("fzf-lua").lsp_implementations({ jump1 = false, ignore_current_line = true, includeDeclaration = false, unique_line_items = true })
				end, "[G]oto [I]mplementation")
				map("gd", function()
					require("fzf-lua").lsp_definitions({ jump1 = false, ignore_current_line = true, unique_line_items = true})
				end, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                				map("gp", function()
					local c = vim.lsp.get_clients({ bufnr = 0 })[1]
					if not c then return end
					local params = vim.lsp.util.make_position_params(0, c.offset_encoding)
					vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result)
						if not result or vim.tbl_isempty(result) then return end
						local loc = vim.islist(result) and result[1] or result
						local uri = loc.uri or loc.targetUri
						local range = loc.targetRange or loc.range
						if not uri or not range then return end
						local pbuf = vim.uri_to_bufnr(uri)
						vim.fn.bufload(pbuf)
						local lsp_end = range["end"] and range["end"].line or range.start.line
						local start_line, def_end = range.start.line, lsp_end
						local fn_types = {
							function_definition = true, function_declaration = true,
							method_declaration = true,  method_definition = true,
							method = true,              singleton_method = true,
							constructor_declaration = true, class_declaration = true,
							class_definition = true,    function_item = true,
							decorated_definition = true,
						}
						local var_types = {
							field_declaration = true,           local_variable_declaration = true,
							lexical_declaration = true,         variable_declaration = true,
							let_declaration = true,             const_item = true,
							static_item = true,                 var_declaration = true,
							const_declaration = true,           local_declaration = true,
							annotated_assignment = true,
						}
						local body_types = {
							block = true, statement_block = true, body_statement = true,
							compound_statement = true, function_body = true, do_block = true,
						}
						local ts_found = false
						pcall(function()
							local node = vim.treesitter.get_node({
								bufnr = pbuf,
								pos = { range.start.line, range.start.character or 0 },
							})
							while node do
								local t = node:type()
								if fn_types[t] or var_types[t] then
									local sr, _, er = node:range()
									local sig_end = er
									if fn_types[t] then
										for child in node:iter_children() do
											if body_types[child:type()] then
												local bs = child:range()
												local body_line = vim.api.nvim_buf_get_lines(pbuf, bs, bs + 1, false)[1] or ""
												sig_end = body_line:find("{", 1, true) and bs or math.max(sr, bs - 1)
												break
											end
										end
									end
									start_line, def_end = sr, sig_end
									ts_found = true
									return
								end
								node = node:parent()
							end
						end)
						if not ts_found and range.start.line >= lsp_end then
							local scan = vim.api.nvim_buf_get_lines(pbuf, range.start.line, range.start.line + 30, false)
							local depth, found_parens = 0, false
							for i, line in ipairs(scan) do
								for j = 1, #line do
									local ch = line:sub(j, j)
									if ch == "(" then depth = depth + 1; found_parens = true
									elseif ch == ")" then depth = depth - 1 end
								end
								if line:match("{") then def_end = range.start.line + i - 1; break end
								if found_parens and depth == 0 then def_end = range.start.line + i - 1; break end
							end
						end
						local lines = vim.api.nvim_buf_get_lines(pbuf, start_line, def_end + 1, false)
						local indent = math.huge
						for _, l in ipairs(lines) do
							if l:match("%S") then indent = math.min(indent, #(l:match("^%s*"))) end
						end
						indent = indent == math.huge and 0 or indent
						local sep = string.rep("〜", 21)
						local content = { sep, "" }
						for _, l in ipairs(lines) do
							table.insert(content, l:sub(indent + 1))
						end
						table.insert(content, "")
						table.insert(content, sep)
						vim.lsp.util.open_floating_preview(
							content,
							vim.bo[pbuf].filetype,
							{ border = "rounded", max_height = 45, max_width = 100 }
						)
					end)
				end, "[G]oto [P]eek Definition")
				map("gO", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")
				map("gW", require("fzf-lua").lsp_live_workspace_symbols, "Open Workspace Symbols")
				map("gt", function()
					require("fzf-lua").lsp_typedefs({ jump1 = false })
				end, "[G]oto [T]ype Definition")

				local client = vim.lsp.get_client_by_id(event.data.client_id)

				-- Document highlight on CursorHold
				if client
					and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					and not vim.b[event.buf].lsp_highlight_enabled then
					vim.b[event.buf].lsp_highlight_enabled = true
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
				end

				-- Inlay hints toggle
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
					map("<leader>lh", function()
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
                current_line = true,
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

        vim.lsp.config("ts_ls", {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
                javascript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "literals",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    },
                },
            },
        })

	end,
}
