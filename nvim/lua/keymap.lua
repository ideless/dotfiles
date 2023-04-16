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

-- inspect hightlight group
set_keymap("n", "<C-h>", function()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end, { silent = false })

-- window operations
set_keymap("n", "<C-w>\\", ":vsplit<CR>")
set_keymap("n", "<C-w>-", ":split<CR>")

-- buffer operations
set_keymap("n", "gb", ":BufferLinePick<CR>")
set_keymap("n", "[b", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
set_keymap("n", "]b", ":BufferLineCycleNext<CR>", { desc = "Previous buffer" })

-- comment (<C-_> = Ctrl+/)
set_keymap("i", "<C-_>", "<Cmd>CommentToggle<CR>")
set_keymap("nx", "<C-_>", ":CommentToggle<CR>")

-- conventional shortcuts
set_keymap("in", "<C-s>", "<Cmd>w<CR>")
set_keymap("in", "<C-z>", "<Cmd>u<CR>")
set_keymap("n", "<C-a>", "gg^vG$")

-- motions
set_keymap("i", "<C-a>", "<C-o>I")
set_keymap("i", "<C-e>", "<End>")
set_keymap("i", "<C-h>", "<Left>")
set_keymap("i", "<C-l>", "<Right>")
set_keymap("i", "<C-j>", "<Down>")
set_keymap("i", "<C-k>", "<Up>")

-- diable annoying keymaps
set_keymap("n", "q:", "<nop>")

-- <C-c> not triggering InsertLeave event
set_keymap("i", "<C-c>", "<Esc>")

-- copilot
M.copilot_set_keymap = function()
  vim.g.copilot_no_tab_map = true
  vim.api.nvim_set_keymap("i", "<S-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
end

-- which-key
M.wk_set_keymap = function()
  local wk = require("which-key")
  -- Magics
  wk.register({
    name = "Magics",
    h = { ":noh<CR>", "Clear highlight" },
    x = { ":bd!<CR>", "Close buffer" },
    X = { ":%bd!|e#|bd#<CR>", "Close all but this buffer" },
    e = { ":NeoTreeFloatToggle<CR>", "Toggle explorer" },
    E = { ":NeoTreeShowToggle<CR>", "Toggle explorer (side)" },
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
    l = { ":Telescope live_grep<CR>", "Live grep" },
    L = { ":Telescope grep_string<CR>", "Grep string under cursor" },
    t = { ":Telescope lsp_document_symbols<CR>", "Symbols" },
    s = { ":Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search" },
    -- d = {
    --   function()
    --     telescope.diagnostics {
    --       bufnr = 0,
    --     }
    --   end,
    --   "Open diagnostics",
    -- },
  }, { prefix = "<Leader>" })
  wk.register({
    name = "Git",
    s = { ":Telescope git_status<CR>", "Status" },
    b = { ":Telescope git_branches<CR>", "Branches" },
    c = { ":Telescope git_commits<CR>", "Commits" },
    C = { ":Telescope git_bcommits<CR>", "Buffer commits" },
    S = { ":Telescope git_stash<CR>", "Stash" },
  }, { prefix = "<Leader>g" })
end

-- cmp
M.cmp_keys = function()
  local cmp = require("cmp")

  local do_nothing = cmp.mapping(function(callback)
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
    ["<C-p>"] = smart_prev,
    ["<CR>"] = do_nothing,
    ["<Tab>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = do_nothing,
    ["<C-x>"] = cmp.mapping.abort(),
  }
  return keys
end

-- lsp
-- set_keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
-- set_keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
M.lsp_set_keymap = function(_client, bufnr)
  --[[
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
  --]]
end

-- ocs52
M.ocs52_set_keymap = function()
  set_keymap("v", "<Leader>y", require("osc52").copy_visual)
end

-- lspsaga
M.lspsaga_set_keymap = function()
  local wk = require("which-key")
  wk.register({
    d = { "<Cmd>Lspsaga goto_definition<CR>", "Definition" },
    D = { "<Cmd>Lspsaga peek_definition<CR>", "Definition (peek)" },
    t = { "<Cmd>Lspsaga goto_type_definition<CR>", "Type definition" },
    T = { "<Cmd>Lspsaga peek_type_definition<CR>", "Type definition (peek)" },
    h = { "<Cmd>Lspsaga lsp_finder<CR>", "LSP finder" },
  }, { prefix = "g" })
  wk.register({
    r = { "<Cmd>Lspsaga rename<CR>", "Rename" },
    a = { "<Cmd>Lspsaga code_action<CR>", "Code Action" },
    d = { "<Cmd>Lspsaga show_buf_diagnostics<CR>", "Diagnostics" },
    o = { "<Cmd>Lspsaga outline<CR>", "Outline" },
  }, { prefix = "<Leader>" })
  set_keymap("n", "K", "<Cmd>Lspsaga hover_doc<CR>")
  set_keymap("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic" })
  set_keymap("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic" })
  set_keymap("n", "[D", function()
    require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, { desc = "Previous error" })
  set_keymap("n", "]D", function()
    require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR }
  end, { desc = "Next error" })
  set_keymap("nt", "<A-t>", "<Cmd>Lspsaga term_toggle<CR>")
end

return M
