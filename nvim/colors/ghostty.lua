-- Colorscheme that inherits the terminal's current theme: it asks the terminal for its colors
-- (see lua/terminal_colors.lua), builds syntax colors from the 16-color palette, and leaves the
-- background transparent so the terminal shows through. Asking the terminal instead of reading
-- Ghostty's config means this also works over SSH. Neovim re-sources the colorscheme whenever
-- 'background' changes, so this also follows Ghostty's light:/dark: theme pair.

local terminal = require("terminal_colors")

local function rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

-- `amount` of b blended into a
local function mix(a, b, amount)
  local r1, g1, b1 = rgb(a)
  local r2, g2, b2 = rgb(b)
  local function blend(x, y)
    return math.floor(x + (y - x) * amount + 0.5)
  end
  return string.format("#%02x%02x%02x", blend(r1, r2), blend(g1, g2), blend(b1, b2))
end

local function luminance(hex)
  local function channel(c)
    c = c / 255
    return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  local r, g, b = rgb(hex)
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

local function contrast(a, b)
  local la, lb = luminance(a), luminance(b)
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05)
end

-- Pushes `color` toward the foreground until it is readable on the background, keeping its hue
-- as much as possible (some terminal palettes have accents that vanish on their own background).
local function readable(color, bg, fg, minimum)
  local result = color
  local step = 0
  while contrast(result, bg) < minimum and step < 10 do
    step = step + 1
    result = mix(color, fg, step / 10)
  end
  return result
end

-- Apply the cached colors right away, then ask the terminal and re-apply if they changed
local ghostty = terminal.cached()
terminal.applied = ghostty
terminal.query(function()
  vim.cmd.colorscheme("ghostty")
end)

vim.cmd("highlight clear")
vim.g.colors_name = "ghostty"
if not ghostty then
  -- Nothing cached yet: keep Neovim's default colors until the terminal answers
  return
end
local p = ghostty.palette

local bg = ghostty.background
local fg = ghostty.foreground
local function accent(index, minimum)
  return readable(p[index] or fg, bg, fg, minimum or 3.5)
end

local c = {
  red = accent(1),
  green = accent(2),
  yellow = accent(3),
  blue = accent(4),
  magenta = accent(5),
  cyan = accent(6),
  bright_red = accent(9),
  bright_blue = accent(12),
  bright_magenta = accent(13),
  bright_cyan = accent(14),
  comment = accent(8, 3),
  dim = mix(bg, fg, 0.45),
  -- Solid surfaces for the few places that need one (menus, cursor line, selection)
  surface1 = mix(bg, fg, 0.06),
  surface2 = mix(bg, fg, 0.12),
  selection = mix(bg, fg, 0.2),
}

for i = 0, 15 do
  if p[i] then
    vim.g["terminal_color_" .. i] = p[i]
  end
end

local function tint(color)
  return mix(bg, color, 0.2)
end

