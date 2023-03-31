require("null-ls").setup {
  -- debug = true,
  border = "single",
  on_attach = function(client, bufnr)
    print("null-ls attached")
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
