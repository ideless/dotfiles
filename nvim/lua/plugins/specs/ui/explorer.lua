return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<Leader>e", ":Neotree toggle reveal float<CR>", desc = "Toggle explorer", silent = true },
      { "<Leader>E", ":Neotree toggle reveal left<CR>", desc = "Toggle explorer (side)", silent = true },
    },
    opts = function()
      local utils = require("utils")

      return {
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        filesystem = {
          filtered_items = {
            hide_dotfiles = true,
            hide_gitignored = false, -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/147
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              "node_modules",
              ".git",
              "__pycache__",
              "Pipfile.lock",
              "yarn.lock",
              "package-lock.json",
            },
          },
        },
        source_selector = {
          winbar = true,
          statusline = false,
          sources = {
            { source = "filesystem" },
            -- { source = "buffers"},
            { source = "git_status" },
            { source = "document_symbols" },
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
    end,
  },

  {
    "stevearc/oil.nvim",
    keys = {
      { "<Leader>o", ":Oil<CR>", desc = "Open oil explorer", silent = true },
    },
    opts = {
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
      },
      keymaps = {
        ["<Leader>x"] = "actions.close",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
