local utils = require("utils")

local M = {}
local map = function(modes, lhs, rhs, opts)
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

-- hightlight
map("n", "<C-i>", ":Inspect<CR>")
map("n", "<C-h>", ":noh<CR>")

-- window operations
map("n", "<C-w>\\", ":vsplit<CR>")
map("n", "<C-w>-", ":split<CR>")

-- conventional shortcuts
map("in", "<C-s>", "<Cmd>w<CR>")
map("in", "<C-z>", "<Cmd>u<CR>")
map("n", "<C-a>", "gg^vG$")

-- motions
map("i", "<C-a>", "<C-o>I")
map("i", "<C-e>", "<End>")
map("i", "<C-h>", "<Left>")
map("i", "<C-l>", "<Right>")
map("i", "<C-j>", "<Down>")
map("i", "<C-k>", "<Up>")

-- diable annoying keymaps
map("n", "q:", "<nop>")

-- <C-c> not triggering InsertLeave event
map("i", "<C-c>", "<Esc>")

-- search for visually selected text with escaping
-- hint: type in :%s//abc/g to replace
map("x", "*", "y/\\V<C-r>=escape(@\",'/\\')<CR><CR>")
map("x", "//", "y/\\V<C-r>=escape(@\",'/\\')<CR>")
map("x", "/s", "y:%s/\\V<C-r>=escape(@\",'/\\')<CR>/")
map("x", "/S", "y:%s/\\V<C-r>=escape(@\",'/\\')<CR>/<C-r>=escape(@\",'/\\')<CR>")

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

-- Bufferline
M.bufferline_set_keymap = function()
  map("n", "gb", ":BufferLinePick<CR>")
  map("n", "[b", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
  map("n", "]b", ":BufferLineCycleNext<CR>", { desc = "Previous buffer" })
end

-- comment
M.comment_set_keymap = function()
  map("i", "<C-_>", "<Cmd>CommentToggle<CR>")
  map("i", "<C-/>", "<Cmd>CommentToggle<CR>")
  map("nx", "<C-_>", ":CommentToggle<CR>")
  map("nx", "<C-/>", ":CommentToggle<CR>")
end

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
    x = {
      function()
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
      end,
      "Close buffer",
    },
    X = { ":%bd!|e#|bd#<CR>", "Close all but this buffer" },
  }, { prefix = "<Leader>" })
end

-- Neo Tree
M.neo_tree_set_keymap = function()
  local wk = require("which-key")
  wk.register({
    e = { ":NeoTreeFloatToggle<CR>", "Toggle explorer" },
    E = { ":NeoTreeShowToggle<CR>", "Toggle explorer (side)" },
  }, { prefix = "<Leader>" })
end

M.neo_tree_keys = function()
  return {
    filesystem = {
      window = {
        mappings = {
          ["i"] = "show_fs_stat",
        },
      },
      commands = {
        show_fs_stat = function(state)
          local node = state.tree:get_node()
          local stat = vim.loop.fs_stat(node.path)
          local str = ""
          str = str .. string.format("Type: %s\n", stat.type)
          str = str .. string.format("Size: %s\n", utils.format_size(stat.size))
          str = str .. string.format("Time: %s\n", utils.format_time(stat.mtime.sec))
          str = str .. string.format("Mode: %s\n", utils.format_mode(stat.mode, stat.type))
          vim.notify(str)
        end,
      },
    },
    window = {
      mappings = {
        ["<C-c>"] = "close_window",
        ["<Space>"] = {
          "toggle_node",
          nowait = true,
        },
      },
    },
  }
end

-- Hop
M.hop_set_keymap = function()
  local wk = require("which-key")
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

