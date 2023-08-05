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

-- Leader key
vim.g.mapleader = " "

-- hightlight
map("n", "<Leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("in", "<Esc>", "<Cmd>noh<CR><Esc>", { desc = "Escape and clear hlsearch" })

-- window operations
map("n", "<C-w>\\", ":vsplit<CR>")
map("n", "<C-w>-", ":split<CR>")
map("nitx", "<A-h>", "<Cmd>wincmd h<CR>")
map("nitx", "<A-j>", "<Cmd>wincmd j<CR>")
map("nitx", "<A-k>", "<Cmd>wincmd k<CR>")
map("nitx", "<A-l>", "<Cmd>wincmd l<CR>")

-- conventional shortcuts
map("in", "<C-s>", "<Cmd>w<CR>")
map("in", "<C-z>", "<Cmd>u<CR>")
map("n", "<C-a>", "gg^vG$")

-- motions
-- map("i", "<C-a>", "<C-o>I")
-- map("i", "<C-e>", "<End>") -- useless, and conflicts with Copilot
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")
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

-- diable annoying keymaps
map("n", "q:", "<nop>")

-- <C-c> not triggering InsertLeave event
map("i", "<C-c>", "<Esc>")

-- search for visually selected text
-- hint: type :%s//abc/g to replace, <C-r>/ to paste the last search
map("x", "*", "y:let @/=@0<CR>n")
map("x", "8", "y:let @/=@0<CR>:set hlsearch<CR>")
map("x", "#", "y:let @/=@0<CR>N")
map("x", "3", "y:let @/=@0<CR>:set hlsearch<CR>")

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

-- close buffer
map("n", "<Leader>x", function()
  -- close all buffers whose path starts with "gitsigns://" if there are
  -- any, and otherwise close the current buffer
  local gitsigns_bufs_exist = false
  local buf_list = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buf_list) do
    local buf_path = vim.api.nvim_buf_get_name(buf)
    if string.match(buf_path, "^gitsigns://") then
      gitsigns_bufs_exist = true
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  if not gitsigns_bufs_exist then
    vim.api.nvim_buf_delete(0, { force = true })
  end
end, { desc = "Close buffer" })
map("n", "<Leader>X", ":%bd!|e#|bd#<CR>", { desc = "Close all but this buffer" })
