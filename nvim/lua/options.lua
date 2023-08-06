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

--indent
vim.opt.autoindent = true
vim.opt.smartindent = true

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

-- window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- others
vim.opt.scrolloff = 5
vim.opt.laststatus = 0
vim.o.termguicolors = true

-- cursorline
vim.opt.cursorline = true
vim.cmd([[
  augroup CursorLine
    autocmd!
    autocmd FileType TelescopePrompt* setlocal nocursorline
    autocmd WinEnter,BufEnter * setlocal cursorline
    autocmd WinLeave,BufLeave * setlocal nocursorline
  augroup END
]])

-- Auto reload file when it's changed on disk, when focus
vim.opt.autoread = true
vim.cmd([[
  augroup AutoReload
    autocmd CursorHold * checktime
  augroup END
]])

-- visualize whitespaces
vim.opt.list = true

-- ignore case
vim.opt.ignorecase = true
vim.opt.smartcase = true -- do not ignore case when a upper case is typed

-- check spell
vim.opt.spelllang = "en_us"
vim.opt.spell = false
