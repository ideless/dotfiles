function set_keymap(mode, lhs, rhs, opts)
  -- default options
  local options = { noremap = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  for m in mode:gmatch"." do
    vim.api.nvim_set_keymap(m, lhs, rhs, options)
  end
end

-- window operations
set_keymap("n", "<C-w>\\", ":vsplit<CR>")
set_keymap("n", "<C-w>-", ":split<CR>")

-- comment
set_keymap("ni", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("x", "<C-_>", ":CommentToggle<CR>")
