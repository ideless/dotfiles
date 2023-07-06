require("mason").setup {
  ui = {
    border = "single",
  },
}

require("mason-lspconfig").setup {
  ensure_installed = {},
}
-- automatic lsp server setup
local on_lsp_attach = function(client, bufnr)
  -- print("lsp attached")
  -- keymap
  -- local keymap = require("keymap")
  -- keymap.lsp_set_keymap(client, bufnr)
end

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {
      on_attach = on_lsp_attach,
    }
  end,
  -- Next, you can provide targeted overrides for specific servers.
  -- See https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers for avaliable server names
  -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md for list of configs
  ["pyright"] = function()
    require("lspconfig").pyright.setup {
      on_attach = on_lsp_attach,
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

local null_ls = require("null-ls")

require("mason-null-ls").setup {
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