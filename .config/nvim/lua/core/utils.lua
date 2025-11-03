local M = {}

--- Returns true if the file is considered a big file,
--- according to the criteria defined in `vim.g.big_file`.
--- @param bufnr number|nil buffer number. 0 by default, which means current buf.
--- @return boolean is_big_file true or false.
function M.is_big_file(bufnr)
  if bufnr == nil then bufnr = 0 end
  local filesize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
  local nlines = vim.api.nvim_buf_line_count(bufnr)
  local is_big_file = (filesize > vim.g.big_file.size)
      or (nlines > vim.g.big_file.lines)
  return is_big_file
end


return M
