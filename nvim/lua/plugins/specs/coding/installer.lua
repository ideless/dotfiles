return {
  -- language server installer
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "single",
      },
    },
  },

  -- mason with lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
    },
    config = function(_, opts)
      local mason_lsp = require("mason-lspconfig")

      mason_lsp.setup(opts)

      mason_lsp.setup_handlers {
        function(server_name) -- default handler
          require("lspconfig")[server_name].setup {}
        end,
        ["pyright"] = function()
          require("lspconfig").pyright.setup {
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  diagnosticMode = "workspace",
                  useLibraryCodeForTypes = true,
                  -- Most of code types are missing. VSCode disables it by default :P
                  typeCheckingMode = "off",
                },
              },
            },
          }
        end,
      }
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")

      return {
        ensure_installed = {},
        automatic_setup = true,
        handlers = {
          latexindent = function(source_name, methods)
            null_ls.register(null_ls.builtins.formatting.latexindent.with {
              extra_args = {
                "-l", -- look for configs in current dir
                "-m", -- allow modifying line breaks
              },
            })
          end,
        },
      }
    end,
  },
}
