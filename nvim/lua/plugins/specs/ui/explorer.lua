return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<Leader>e", desc = "Toggle explorer" },
      { "<Leader>E", desc = "Toggle explorer (side)" },
    },
    opts = function()
      local utils = require("utils")

      require("which-key").register({
        e = { ":NeoTreeFloatToggle<CR>", "Toggle explorer" },
        E = { ":NeoTreeShowToggle<CR>", "Toggle explorer (side)" },
      }, { prefix = "<Leader>" })

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
            hide_gitignored = true,
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
        source_selector = {
          winbar = true,
          statusline = false,
          sources = {
            { source = "filesystem", display_name = " 󰉓 Files " },
            -- { source = "buffers", display_name = " 󰈙 Buffers " },
            { source = "git_status", display_name = " 󰊢 Git " },
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
}
