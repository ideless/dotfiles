return {
  {
    "nvim-telescope/telescope.nvim",
    commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
    },
    cmd = "Telescope",
    keys = {
      { "<Leader>f", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<Leader>ss", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search" },
      { "<Leader>so", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Search symbols" },
      { "<Leader>sg", "<Cmd>Telescope live_grep<CR>", desc = "Grep in files" },
      { "<Leader>sw", "<Cmd>Telescope grep_string<CR>", desc = "Grep current word in files" },
    },
    config = function()
      -- Trouble integration
      local trouble = require("trouble.providers.telescope")
      local telescope = require("telescope")

      telescope.setup {
        defaults = {
          mappings = {
            i = { ["<C-t>"] = trouble.open_with_trouble },
            n = { ["<C-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end,
  },

  -- A pretty list for showing diagnostics, references, telescope results,
  -- quickfix, location lists and more
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>dd", "<Cmd>TroubleToggle document_diagnostics<CR>", desc = "Toggle diagnostics (document)" },
      { "<Leader>dw", "<Cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Toggle diagnostics (workspace)" },
      { "<Leader>dl", "<Cmd>TroubleToggle loclist<CR>", desc = "Toggle loclist" },
      { "<Leader>dq", "<Cmd>TroubleToggle quickfix<CR>", desc = "Toggle quickfix" },
      { "gr", "<Cmd>TroubleToggle lsp_references<CR>", desc = "Goto references" },
      { "gd", "<Cmd>TroubleToggle lsp_definitions<CR>", desc = "Goto definitions" },
      { "gI", "<Cmd>TroubleToggle lsp_implementations<CR>", desc = "Goto implementations" },
      { "gt", "<Cmd>TroubleToggle lsp_type_definitions<CR>", desc = "Goto type definitions" },
    },
    opts = {},
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment
  -- in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<Leader>dt", "<Cmd>TodoTrouble<CR>", desc = "Todo (Trouble)" },
      { "<Leader>dT", "<Cmd>TodoTrouble keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<Leader>st", "<Cmd>TodoTelescope<CR>", desc = "Todo" },
      { "<Leader>sT", "<Cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", desc = "Todo/Fix/Fixme" },
    },
    config = true,
  },

  -- Clipboard history
  {
    "AckslD/nvim-neoclip.lua",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<Leader>sy", "<Cmd>Telescope neoclip<CR>", desc = "Search yanks" },
      { "<Leader>sm", "<Cmd>Telescope macroscope<CR>", desc = "Search macros" },
    },
    opts = {},
  },
}