local groups = {
  -- Editor (transparent wherever the terminal background should show)
  Normal = { fg = fg },
  NormalNC = { fg = fg },
  NormalFloat = { fg = fg },
  FloatBorder = { fg = c.dim },
  FloatTitle = { fg = c.blue, bold = true },
  SignColumn = {},
  FoldColumn = { fg = c.comment },
  Folded = { fg = c.comment, bg = c.surface1 },
  EndOfBuffer = { fg = bg },
  LineNr = { fg = c.comment },
  CursorLineNr = { fg = c.yellow, bold = true },
  CursorLine = { bg = c.surface1 },
  CursorColumn = { bg = c.surface1 },
  ColorColumn = { bg = c.surface1 },
  Cursor = { fg = bg, bg = fg },
  Visual = { bg = c.selection },
  VisualNOS = { bg = c.selection },
  Search = { fg = bg, bg = c.yellow },
  IncSearch = { fg = bg, bg = c.red },
  CurSearch = { fg = bg, bg = c.red },
  Substitute = { fg = bg, bg = c.red },
  MatchParen = { bg = c.surface2, bold = true },
  WinSeparator = { fg = c.surface2 },
  VertSplit = { link = "WinSeparator" },
  StatusLine = { fg = fg },
  StatusLineNC = { fg = c.comment },
  TabLine = { fg = c.comment },
  TabLineFill = {},
  TabLineSel = { fg = fg, bold = true },
  WinBar = { fg = fg },
  WinBarNC = { fg = c.comment },
  Pmenu = { fg = fg, bg = c.surface1 },
  PmenuSel = { bg = c.selection, bold = true },
  PmenuSbar = { bg = c.surface1 },
  PmenuThumb = { bg = c.selection },
  PmenuKind = { fg = c.blue, bg = c.surface1 },
  PmenuExtra = { fg = c.comment, bg = c.surface1 },
  NonText = { fg = c.surface2 },
  Whitespace = { fg = c.surface2 },
  SpecialKey = { fg = c.surface2 },
  Conceal = { fg = c.comment },
  Directory = { fg = c.blue },
  Title = { fg = c.blue, bold = true },
  Question = { fg = c.green },
  MoreMsg = { fg = c.green },
  ModeMsg = { fg = fg, bold = true },
  ErrorMsg = { fg = c.red },
  WarningMsg = { fg = c.yellow },
  WildMenu = { link = "PmenuSel" },
  QuickFixLine = { bg = c.surface2 },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.cyan, undercurl = true },
  SpellRare = { sp = c.magenta, undercurl = true },

  -- Syntax
  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.magenta },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.magenta },
  Boolean = { fg = c.magenta },
  Float = { fg = c.magenta },
  Identifier = { fg = fg },
  Function = { fg = c.blue },
  Statement = { fg = c.red },
  Conditional = { fg = c.red },
  Repeat = { fg = c.red },
  Label = { fg = c.red },
  Operator = { fg = c.cyan },
  Keyword = { fg = c.red },
  Exception = { fg = c.red },
  PreProc = { fg = c.bright_magenta },
  Include = { fg = c.bright_magenta },
  Define = { fg = c.bright_magenta },
  Macro = { fg = c.bright_magenta },
  Type = { fg = c.yellow },
  StorageClass = { fg = c.red },
  Structure = { fg = c.yellow },
  Typedef = { fg = c.yellow },
  Special = { fg = c.cyan },
  SpecialChar = { fg = c.cyan },
  Tag = { fg = c.blue },
  Delimiter = { fg = c.dim },
  SpecialComment = { fg = c.comment, bold = true },
  Debug = { fg = c.red },
  Underlined = { underline = true },
  Error = { fg = c.red },
  Todo = { fg = bg, bg = c.yellow, bold = true },

  -- Treesitter (most captures already link to the groups above)
  ["@variable"] = { fg = fg },
  ["@variable.builtin"] = { fg = c.bright_red, italic = true },
  ["@variable.parameter"] = { fg = fg, italic = true },
  ["@variable.member"] = { fg = c.bright_blue },
  ["@property"] = { fg = c.bright_blue },
  ["@module"] = { fg = c.yellow },
  ["@constructor"] = { fg = c.yellow },
  ["@function.builtin"] = { fg = c.bright_cyan },
  ["@keyword.return"] = { fg = c.red, italic = true },
  ["@string.escape"] = { fg = c.cyan },
  ["@string.special.url"] = { fg = c.blue, underline = true },
  ["@punctuation"] = { fg = c.dim },
  ["@tag"] = { fg = c.red },
  ["@tag.attribute"] = { fg = c.yellow },
  ["@tag.delimiter"] = { fg = c.dim },
  ["@markup.heading"] = { fg = c.blue, bold = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.link"] = { fg = c.blue, underline = true },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.list"] = { fg = c.red },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.property"] = { link = "@property" },

  -- Diagnostics
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.cyan },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.cyan, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = tint(c.red) },
  DiagnosticVirtualTextWarn = { fg = c.yellow, bg = tint(c.yellow) },
  DiagnosticVirtualTextInfo = { fg = c.blue, bg = tint(c.blue) },
  DiagnosticVirtualTextHint = { fg = c.cyan, bg = tint(c.cyan) },
  LspInlayHint = { fg = c.comment, bg = c.surface1, italic = true },
  LspReferenceText = { bg = c.surface2 },
  LspReferenceRead = { bg = c.surface2 },
  LspReferenceWrite = { bg = c.surface2 },

  -- Diff and git
  DiffAdd = { bg = tint(c.green) },
  DiffChange = { bg = tint(c.blue) },
  DiffDelete = { bg = tint(c.red) },
  DiffText = { bg = mix(bg, c.blue, 0.35) },
  Added = { fg = c.green },
  Changed = { fg = c.yellow },
  Removed = { fg = c.red },
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.yellow },
  GitSignsDelete = { fg = c.red },

  -- Plugins
  FlashLabel = { fg = bg, bg = c.magenta, bold = true },
  FlashMatch = { fg = c.blue, underline = true },
  FlashCurrent = { fg = c.yellow, underline = true },
  SnacksIndent = { fg = c.surface2 },
  SnacksIndentScope = { fg = c.dim },
  MiniIndentscopeSymbol = { fg = c.dim },
  WhichKey = { fg = c.cyan },
  WhichKeyGroup = { fg = c.blue },
  WhichKeyDesc = { fg = fg },
  WhichKeySeparator = { fg = c.comment },
  BlinkCmpMenuBorder = { link = "FloatBorder" },
  BlinkCmpLabelMatch = { fg = c.blue, bold = true },
  TreesitterContext = { bg = c.surface1 },
}

for name, spec in pairs(groups) do
  vim.api.nvim_set_hl(0, name, spec)
end
