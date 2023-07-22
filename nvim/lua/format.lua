local M = {}

M.autoformat = true

function M.format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "null-ls"
    end,
  }
end

function M.save_without_format()
  M.autoformat = false
  vim.cmd("w")
  M.autoformat = true
end

return M
