-- Transparent lualine theme for colors/ghostty.lua: no section backgrounds, so Ghostty's
-- translucent background shows through. The mode is shown as colored bold text instead.
-- lualine re-reads this file on every ColorScheme change, so it follows light/dark switches.

local function fg(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  return hl.fg and string.format("#%06x", hl.fg) or nil
end

local text = fg("Normal")
local dim = fg("Comment")

local function mode(color)
  return {
    a = { fg = color, bg = "NONE", gui = "bold" },
    b = { fg = text, bg = "NONE" },
    c = { fg = dim, bg = "NONE" },
  }
end

return {
  normal = mode(fg("Function")),
  insert = mode(fg("String")),
  visual = mode(fg("Constant")),
  replace = mode(fg("Keyword")),
  command = mode(fg("Type")),
  terminal = mode(fg("Operator")),
  inactive = mode(dim),
}
