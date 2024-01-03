--[[
-- Basic settings
--]]

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
vim.opt.clipboard = ""

-- window
vim.opt.splitbelow = true
vim.opt.splitright = true

-- others
vim.opt.scrolloff = 5
vim.opt.laststatus = 0

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

-- exrc: enable reading of .nvim.lua, .nvimrc and .exrc
vim.opt.exrc = true

--[[
-- Basic settings
--]]

local map = function(modes, lhs, rhs, opts)
  -- default options
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  -- set key map for each mode
  for m in modes:gmatch(".") do
    vim.keymap.set(m, lhs, rhs, options)
  end
end

vim.g.mapleader = " "

-- highlight
map("in", "<Esc>", "<Cmd>noh<CR><Esc>", { desc = "Escape and clear hlsearch" })

-- window operations
map("n", "<C-w>\\", ":vsplit<CR>")
map("n", "<C-w>-", ":split<CR>")

-- conventional shortcuts
map("in", "<C-s>", "<Cmd>w<CR>")
map("in", "<C-z>", "<Cmd>u<CR>")
map("n", "<C-a>", "gg^vG$")

-- motions
map("i", "<A-h>", "<Left>")
map("i", "<A-l>", "<Right>")
map("i", "<A-j>", "<Down>")
map("i", "<A-k>", "<Up>")
map("i", "<A-w>", "<Esc>lwi")
map("i", "<A-W>", "<Esc>lWi")
map("i", "<A-e>", "<Esc>ea")
map("i", "<A-E>", "<Esc>Ea")
map("i", "<A-b>", "<Esc>lbi")
map("i", "<A-B>", "<Esc>lBi")
map("nxo", "H", "^")
map("nxo", "L", "$")

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Move Lines
map("n", "<C-j>", "<cmd>m .+1<CR>==", { desc = "Move down" })
map("n", "<C-k>", "<cmd>m .-2<CR>==", { desc = "Move up" })
-- map("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move up" })
map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- Don't leave visual mode when changing indent
map("x", ">", ">gv")
map("x", "<", "<gv")

-- disable annoying keymaps
map("n", "q:", "<nop>")

-- <C-c> not triggering InsertLeave event
map("i", "<C-c>", "<Esc>")

-- search for visually selected text
map("x", "|", "y:let @/=@0<CR>:set hlsearch<CR>")

-- Escape from terminal mode
map("t", "<A-[>", "<C-\\><C-n>")

-- auto indent when editing empty lines
map("n", "i", function()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true })

-- smart close
map("n", "<Leader>x", function()
  -- if there are more than one splits, close the current split
  if utils.count_split() > 1 then
    vim.cmd("close")
    return
  end

  -- otherwise close the current buffer
  vim.api.nvim_buf_delete(0, { force = true })
end, { desc = "Smart close" })

map("n", "<Leader>X", function()
  -- if there are more than one splits, close other split
  if utils.count_split() > 1 then
    vim.cmd("only")
    return
  end

  -- otherwise close all but current buffer
  vim.cmd("%bd!|e#|bd#")
end, { desc = "Smart close others" })

-- toggle spell check
map("n", "<Leader>us", function()
  vim.wo.spell = not vim.wo.spell
end, { desc = "Toggle spell check" })

-- run current buffer as script
map("n", "<Leader>ur", function()
  -- save first
  vim.cmd("w")
  -- get current buffer filetype
  local ft = vim.bo.filetype
  -- use different commands for different filetypes
  if ft == "lua" then
    vim.cmd("luafile %")
  elseif ft == "python" then
    vim.cmd("!python3 %")
  elseif ft == "sh" then
    vim.cmd("!bash %")
  elseif ft == "javascript" then
    vim.cmd("!node %")
  elseif ft == "typescript" then
    vim.cmd("!ts-node %")
  else
    print("Unsupported filetype: " .. ft)
  end
end, { desc = "Run as script" })

-- toggle relative line number
map("n", "<Leader>un", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative line number" })