-- Telescope
M.telescope_set_keymap = function()
  local wk = require("which-key")
  local ts = require("telescope.builtin")
  wk.register({
    f = { ts.find_files, "Find files" },
    -- d = {
    --   function()
    --     telescope.diagnostics {
    --       bufnr = 0,
    --     }
    --   end,
    --   "Open diagnostics",
    -- },
  }, { prefix = "<Leader>" })
  -- Search
  wk.register({
    name = "Search",
    s = { ts.current_buffer_fuzzy_find, "Search" },
    t = { ts.lsp_document_symbols, "Search tags" },
    g = { ts.live_grep, "Grep in files" },
    c = { ts.grep_string, "Grep current word in files" },
  }, { prefix = "<Leader>s" })
  -- Git
  wk.register({
    name = "Git",
    s = { ts.git_status, "Status" },
    b = { ts.git_branches, "Branches" },
    c = { ts.git_commits, "Commits" },
    C = { ts.git_bcommits, "Buffer commits" },
    S = { ts.git_stash, "Stash" },
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
-- M.lsp_set_keymap = function(_client, bufnr)
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
-- end

-- ocs52
M.ocs52_set_keymap = function()
  map("x", "<Leader>y", require("osc52").copy_visual)
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
    d = { "<Cmd>Lspsaga show_buf_diagnostics<CR>", "Diagnostics of buffer" },
    D = { "<Cmd>Lspsaga show_workspace_diagnostics<CR>", "Diagnostics of workspace" },
    o = { "<Cmd>Lspsaga outline<CR>", "Outline" },
  }, { prefix = "<Leader>" })
  map("n", "K", "<Cmd>Lspsaga hover_doc<CR>")
  map("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic" })
  map("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic" })
  map("n", "[D", function()
    require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR }
  end, { desc = "Previous error" })
  map("n", "]D", function()
    require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR }
  end, { desc = "Next error" })
  -- map("nt", "<A-t>", "<Cmd>Lspsaga term_toggle<CR>")
end

M.lspsaga_keys = function()
  return {
    finder = {
      keys = {
        expand_or_jump = "<Enter>",
        quit = { "q", "<Esc>", "<C-c>" },
      },
    },
    outline = {
      keys = {
        expand_or_jump = "<Enter>",
      },
    },
  }
end

-- Gitsigns
M.gitsigns_set_keymap = function()
  local gs = require("gitsigns")
  local wk = require("which-key")
  map("n", "[h", gs.prev_hunk, { desc = "Previous hunk" })
  map("n", "]h", gs.next_hunk, { desc = "Next hunk" })
  wk.register({
    name = "Hunk",
    s = { gs.stage_hunk, "Stage hunk" },
    u = { gs.undo_stage_hunk, "Undo stage hunk" },
    r = { gs.reset_hunk, "Reset hunk" },
    S = { gs.stage_buffer, "Stage buffer" },
    R = { gs.reset_buffer, "Reset buffer" },
    p = { gs.preview_hunk, "Preview hunk" },
    b = { gs.blame_line, "Blame line" },
    t = { gs.toggle_current_line_blame, "Toggle blame line" },
  }, { prefix = "<Leader>h" })
  wk.register({
    d = { gs.diffthis, "Diff" },
    D = {
      function()
        gs.diffthis("~")
      end,
      "Diff against last commit",
    },
  }, { prefix = "<Leader>g" })
end

-- ToggleTerm
M.toggleterm_set_keymap = function()
  map("intx", "<A-t>", "<Cmd>ToggleTerm direction=float<CR>")
  map("intx", "<A-T>\\", "<Cmd>ToggleTerm direction=vertical<CR>")
  map("intx", "<A-T>-", "<Cmd>ToggleTerm direction=horizontal<CR>")
  map("n", "<C-\\>", "<Cmd>ToggleTermSendCurrentLine<CR>")
  map("x", "<C-\\>", ":ToggleTermSendVisualLines<CR>")
end

-- Spectre
M.spectre_set_keymap = function()
  local wk = require("which-key")
  wk.register({
    name = "Search",
    r = { "<Cmd>Spectre<CR>", "Replace in files" },
  }, { prefix = "<Leader>s" })
end

return M
