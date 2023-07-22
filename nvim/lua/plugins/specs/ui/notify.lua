return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<Leader>ux",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 1000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      { "<Leader>n", ":NoiceDismiss<CR>", desc = "Dismiss notifies", silent = true },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { pattern = "^:", icon = ":", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            cond = function(message)
              local content = message:content()
              local skipped_patterns = {
                "written",
                "lines? yanked",
                "more lines?",
                "fewer lines?",
              }
              for _, pattern in ipairs(skipped_patterns) do
                if content:find(pattern) then
                  return true
                end
              end
              return false
            end,
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              local skipped_clients = {
                "ltex",
              }
              for _, skipped_client in ipairs(skipped_clients) do
                if client == skipped_client then
                  return true
                end
              end
              return false
            end,
          },
          opts = { skip = true },
        },
      },
    },
  },
}
