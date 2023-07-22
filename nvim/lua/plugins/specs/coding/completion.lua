return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = function()
      local cmp = require("cmp")

      local do_nothing = cmp.mapping(function(callback)
        callback()
      end)
      local smart_cr = cmp.mapping(function(callback)
        if cmp.visible() then
          if cmp.get_selected_entry() then
            cmp.confirm()
          else
            cmp.abort()
            local newline = vim.api.nvim_replace_termcodes("<Esc>a<CR>", true, false, true)
            vim.api.nvim_feedkeys(newline, "i", true)
          end
        else
          callback()
        end
      end)
      local smart_scroll_up = cmp.mapping(function(callback)
        if cmp.visible() then
          return cmp.scroll_docs(5)
        else
          callback()
        end
      end)
      local smart_scroll_down = cmp.mapping(function(callback)
        if cmp.visible() then
          return cmp.scroll_docs(-5)
        else
          callback()
        end
      end)
      local smart_next = cmp.mapping(function(callback)
        if cmp.visible() then
          return cmp.select_next_item()
        else
          callback()
        end
      end)
      local smart_prev = cmp.mapping(function(callback)
        if cmp.visible() then
          return cmp.select_prev_item()
        else
          callback()
        end
      end)

      return {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert {
          ["<C-u>"] = smart_scroll_down,
          ["<C-d>"] = smart_scroll_up,
          ["<C-n>"] = smart_next,
          ["<C-p>"] = smart_prev,
          ["<CR>"] = do_nothing,
          ["<Tab>"] = cmp.mapping.confirm { select = true },
          ["<C-e>"] = do_nothing,
          ["<C-x>"] = cmp.mapping.abort(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
          { name = "nvim_lsp_signature_help" },
        }, {
          { name = "buffer" },
        }),
        preselect = cmp.PreselectMode.Item,
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")

      cmp.setup(opts)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        completion = { completeopt = "menu,menuone,noinsert,noselect" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        completion = { completeopt = "menu,menuone,noinsert,noselect" },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
