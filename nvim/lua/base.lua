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
vim.cmd([[
  augroup AutoReload
    autocmd!
    autocmd FocusGained * lua check_reload()
  augroup END
]])
function check_reload()
  if vim.bo.modified then -- Check if the buffer has been modified
    print("Reloading file: " .. vim.fn.expand("%"))
    vim.cmd("edit!") -- Reload the file
  end
end
