local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

local format = require("format")

return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lspconfig.ui.windows").default_options = {
        border = "single",
      }

      -- diagnostic sign
      local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
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

      wk.register({
        -- leave definition/references/implementations/type definitions to rouble
        D = { vim.lsp.buf.declaration, "Goto Declaration" },
        K = { vim.lsp.buf.signature_help, "Signature Help" },
      }, { prefix = "g" })

      wk.register {
        K = { vim.lsp.buf.hover, "Hover" },
        ["]d"] = { diagnostic_goto(true), "Next Diagnostic" },
        ["[d"] = { diagnostic_goto(false), "Prev Diagnostic" },
        ["]e"] = { diagnostic_goto(true, "ERROR"), "Next Error" },
        ["[e"] = { diagnostic_goto(false, "ERROR"), "Prev Error" },
        ["]w"] = { diagnostic_goto(true, "WARN"), "Next Warning" },
        ["[w"] = { diagnostic_goto(false, "WARN"), "Prev Warning" },
      }

      wk.register({
        a = { vim.lsp.buf.code_action, "Code action" },
        r = { vim.lsp.buf.rename, "Rename" },
      }, { prefix = "<Leader>" })
    end,
  },

  -- more lsp (formatter, dap, linter)
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
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
                if format.autoformat then
                  format.format()
                end
              end,
              desc = "[lsp] format on save",
            })
          end
        end,
      }
    end,
    config = function(_, opts)
      require("null-ls").setup(opts)

      vim.keymap.set(
        { "i", "n" },
        "<A-s>",
        format.save_without_format,
        { silent = true, desc = "Save without formatting" }
      )
    end,
  },

  -- A pretty list for showing diagnostics
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<Leader>dd", desc = "Toggle diagnostics (document)" },
      { "<Leader>dw", desc = "Toggle diagnostics (workspace)" },
      { "<Leader>dl", desc = "Toggle loclist" },
      { "<Leader>dq", desc = "Toggle quickfix" },
      { "gr", desc = "Goto references" },
      { "gd", desc = "Goto definitions" },
      { "gI", desc = "Goto implementations" },
      { "gt", desc = "Goto type definitions" },
    },
    opts = {},
    config = function(_, opts)
      local wk = require("which-key")

      wk.register({
        d = { "<Cmd>TroubleToggle document_diagnostics<CR>", "Toggle diagnostics (document)" },
        D = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", "Toggle diagnostics (workspace)" },
        l = { "<Cmd>TroubleToggle loclist<CR>", "Toggle loclist" },
        q = { "<Cmd>TroubleToggle quickfix<CR>", "Toggle quickfix" },
      }, { prefix = "<Leader>d" })

      wk.register({
        r = { "<Cmd>TroubleToggle lsp_references<CR>", "Goto references" },
        d = { "<Cmd>TroubleToggle lsp_definitions<CR>", "Goto definitions" },
        i = { "<Cmd>TroubleToggle lsp_implementations<CR>", "Goto implementations" },
        t = { "<Cmd>TroubleToggle lsp_type_definitions<CR>", "Goto type definitions" },
      }, { prefix = "g" })
    end,
  },
}
