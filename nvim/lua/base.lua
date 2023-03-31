-- basic
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fileencodings = { "utf-8", "ucs-bom", "gb18030", "gbk", "gb2312", "cp936" }

-- tab
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.backspace = { "indent", "eol", "start" }

-- clipboard
-- neovim's clipboard.vim takes a long time finding the right clipboard provider (~950ms for WSL)
-- vim.g.clipboard = {
--     name = "WslClipboard",
--     copy = {
--         ["+"] = "clip.exe",
--         ["*"] = "clip.exe",
--     },
--     paste = {
--         ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--         ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
--     },
--     cache_enabled = 0,
-- }
vim.opt.clipboard = ""

-- columns
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"

-- others
vim.opt.scrolloff = 5
vim.opt.laststatus = 0
