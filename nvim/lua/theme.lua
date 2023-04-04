function set_hl(group, val)
  vim.api.nvim_set_hl(0, group, val)
end

function set_terminal_colors(colors)
  -- dark
  vim.g.terminal_color_0 = colors.black
  vim.g.terminal_color_8 = colors.terminal_black

  -- light
  vim.g.terminal_color_7 = colors.fg_dark
  vim.g.terminal_color_15 = colors.fg

  -- colors
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_9 = colors.red

  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_10 = colors.green

  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_11 = colors.yellow

  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_12 = colors.blue

  vim.g.terminal_color_5 = colors.magenta
  vim.g.terminal_color_13 = colors.magenta

  vim.g.terminal_color_6 = colors.cyan
  vim.g.terminal_color_14 = colors.cyan
end

-- colors
local colors = {
  none = "NONE",
  fg = "#ffffff",
  fg_dark = "#a9b1d6",
  fg_gutter = "#c0caf5",
  bg = "#24283b",
  bg_dark = "#1f2335",
  bg_highlight = "#292e42",
  terminal_black = "#414868",
  blue = "#61afef",
  cyan = "#7dcfff",
  magenta = "#c74ae1",
  purple = "#9d7cd8",
  orange = "#f39c12",
  yellow = "#ffe666",
  green = "#87e072",
  red = "#f7768e",
  comment = "#666666",
}

-- setup colors
if vim.g.colors_name then
  vim.cmd("hi clear")
end

vim.o.termguicolors = true
vim.g.colors_name = "custom"

-- setup highlights
local c = colors

set_hl("Comment", { fg = c.comment })

set_hl("Constant", { fg = c.orange }) -- any constant
set_hl("String", { fg = c.green })
set_hl("Character", { fg = c.green })

set_hl("Statement", { fg = c.magenta, italic = true })
set_hl("Keyword", { fg = c.magenta, italic = true })
set_hl("Operator", { fg = c.red })

set_hl("Function", { fg = c.yellow })
set_hl("Identifier", { fg = c.cyan }) -- variables

set_hl("@tag", { fg = c.cyan }) -- html tag
set_hl("@tag.attribute", { fg = c.yellow, italic = true })

set_hl("LineNr", { fg = c.fg_gutter }) -- line number

set_hl("FloatBorder", { bg = c.none })
set_hl("NormalFloat", { bg = c.none })

set_hl("Pmenu", { bg = c.bg_dark })
set_hl("Visual", { bg = c.bg_highlight })

set_hl("SignColumn", { bg = c.none })
set_hl("ColorColumn", { bg = c.bg_dark })

set_hl("TelescopeNormal", { bg = c.none })
set_hl("TelescopeBorder", { bg = c.none })

set_hl("CmpItemAbbrMatch", { fg = c.orange })
set_hl("CmpItemAbbrMatchFuzzy", { fg = c.orange })

-- highlight the current line
vim.opt.cursorline = true
vim.cmd([[
  augroup CursorLine
    autocmd!
    autocmd FileType TelescopePrompt* setlocal nocursorline
    autocmd WinEnter,BufEnter * setlocal cursorline
    autocmd WinLeave,BufLeave * setlocal nocursorline
  augroup END
]])
set_hl("CursorLine", { bg = c.bg_dark })
