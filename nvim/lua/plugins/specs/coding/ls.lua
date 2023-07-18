return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig.ui.windows").default_options = {
        border = "single",
      }

      -- diagnostic sign
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- load and reload lsp
      local wk = require("which-key")

      wk.register({
        s = { "<Cmd>LspStart<CR>", "Start LSP" },
        S = { "<Cmd>LspStop<CR>", "Stop LSP" },
        r = { "<Cmd>LspRestart<CR>", "Restart LSP" },
        i = { "<Cmd>LspInfo<CR>", "LSP info" },
        l = { "<Cmd>LspLog<CR>", "LSP log" },
      }, { prefix = "<Leader>l" })
    end,
  },

  -- more lsp (formatter, dap, linter)
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "plenary.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")

      return {
        -- debug = true,
        sources = {
          null_ls.builtins.formatting.bibclean,
        },
        border = "single",
        on_attach = function(client, bufnr)
          -- print("null-ls attached")
          if client.supports_method("textDocument/formatting") then
            -- format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format {
                  bufnr = bufnr,
                  filter = function(client)
                    return client.name == "null-ls"
                  end,
                }
              end,
              desc = "[lsp] format on save",
            })
          end
        end,
      }
    end,
  },
}
