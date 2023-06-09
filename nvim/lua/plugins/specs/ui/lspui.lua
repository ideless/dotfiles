return {
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enabled = false,
        enable_in_insert = false,
        sign = false,
        sign_priority = 0,
        virtual_text = false,
      },
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
      rename = {
        keys = {
          quit = { "<C-c>" },
        },
      },
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)

      local wk = require("which-key")
      local err_level = vim.diagnostic.severity.ERROR

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

      wk.register {
        ["K"] = { "<Cmd>Lspsaga hover_doc<CR>" },
        ["[d"] = { "<Cmd>Lspsaga diagnostic_jump_prev<CR>", "Previous diagnostic" },
        ["]d"] = { "<Cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic" },
        ["[D"] = {
          function()
            require("lspsaga.diagnostic"):goto_prev { severity = err_level }
          end,
          "Previous error",
        },
        ["]D"] = {
          function()
            require("lspsaga.diagnostic"):goto_next { severity = err_level }
          end,
          "Next error",
        },
      }
    end,
  },
}
