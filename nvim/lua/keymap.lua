function set_keymap(modes, lhs, rhs, opts)
  -- default options
  local options = { noremap = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  -- set key map for each mode
  for m in modes:gmatch"." do
    vim.keymap.set(m, lhs, rhs, options)
  end
end

-- Leader key
vim.g.mapleader = ' '

-- window operations
set_keymap("n", "<C-w>\\", ":vsplit<CR>")
set_keymap("n", "<C-w>-", ":split<CR>")

-- comment (<C-_> = Ctrl+/)
set_keymap("i", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("nx", "<C-_>", ":CommentToggle<CR>")

-- Neo Tree
set_keymap("n", "<Leader>e", ":NeoTreeShowInSplitToggle<CR>")

-- Telescope
set_keymap("n", "<Leader>ff", ":Telescope find_files<CR>")
set_keymap("n", "<Leader>fg", ":Telescope live_grep<CR>")
set_keymap("n", "<Leader>fb", ":Telescope buffers<CR>")
set_keymap("n", "<Leader>fh", ":Telescope help_tags<CR>")
