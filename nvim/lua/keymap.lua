local M = {}
local wk = require("which-key")

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

-- buffer operations
set_keymap('n', '<C-c>', ':bdelete<CR>')
set_keymap('n', 'gb', ':BufferLinePick<CR>')

-- comment (<C-_> = Ctrl+/)
set_keymap("i", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("nx", "<C-_>", ":CommentToggle<CR>")

-- conventional shortcuts
set_keymap("in", "<C-s>", "<Cmd>w<CR>")
set_keymap("in", "<C-z>", "<Cmd>u<CR>")

-- magics
wk.register({
  name = "Magics",
  h = { ":noh<CR>", "Clear highlight" },
  e = { ":NeoTreeFloatToggle<CR>", "Toggle explorer" },
  f = { ":Telescope find_files<CR>", "Find files" },
  g = { ":Telescope live_grep<CR>", "Live grep" },
  d = { function() vim.diagnostic.open_float({ border = 'single' }) end, "Open Diagnostic" }
}, { prefix = "<Leader>" })

-- cmp
M.cmp_keys = function()
  local cmp = require("cmp")
  local smart_esc = cmp.mapping(function(callback)
    if cmp.visible() then
      cmp.abort()
    end
    callback()
  end)
  local smart_cr = cmp.mapping(function(callback)
    if cmp.visible() then
      if cmp.get_selected_entry() then
        cmp.confirm()
      else
        cmp.abort()
        local newline = vim.api.nvim_replace_termcodes("<Esc>o", true, false, true)
        vim.api.nvim_feedkeys(newline, "i", true)
      end
    else
      callback()
    end
  end)
  local smart_scroll_up = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.scroll_docs(5)
    else
      callback()
    end
  end)
  local smart_scroll_down = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.scroll_docs(-5)
    else
      callback()
    end
  end)
  local smart_next = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.select_next_item()
    else
      callback()
    end
  end)
  local smart_prev = cmp.mapping(function(callback)
    if cmp.visible() then
      return cmp.select_prev_item()
    else
      callback()
    end
  end)
  local keys = {
    ["<C-u>"] = smart_scroll_down,
    ["<C-d>"] = smart_scroll_up,
    ["<C-n>"] = smart_next,
    ["<C-j>"] = smart_next,
    ["<C-p>"] = smart_prev,
    ["<C-k>"] = smart_prev,
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = smart_cr,
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = smart_esc,
  }
  return keys
end

M.lsp_set_keymap = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  wk.register({
    d = { vim.lsp.buf.definition, "Definition" },
    D = { vim.lsp.buf.declaration, "Declaration" },
    i = { vim.lsp.buf.implementation, "Implementation" },
    t = { vim.lsp.buf.type_definition, "Type Definition" },
  }, { prefix = "g", buffer = bufnr })
  -- Refactor related mappings
  wk.register({
    name = "Refactor",
    r = { vim.lsp.buf.rename, "Rename" },
    a = { vim.lsp.buf.code_action, "Code Action" },
  }, { prefix = "<Leader>r", buffer = bufnr })
end

return M
