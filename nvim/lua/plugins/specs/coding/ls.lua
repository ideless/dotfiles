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
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
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
