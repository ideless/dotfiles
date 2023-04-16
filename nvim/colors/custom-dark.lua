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
  bg = "#23262e",
  bg1 = "#2e323d",
  bg2 = "#3d4352",
  bg3 = "#746f77",
  blue = "#0431fa",
  cyan = "#00e8c6",
  purple = "#da70d6",
  orange = "#ffd700",
  yellow = "#ffe66d",
  green = "#96e072",
  red = "#ee4d43",
  gray = "#777777",
  comment = "#898b92",
}

-- fg
set_hl("Text", { fg = c.fg })
set_hl("NonText", { fg = c.gray })
set_hl("Comment", { fg = c.comment, italic = true })
set_hl("Constant", { fg = c.green }) -- any constant
set_hl("String", { fg = c.green })
set_hl("Character", { fg = c.green })
set_hl("Number", { fg = "#f39c12" })
set_hl("Statement", { fg = c.purple, italic = true }) -- any statement
set_hl("Keyword", { fg = c.purple, italic = true }) -- any keyword
set_hl("Operator", { fg = c.red }) -- "sizeof", "+", "*", etc.
set_hl("Type", { fg = c.purple }) -- int, long, char, etc.
set_hl("PreProc", { fg = c.purple, italic = true }) -- int, long, char, etc.
set_hl("Delimiter", { fg = c.orange }) -- brackets, parens, etc.
set_hl("Special", { fg = c.purple }) -- any special symbol
set_hl("Function", { fg = c.yellow, bold = true })
set_hl("Identifier", { fg = c.cyan }) -- variables
set_hl("@tag", { fg = c.purple }) -- html tag
set_hl("@tag.attribute", { fg = c.yellow, italic = true })
set_hl("LineNr", { fg = "#746f77" }) -- line number
set_hl("CursorLineNr", { fg = "#c6c6c6" }) -- current line number
-- bg
set_hl("FloatBorder", { bg = c.none })
set_hl("NormalFloat", { bg = c.none })
set_hl("Pmenu", { bg = c.bg2 })
set_hl("SignColumn", { bg = c.none })
set_hl("ColorColumn", { bg = c.bg1 })
set_hl("CursorLine", { bg = c.bg1 })
set_hl("Visual", { bg = c.bg2 })
set_hl("MatchParen", { bg = c.bg3 })
-- Telescope
set_hl("TelescopeNormal", { bg = c.none })
set_hl("TelescopeBorder", { bg = c.none })
-- Cmp
set_hl("CmpItemAbbrMatch", { fg = c.orange })
set_hl("CmpItemAbbrMatchFuzzy", { fg = c.orange })
set_hl("markdownBoldItalic", { fg = c.orange, italic = true, bold = true })
-- Git
set_hl("diffAdded", { fg = c.green })
set_hl("diffChanged", { fg = c.red })
set_hl("diffRemoved", { fg = c.red })
