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
      }, { prefix = "<Leader>" })

      wk.register({
        name = "Search",
        s = { ts.current_buffer_fuzzy_find, "Search" },
        t = { ts.lsp_document_symbols, "Search tags" },
        g = { ts.live_grep, "Grep in files" },
        c = { ts.grep_string, "Grep current word in files" },
      }, { prefix = "<Leader>s" })
    end,
  },
}
