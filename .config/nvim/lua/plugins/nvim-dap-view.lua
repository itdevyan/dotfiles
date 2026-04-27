-- Module-level state: buffer handle and last parsed test results
local test_buf = nil
local last_results = {}

local TestStatus = {
	Passed  = { icon = "✓", highlight = "DiagnosticOk" },
	Failed  = { icon = "✗", highlight = "DiagnosticError" },
	Skipped = { icon = "⚠", highlight = "DiagnosticWarn" },
	Unknown = { icon = "?", highlight = "DiagnosticHint" },
}

--- Recursively flatten the TestResults tree into a list of leaf (non-suite) nodes,
--- carrying the suite name as a prefix for display.
---@param nodes table
---@param suite_name string
---@param out table
local function collect_leaves(nodes, suite_name, out)
	if not nodes then
		return
	end
	for _, node in ipairs(nodes) do
		if node.is_suite then
			collect_leaves(node.children, node.display_name or node.test_name, out)
		else
			table.insert(out, { node = node, suite = suite_name })
		end
	end
end

--- Write test results into the dedicated buffer.
---@param results table java-test.TestResults[]
local function render_results(results)
	if not test_buf or not vim.api.nvim_buf_is_valid(test_buf) then
		return
	end

	local lines = {}
	local highlights = {} -- { line (0-indexed), col_start, col_end, hl_group }

	if not results or #results == 0 then
		lines = { "  No test results yet." }
	else
		local leaves = {}
		collect_leaves(results, "", leaves)

		for _, entry in ipairs(leaves) do
			local node   = entry.node
			local suite  = entry.suite
			local status = node.result and (node.result.status or TestStatus.Passed) or TestStatus.Unknown
			local icon   = status.icon
			local hl     = status.highlight

			local prefix = suite ~= "" and (suite .. " > ") or ""
			local line   = "  " .. icon .. "  " .. prefix .. (node.display_name or node.test_name)

			-- icon sits at col 2, highlight covers just the icon character
			table.insert(highlights, {
				line      = #lines,
				col_start = 2,
				col_end   = 2 + #icon,
				hl        = hl,
			})

			table.insert(lines, line)

			-- Append the first non-empty trace line on failure, indented
			if node.result and node.result.status == TestStatus.Failed and node.result.trace then
				for _, tline in ipairs(node.result.trace) do
					if tline ~= "" then
						table.insert(lines, "      " .. tline)
						break
					end
				end
			end
		end
	end

	vim.bo[test_buf].modifiable = true
	vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, lines)
	vim.bo[test_buf].modifiable = false

	-- Apply icon highlights via extmarks
	local ns = vim.api.nvim_create_namespace("dap_view_java_tests")
	vim.api.nvim_buf_clear_namespace(test_buf, ns, 0, -1)
	for _, h in ipairs(highlights) do
		vim.api.nvim_buf_set_extmark(test_buf, ns, h.line, h.col_start, {
			end_col  = h.col_end,
			hl_group = h.hl,
		})
	end
end

return {
	"igorlfs/nvim-dap-view",
	lazy = false,
	version = "1.*",
	---@module 'dap-view'
	---@type dapview.Config
	opts = {
		winbar = {
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "java_tests" },
			custom_sections = {
				java_tests = {
					label = "Tests",
					keymap = "J",
					-- Called when the user switches to this tab: re-renders current results
					action = function()
						render_results(last_results)
					end,
					-- Creates the dedicated scratch buffer once
					buffer = function()
						test_buf = vim.api.nvim_create_buf(false, true)
						vim.bo[test_buf].modifiable = false
						vim.bo[test_buf].buftype    = "nofile"
						vim.bo[test_buf].swapfile   = false
						vim.bo[test_buf].filetype   = "dap-view-tests"
						return test_buf
					end,
				},
			},
		},
	},
	config = function(_, opts)
		require("dap-view").setup(opts)

		-- Clear the buffer when a new DAP session starts so stale results
		-- from the previous run are not shown during the new one.
		require("dap").listeners.after.event_initialized["java_test_dap_view_clear"] = function()
			vim.schedule(function()
				last_results = {}
				render_results(last_results)
			end)
		end

		-- Hook into DAP session termination.
		-- By the time event_terminated fires the TCP stream from jdtls is already
		-- closed and all test results have been parsed into last_report.
		require("dap").listeners.after.event_terminated["java_test_dap_view"] = function()
			vim.schedule(function()
				local ok, java_test = pcall(require, "java-test")
				if ok and java_test.last_report then
					last_results = java_test.last_report:get_results() or {}
					render_results(last_results)
				end
			end)
		end
	end,
}
