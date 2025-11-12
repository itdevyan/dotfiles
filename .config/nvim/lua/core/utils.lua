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

--- Get an icon from given its icon name.
--- if vim.g.fallback_icons_enabled = true, it will return a fallback icon
--- unless specified otherwise.
--- @param icon_name string Name of the icon to retrieve.
--- @param fallback_to_empty_string boolean|nil If this parameter is true, when `vim.g.fallback_icons_enabled = true` then `get_icon()` will return empty string.
--- @return string icon.
function M.get_icon(icon_name, fallback_to_empty_string)
  -- guard clause
  if fallback_to_empty_string and vim.g.fallback_icons_enabled then return "" end

  -- get icon_pack
  local icon_pack = (vim.g.fallback_icons_enabled and "fallback_icons") or "icons"

  -- cache icon_pack into M
  if not M[icon_pack] then -- only if not cached already.
    if icon_pack == "icons" then
      M.icons = require("core.icons.icons")
    elseif icon_pack =="fallback_icons" then
      M.fallback_icons = require("core.icons.fallback_icons")
    end
  end

  -- return specified icon
  local icon = M[icon_pack] and M[icon_pack][icon_name]
  return icon
end

--- Get the options of a plugin managed by lazy.
--- @param plugin string The plugin to get options from
--- @return table opts # The plugin options, or empty table if no plugin.
function M.get_plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.icons")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugins")
  local opts = {}
  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then opts = lazy_plugin.values(spec, "opts") end
  end
  return opts
end

return M
