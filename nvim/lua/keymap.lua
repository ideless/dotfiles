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

-- comment (<C-_> = Ctrl+/)
set_keymap("i", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("nx", "<C-_>", ":CommentToggle<CR>")

-- magics
wk.register({
  name = "Magics",
  h = { ":noh<CR>", "Clear highlight" },
  e = { ":NeoTreeShowInSplitToggle<CR>", "Toggle explorer" },
  f = { ":Telescope find_files<CR>", "Find files" },
  g = { ":Telescope live_grep<CR>", "Live grep" },
  b = { ":BufferLinePick<CR>", "Pick buffer" },
}, { prefix = "<Leader>" })

-- cmp
M.cmp_keys = function()
  local cmp = require("cmp")
  local smart_esc = cmp.mapping(function(callback)
    -- if cmp.visible() then
    --   return cmp.abort()
    -- else
    --   callback()
    -- end
    if cmp.visible() then
      cmp.abort()
    end
    callback()
  end)
  local smart_cr = cmp.mapping(function(callback)
    if cmp.visible() then
      cmp.confirm()
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

return M
