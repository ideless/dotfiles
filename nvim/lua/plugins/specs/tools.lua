return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-e>",
          accept_word = "<C-Right>",
          next = "<C-Down>",
          prev = "<C-Up>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        tex = false,
      },
    },
  },

  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_view_general_viewer = "okular.exe"
      -- vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }

      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_syntax_enabled = 0
    end,
  },

  -- the builtin ltex code actions (add to dict) is broken
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      server_opts = {
        on_attach = function(client, bufnr) end,
        settings = {
          ltex = {},
        },
      },
      path = ".vscode",
    },
  },
}
