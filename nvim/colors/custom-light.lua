function set_hl(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

-- setup colors
if vim.g.colors_name then
  vim.cmd("hi clear")
end

vim.g.colors_name = "custom-light"

-- colors
local c = {
  none = "NONE",
  fg = "#d5ced9",
  fg_dark = "#a9b1d6",
  fg_gutter = "#c0caf5",
  bg = "#f5f5f5",
  bg_dark = "#c9d0d9",
  bg_highlight = "#f0f0f0",
  blue = "#0431fa",
  cyan = "#006F6C",
  purple = "#7a3e9d",
  orange = "#f39c12",
  yellow = "#EC9100",
  green = "#448c27",
  red = "#aa3731",
  gray = "#777777",
  comment = "#aaaaaa",
}

-- fg
set_hl("Text", { fg = c.fg })
set_hl("NonText", { fg = c.blue })
set_hl("Comment", { fg = c.comment, italic = true })
set_hl("Constant", { fg = c.green }) -- any constant
set_hl("String", { fg = c.green })
set_hl("Character", { fg = c.green })
set_hl("Number", { fg = "#9c5d27" })
set_hl("Statement", { fg = c.purple, italic = true }) -- any statement
set_hl("Keyword", { fg = "#4b69c6", italic = true }) -- any keyword
set_hl("Operator", { fg = c.gray }) -- "sizeof", "+", "*", etc.
set_hl("Type", { fg = c.purple }) -- int, long, char, etc.
set_hl("PreProc", { fg = "#4b69c6", italic = true }) -- int, long, char, etc.
set_hl("Delimiter", { fg = c.blue }) -- brackets, parens, etc.
set_hl("Special", { fg = c.blue }) -- any special symbol
set_hl("Function", { fg = c.red, bold = true })
set_hl("Identifier", { fg = c.purple }) -- variables
set_hl("@tag", { fg = c.purple }) -- html tag
set_hl("@tag.attribute", { fg = c.yellow, italic = true })
set_hl("LineNr", { fg = "#6d705b" }) -- line number
set_hl("CursorLineNr", { fg = "#9768dc" }) -- current line number
-- bg
set_hl("FloatBorder", { bg = c.none })
set_hl("NormalFloat", { bg = c.none })
set_hl("Pmenu", { bg = c.bg_dark })
set_hl("SignColumn", { bg = c.none })
set_hl("ColorColumn", { bg = c.bg_highlight })
set_hl("CursorLine", { bg = "#e4f6d4" })
set_hl("Visual", { bg = c.bg_dark })
set_hl("MatchParen", { bg = "#d3dcd3" })
-- Telescope
set_hl("TelescopeNormal", { bg = c.none })
set_hl("TelescopeBorder", { bg = c.none })
-- Cmp
set_hl("CmpItemAbbrMatch", { fg = c.orange })
set_hl("CmpItemAbbrMatchFuzzy", { fg = c.orange })
set_hl("markdownBoldItalic", { fg = c.orange, italic = true, bold = true })
-- Neo Tree
set_hl("Directory", { fg = c.purple })
set_hl("NeoTreeTitleBar", { bg = c.bg_dark })
