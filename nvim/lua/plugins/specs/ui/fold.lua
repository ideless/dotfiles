return {
  -- modern fold
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "folke/which-key.nvim" },
    keys = {
      { "zR", desc = "Open all folds" },
      { "zM", desc = "Close all folds" },
      { "zK", desc = "Peek fold" },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        -- https://www.youtube.com/watch?v=f_f08KnAJOQ
        return { "lsp", "indent" }
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      local language_servers = require("lspconfig").util.available_servers()
      for _, ls in ipairs(language_servers) do
        require("lspconfig")[ls].setup {
          capabilities = capabilities,
        }
      end

      local wk = require("which-key")
      wk.register({
        name = "+fold",
        R = { require("ufo").openAllFolds, "Open all folds" },
        M = { require("ufo").closeAllFolds, "Close all folds" },
        K = {
          function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
              vim.lsp.buf.hover()
            end
          end,
          "Peek fold",
        },
      }, { prefix = "z" })

      require("ufo").setup(opts)
    end,
  },
}
