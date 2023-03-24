local null_ls = require("null-ls")

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
  sources = {
    -- Formatting
    null_ls.builtins.formatting.autopep8, -- python
    null_ls.builtins.formatting.beautysh, -- bash, csh, ksh, sh, zsh
    null_ls.builtins.formatting.latexindent, -- tex
    null_ls.builtins.formatting.clang_format, -- c, cpp, cs, java, cuda, proto
    null_ls.builtins.formatting.prettierd, -- javascript, javascriptreact, typescript, typescriptreact, vue, css, scss, less, html, json, jsonc, yaml, markdown, markdown.mdx, graphql, handlebars
  },
  on_attach = function(client, bufnr)
    print("null-ls attached")
    if client.supports_method("textDocument/formatting") then
      -- format on save
      vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
      vim.api.nvim_create_autocmd(event, {
        buffer = bufnr,
        group = group,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = async })
        end,
        desc = "[lsp] format on save",
      })
    end
  end,
})
