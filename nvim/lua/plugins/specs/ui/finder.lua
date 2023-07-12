return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
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
    end,
  },
}
