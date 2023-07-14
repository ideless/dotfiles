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
    ft = { "markdown", "tex" }, -- TODO: it gets load when opening diagnostic of other ls
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      path = ".vscode",
    },
  },

  -- task runner
  {
    "stevearc/overseer.nvim",
    dependencies = {
      "stevearc/dressing.nvim",
    },
    opts = {},
    config = function(_, opts)
      require("overseer").setup(opts)

      local wk = require("which-key")

      wk.register({
        name = "Tasks",
        o = { ":OverseerToggle<CR>", "Toggle window" },
        s = { ":OverseerSaveBundle<CR>", "Save bundle" },
        l = { ":OverseerLoadBundle<CR>", "Load bundle" },
        d = { ":OverseerDeleteBundle<CR>", "Delete bundle" },
        t = { ":OverseerRun<CR>", "Run a task from a template" },
        T = { ":OverseerRunCmd<CR>", "Run a raw shell command" },
        i = { ":OverseerInfo<CR>", "Display diagnostic information" },
        b = { ":OverseerBuild<CR>", "Open the task builder" },
        q = { ":OverseerQuickAction<CR>", "Run an action on the most recent/under cursor task" },
        a = { ":OverseerTaskAction<CR>", "Select a task to run an action on" },
        c = { ":OverseerClearCache<CR>", "Clear the task cache" },
      }, { prefix = "<Leader>t" })
    end,
  },
}
