return {
  {
    "nvim-telescope/telescope.nvim",
    commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<Leader>f", "Find files" },
      { "<Leader>ss", "Search" },
      { "<Leader>st", "Search tags" },
      { "<Leader>sg", "Grep in files" },
      { "<Leader>sw", "Grep current word in files" },
    },
    config = function()
      local wk = require("which-key")
      local ts = require("telescope.builtin")

      wk.register({
        f = { ts.find_files, "Find files" },
      }, { prefix = "<Leader>" })

      wk.register({
        name = "Search",
        s = { ts.current_buffer_fuzzy_find, "Search" },
        t = { ts.lsp_document_symbols, "Search tags" },
        g = { ts.live_grep, "Grep in files" },
        w = { ts.grep_string, "Grep current word in files" },
      }, { prefix = "<Leader>s" })
    end,
  },
}
