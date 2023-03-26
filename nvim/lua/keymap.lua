local M = {}

function set_keymap(modes, lhs, rhs, opts)
  -- default options
  local options = { noremap = true }
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

-- window operations
set_keymap("n", "<C-w>\\", ":vsplit<CR>")
set_keymap("n", "<C-w>-", ":split<CR>")

-- buffer operations
set_keymap("n", "<C-c>", ":bd<CR>")
set_keymap("n", "gb", ":BufferLinePick<CR>")

-- comment (<C-_> = Ctrl+/)
set_keymap("i", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("nx", "<C-_>", ":CommentToggle<CR>")

-- conventional shortcuts
set_keymap("in", "<C-s>", "<Cmd>w<CR>")
set_keymap("in", "<C-z>", "<Cmd>u<CR>")

-- diable annoying keymaps
set_keymap("n", "q:", "<nop>")

-- diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

-- which-key
M.wk_set_keymap = function()
  local wk = require("which-key")
  -- Magics
  wk.register({
    name = "Magics",
    h = { ":noh<CR>", "Clear highlight" },
    c = { ":%bd|e#|bd#<CR>", "Close all but this buffer" },
    e = { ":NeoTreeFloatToggle<CR>", "Toggle explorer" },
  }, { prefix = "<Leader>" })
  -- Hop
  wk.register({
    name = "Hop",
    a = { ":HopAnywhere<CR>", "Anywhere" },
    c = { ":HopChar1<CR>", "Character" },
    l = { ":HopLineStart<CR>", "Line" },
    v = { ":HopVertical<CR>", "Vertical" },
    p = { ":HopPattern<CR>", "Pattern" },
    w = { ":HopWord<CR>", "Word" },
  }, { prefix = ";" })
end

-- telescope
M.telescope_set_keymap = function()
  local wk = require("which-key")
  local telescope = require("telescope.builtin")
  wk.register({
    f = { ":Telescope find_files<CR>", "Find files" },
    g = { ":Telescope live_grep<CR>", "Live grep" },
    t = { ":Telescope treesitter<CR>", "Treesitter symbols" },
    s = { ":Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search" },
    d = {
      function()
        telescope.diagnostics {
          bufnr = 0,
        }
      end,
      "Open diagnostics",
    },
  }, { prefix = "<Leader>" })
end

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
        local newline = vim.api.nvim_replace_termcodes("<Esc>a<CR>", true, false, true)
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
    ["<Tab>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = smart_esc,
  }
  return keys
end

-- lsp
M.lsp_set_keymap = function(_client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  local wk = require("which-key")
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  wk.register({
    d = { vim.lsp.buf.definition, "Definition" },
    D = { vim.lsp.buf.declaration, "Declaration" },
    i = { vim.lsp.buf.implementation, "Implementation" },
    t = { vim.lsp.buf.type_definition, "Type Definition" },
  }, { prefix = "g", buffer = bufnr })
  -- Refactor related mappings
  wk.register({
    r = { vim.lsp.buf.rename, "Rename" },
    a = { vim.lsp.buf.code_action, "Code Action" },
  }, { prefix = "<Leader>", buffer = bufnr })
end

return M
